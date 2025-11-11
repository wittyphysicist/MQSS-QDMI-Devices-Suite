# qaptiva_cython.pyx

from libc.math cimport isnan
cimport cython



def submit_job(remote_qpu, qasm_string, nshots):
    """! Submits a quantum job to a remote QPU.

    @param remote_qpu A RemoteQPU instance.
    @param qasm_string QASM code string.
    @param nshots Number of shots to run the job.
    @return A list containing measurement states and their probabilities, or None if submission fails.
    """
    try:
        from qat.interop.openqasm import OqasmParser
        parser = OqasmParser()
        circuit = parser.compile(qasm_string)
        job = circuit.to_job(nbshots=nshots)
        raw_results = remote_qpu.submit(job)
        states = []
        probabilities = []
        for result in raw_results:
            states.append(result.state.bitstring)
            probabilities.append((result.probability))
        return_value = [",".join(states)] + list(probabilities)
        return return_value
    except:
        return None



  cpdef object create_remote_qpu(str host):
    """
    Creates a remote QPU connection.

    Parameters
    ----------
    host : str
        Hostname and port in the form "host:port".

    Returns
    -------
    object
        A RemoteQPU instance, or None if connection fails.
    """
    cdef object RemoteQPU, qpu
    cdef str url
    cdef str port

    try:
        from qat.core.qpu import RemoteQPU
        url, port = host.split(":")
        # Convert port to int if the API expects it
        qpu = RemoteQPU(int(port), url)
        return qpu
    except Exception:
        return None



@cython.cfunc
@cython.inline
cdef bint _is_bad(double x) nogil:
    return x <= 0 or isnan(x)

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

    payload = {
        "aqasm": qasm_string,
        "t1": t1,
        "t2": t2,
        "nbshots": nshots,
    }

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
    Submits a quantum job and returns:
        ["state1,state2,...", p1, p2, ...]
    or None on failure.
    """
    cdef object OqasmParser, parser, circuit, job, raw_results, r
    cdef list states = []
    cdef list probs = []

    try:
        from qat.interop.openqasm import OqasmParser
        parser = OqasmParser()
        circuit = parser.compile(qasm_string)
        job = circuit.to_job(nbshots=nshots)
        raw_results = remote_qpu.submit(job)

        for r in raw_results:
            # Assuming result has .state.bitstring and .probability
            states.append(r.state.bitstring)
            probs.append(r.probability)

        return [",".join(states)] + probs
    except Exception:
        # You can `print(e)` or log here if you want visibility
        return None
