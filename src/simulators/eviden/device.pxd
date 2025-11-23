from constants cimport *
from types cimport *

cdef extern from "qaptiva_qdmi/device.h":

    ctypedef struct QAPTIVA_QDMI_Device_Session_impl_d:
        pass

    ctypedef QAPTIVA_QDMI_Device_Session_impl_d *QAPTIVA_QDMI_Device_Session


    ctypedef struct QAPTIVA_QDMI_Device_Job_impl_d:
        pass

    ctypedef QAPTIVA_QDMI_Device_Job_impl_d *QAPTIVA_QDMI_Device_Job


    int QAPTIVA_QDMI_device_initialize()
    int QAPTIVA_QDMI_device_finalize()
    int QAPTIVA_QDMI_device_session_alloc(QAPTIVA_QDMI_Device_Session *session)

    int QAPTIVA_QDMI_device_session_set_parameter(
        QAPTIVA_QDMI_Device_Session session,
        QDMI_Device_Session_Parameter param,
        size_t size,
        const void *value
    )

    int QAPTIVA_QDMI_device_session_init(QAPTIVA_QDMI_Device_Session session)
    void QAPTIVA_QDMI_device_session_free(QAPTIVA_QDMI_Device_Session session)


    int QAPTIVA_QDMI_device_session_query_device_property(
        QAPTIVA_QDMI_Device_Session session,
        QDMI_Device_Property prop,
        size_t size,
        void *value,
        size_t *size_ret
    )

    int QAPTIVA_QDMI_device_session_query_site_property(
        QAPTIVA_QDMI_Device_Session session,
        QAPTIVA_QDMI_Site site,
        QDMI_Site_Property prop,
        size_t size,
        void *value,
        size_t *size_ret
    )


    int QAPTIVA_QDMI_device_session_query_operation_property(
        QAPTIVA_QDMI_Device_Session session,
        QAPTIVA_QDMI_Operation operation,
        size_t num_sites,
        const QAPTIVA_QDMI_Site *sites,
        size_t num_params,
        const double *params,
        QDMI_Operation_Property prop,
        size_t size,
        void *value,
        size_t *size_ret
    )


    int QAPTIVA_QDMI_device_session_create_device_job(
        QAPTIVA_QDMI_Device_Session session,
        QAPTIVA_QDMI_Device_Job *job
    )

    int QAPTIVA_QDMI_device_job_set_parameter(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Device_Job_Parameter param,
        size_t size,
        const void *value
    )

    int QAPTIVA_QDMI_device_job_query_property(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Device_Job_Property prop,
        size_t size,
        void *value,
        size_t *size_ret
    )

    int QAPTIVA_QDMI_device_job_submit(QAPTIVA_QDMI_Device_Job job)
    int QAPTIVA_QDMI_device_job_cancel(QAPTIVA_QDMI_Device_Job job)
    int QAPTIVA_QDMI_device_job_check(QAPTIVA_QDMI_Device_Job job, QDMI_Job_Status *status)
    int QAPTIVA_QDMI_device_job_wait(QAPTIVA_QDMI_Device_Job job, size_t timeout)

    int QAPTIVA_QDMI_device_job_get_results(
        QAPTIVA_QDMI_Device_Job job,
        QDMI_Job_Result result,
        size_t size,
        void *data,
        size_t *size_ret
    )

    void QAPTIVA_QDMI_device_job_free(QAPTIVA_QDMI_Device_Job job)
