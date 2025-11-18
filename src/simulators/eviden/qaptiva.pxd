cdef extern from "qaptiva_qdmi/device.h":
    int QAPTIVA_QDMI_device_initialize()
    int QAPTIVA_QDMI_device_finalize()

    ctypedef struct QAPTIVA_QDMI_Device_Session_impl_d
    ctypedef QAPTIVA_QDMI_Device_Session_impl_d* QAPTIVA_QDMI_Device_Session

    int QAPTIVA_QDMI_device_session_alloc(QAPTIVA_QDMI_Device_Session *session)
    void QAPTIVA_QDMI_device_session_free(QAPTIVA_QDMI_Device_Session session)

    
