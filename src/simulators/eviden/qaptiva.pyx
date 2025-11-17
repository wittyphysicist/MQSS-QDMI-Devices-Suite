from libc.stdlib cimport malloc, free

cdef extern int QAPTIVA_QDMI_device_initialize():
    print("Device initialized (Cython backend)")
    return 0  # QDMI_SUCCESS

cdef extern int QAPTIVA_QDMI_device_finalize():
    print("Device finalized (Cython backend)")
    return 0
