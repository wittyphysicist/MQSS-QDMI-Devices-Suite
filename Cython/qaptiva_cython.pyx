# qaptiva_cython.pyx

from libc.math cimport isnan
cimport cython

@cython.cfunc
@cython.inline
cdef bint _is_bad(double x) nogil:
    return x <= 0 or isnan(x)


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


cpdef object submit_noisy_job(str host, str qasm_string, int nshots,
                              double t1=40000, double t2=22000):
    """
    Submit a noisy job via HTTP backend.

    Returns
    -------
    ["state1,state2,...", p1, p2, ...] or None on failure.
    """
    if nshots <= 0 or _is_bad(t1) or _is_bad(t2):
        return None

    cdef dict payload = {"aqasm": qasm_string, "t1": t1, "t2": t2, "nbshots": nshots}
    try:
        import requests
        resp = requests.post(host, json=payload, timeout=10)
        if resp.status_code != 200:
            # Optional: print(resp.text) for debugging
            return None

        data = resp.json()
        probs = data.get("result", {}).get("state_probabilities", {})
        if not isinstance(probs, dict):
            return None

        cdef list states = sorted(probs.keys())
        cdef list probabilities = [float(probs[s]) for s in states]
        return [",".join(states)] + probabilities
    except Exception:
        return None


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
