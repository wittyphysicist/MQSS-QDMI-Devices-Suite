from device cimport *

cdef extern int QAPTIVA_QDMI_device_initialize():
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_finalize():
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_session_alloc(QAPTIVA_QDMI_Device_Session *session):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_session_set_parameter(
        QAPTIVA_QDMI_Device_Session session,
        QDMI_Device_Session_Parameter param,
        size_t size,
        const void *value):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_session_init(QAPTIVA_QDMI_Device_Session session):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern void QAPTIVA_QDMI_device_session_free(QAPTIVA_QDMI_Device_Session session):
    pass


cdef extern int QAPTIVA_QDMI_device_session_query_device_property(
        QAPTIVA_QDMI_Device_Session session,
        QDMI_Device_Property prop,
        size_t size,
        void *value,
        size_t *size_ret):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_session_query_site_property(
        QAPTIVA_QDMI_Device_Session session,
        QAPTIVA_QDMI_Site site,
        QDMI_Site_Property prop,
        size_t size,
        void *value,
        size_t *size_ret):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_session_query_operation_property(
        QAPTIVA_QDMI_Device_Session session,
        QAPTIVA_QDMI_Operation operation,
        size_t num_sites,
        const QAPTIVA_QDMI_Site *sites,
        size_t num_params,
        const double *params,
        QDMI_Operation_Property prop,
        size_t size,
        void *value,
        size_t *size_ret):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_session_create_device_job(
        QAPTIVA_QDMI_Device_Session session,
        QAPTIVA_QDMI_Device_Job *job):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_set_parameter(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Device_Job_Parameter param,
        size_t size,
        const void *value):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_query_property(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Device_Job_Property prop,
        size_t size,
        void *value,
        size_t *size_ret):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_submit(QAPTIVA_QDMI_Device_Job job):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_cancel(QAPTIVA_QDMI_Device_Job job):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_check(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Job_Status *status):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_wait(
        QAPTIVA_QDMI_Device_Job job,
        size_t timeout):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern int QAPTIVA_QDMI_device_job_get_results(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Job_Result result,
        size_t size,
        void *data,
        size_t *size_ret):
    return QDMI_ERROR_NOTIMPLEMENTED


cdef extern void QAPTIVA_QDMI_device_job_free(QAPTIVA_QDMI_Device_Job job):
    pass
