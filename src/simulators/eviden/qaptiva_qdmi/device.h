#ifndef QAPTIVA_QDMI_DEVICE_H
#define QAPTIVA_QDMI_DEVICE_H

#include <stdlib.h>

/* Minimal stub type just so Cython has something to refer to */
typedef struct QAPTIVA_QDMI_Device_Session_impl_d {
    int dummy;
} QAPTIVA_QDMI_Device_Session_impl_d;

typedef QAPTIVA_QDMI_Device_Session_impl_d* QAPTIVA_QDMI_Device_Session;

/* Declarations only – no definitions here */
int QAPTIVA_QDMI_device_initialize(void);
int QAPTIVA_QDMI_device_finalize(void);
int QAPTIVA_QDMI_device_session_alloc(QAPTIVA_QDMI_Device_Session *session);
void QAPTIVA_QDMI_device_session_free(QAPTIVA_QDMI_Device_Session session);

#endif /* QAPTIVA_QDMI_DEVICE_H */
