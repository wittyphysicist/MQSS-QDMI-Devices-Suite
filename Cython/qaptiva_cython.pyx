# qaptiva_cython.pyx

from libc.math cimport isnan
cimport cython

cpdef object create_remote_qpu(str host):
    """
    Creates a remote QPU connection.

    Parameters
    ----------
    host : str
        "host:port"

    Returns
    -------
    object or None
    """
    cdef str u
    cdef str p
    try:
        from qat.core.qpu import RemoteQPU
        if ":" in host:
            u, p = host.split(":", 1)
            return RemoteQPU(host=u, port=int(p))
        else:
            # default port, if your stack expects one; adjust if needed
            return RemoteQPU(host=host)
    except Exception:
        return None

## a tiny helper function in Cython
## it is introduced for the function submit_noisy_job()
@cython.cfunc
@cython.inline
cdef bint _is_bad(double x) nogil:
    return x <= 0 or isnan(x)

"""
 submit_noisy_job() sends a quantum circuit (written in the language QASM) to a Flask-based backend over HTTP, tells the backend
to simulate it with noise (t1,t2 parameters), and returns the resulting probability distribution of quantum states.
"""
## host: URL of the Flask backend
## qasm_string: the OpenQASM code for the quantum circuit
## nshots: how many times to run the circuit (Monte Carlo sampling)
## t1, t2: noise parameters (relation time and decoherence time)
## QASM: Quantum Assembly Language
cpdef object submit_noisy_job(str host, str qasm_string, int nshots, double t1=40000, double t2=22000):
    """
    Submit a noisy job via HTTP to a Flask backend.

    Returns:
        ["state1,state2,...", p1, p2, ...] on success
        None on handled HTTP errors

    Raises:
        ValueError on invalid inputs
        requests.RequestException on network errors (after printing message)
    """
    cdef dict payload
    cdef object requests, resp, data, result, probs
    cdef list states, probabilities

    # ---- validate inputs (client-side) ----
    if nshots <= 0:
        raise ValueError("nshots must be a positive integer")
    if _is_bad(t1) or _is_bad(t2):
        raise ValueError("t1 and t2 must be positive floats")

    # Preparing the payload (a dictonary that will be converted to JSON)
    payload = {
        "aqasm": qasm_string,
        "t1": t1,
        "t2": t2,
        "nbshots": nshots,
    }

    # This sends the job to the given Flask endpoint using HTTP POST.
    try:
        import requests
        resp = requests.post(host, json=payload, timeout=10)
        if resp.status_code != 200:
            # Server returned an application error; surface and return None
            try:
                print("Error from server:", resp.text)
            except Exception:
                pass
            return None

        data = resp.json()
        result = data.get("result", {})
        probs = result.get("state_probabilities", {})

        # Expect a mapping: { "010": 0.12, "111": 0.88, ... }
        if not isinstance(probs, dict):
            raise ValueError("Malformed server response: 'state_probabilities' must be a dict")

        # For deterministic order, sort states lexicographically
        states = sorted(probs.keys())
        probabilities = [probs[s] for s in states]

        return [",".join(states)] + probabilities

    except Exception as e:
        # Network/JSON/parsing issues -> re-raise so caller can handke
        print("HTTP submit error:",e)
        raise


cpdef object submit_job(object remote_qpu, str qasm_string, int nshots):
    """
    Returns ["state1,state2,...", p1, p2, ...] or None on failure.
    """
    cdef list states = []
    cdef list probs = []
    try:
        from qat.interop.openqasm import OqasmParser
        parser = OqasmParser()
        circuit = parser.compile(qasm_string)
        job = circuit.to_job(nbshots=nshots)
        raw_results = remote_qpu.submit(job)

        for r in raw_results:
            states.append(r.state.bitstring)
            probs.append(float(r.probability))

        return [",".join(states)] + probs
    except Exception:
        return None
