from libc.stdlib cimport malloc, free

from libc.math cimport isnan

cdef extern int QAPTIVA_QDMI_device_initialize():
    print("Device initialized (Cython backend)")
    return 0  # QDMI_SUCCESS

cdef extern int QAPTIVA_QDMI_device_finalize():
    print("Device finalized (Cython backend)")
    return 0


cpdef object create_remote_qpu(str host):
    """
    Establishes a connection to a remote quantum processing unit (QPU) using myQLM's RemoteQPU interface.

    For instance if the user provides something like "localhost:8080" then the function splits into host and
    port in the following way:
    u = "localhost"
    p = "8080"

    then RemoteQPU(host=u, port=int(p)) creates an object that acts as a proxy. If anything fails, it returns
    'None'
"""
    cdef str u
    cdef str p
    try:
        from qat.core.qpu import RemoteQPU
        if ":" in host:
            u, p = host.split(":", 1)
            return RemoteQPU(host=u, port=int(p)) # myQLM's "RemoteQPU" expects "host=..., port=...".
        else:
            # default port, if your stack expects one; adjust if needed
            return RemoteQPU(host=host)
    except Exception:
        return None


cdef bint _is_bad(double x) nogil:
    """
    a tiny helper function in Cython
    introduced for the function submit_noisy_job()
    """
    return x <= 0 or isnan(x)

cpdef object submit_noisy_job(str host, str qasm_string, int nshots, double t1=40000, double t2=22000):
    """
    sends a quantum circuit (written in the language QASM) to a Flask-based backend over HTTP, tells the backend
    to simulate it with noise (t1,t2 parameters), and returns the resulting probability distribution of quantum states.

    * qasm_string: the OpenQASM code for the quantum circuit
    * nshots: how many times to run the circuit (Monte Carlo sampling)
    * t1, t2: noise parameters (relation time and decoherence time)
    * QASM: Quantum Assembly Language
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
     The function submits a quantum circuit to a remote QPU and collects the results.
    """
    cdef list states = []
    cdef list probs = []
    try:
        from qat.interop.openqasm import OqasmParser # imports 0qasmParser from the qat (myQLM) library
        parser = OqasmParser() # converts a QASM string into an executable form
        circuit = parser.compile(qasm_string) # turns the textual QASM into an internal circuit rep.
        job = circuit.to_job(nbshots=nshots) # creates a job defining how many times the circuit will be executed
        raw_results = remote_qpu.submit(job) # performs the quantum computation

        for r in raw_results:
            states.append(r.state.bitstring) # gives the measured quantum state like "0101"
            probs.append(float(r.probability)) # gives the probability

        return [",".join(states)] + probs # returns the results
    except Exception:
        return None
