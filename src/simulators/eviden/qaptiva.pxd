# qaptiva.pxd — patched to use local stub header

cdef extern from "qaptiva_qdmi/device.h":

    # Dummy init/finalize functions
    int QAPTIVA_QDMI_device_initialize()
    int QAPTIVA_QDMI_device_finalize()

    # Stub struct
    ctypedef struct QAPTIVA_QDMI_Device_Session_impl_d:
        pass

    ctypedef QAPTIVA_QDMI_Device_Session_impl_d* QAPTIVA_QDMI_Device_Session

    # Fake session functions
    int QAPTIVA_QDMI_device_session_alloc(QAPTIVA_QDMI_Device_Session *session)
    void QAPTIVA_QDMI_device_session_free(QAPTIVA_QDMI_Device_Session session)

    
