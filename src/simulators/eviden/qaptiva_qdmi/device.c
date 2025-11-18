#include <stdlib.h>
#include "device.h"

int QAPTIVA_QDMI_device_initialize() {
    return 0;  // success
}

int QAPTIVA_QDMI_device_finalize() {
    return 0;  // success
}

int QAPTIVA_QDMI_device_session_alloc(QAPTIVA_QDMI_Device_Session *session) {
    *session = (QAPTIVA_QDMI_Device_Session) malloc(sizeof(QAPTIVA_QDMI_Device_Session_impl_d));
    if (!*session) return -1;
    (*session)->dummy = 0;
    return 0;
}

void QAPTIVA_QDMI_device_session_free(QAPTIVA_QDMI_Device_Session session) {
    free(session);
}
