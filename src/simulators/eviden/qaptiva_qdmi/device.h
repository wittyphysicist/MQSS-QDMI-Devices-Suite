/*------------------------------------------------------------------------------
Copyright 2024 Munich Quantum Software Stack Project
 
Licensed under the Apache License, Version 2.0 with LLVM Exceptions (the
"License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
https://github.com/Munich-Quantum-Software-Stack/QDMI/blob/develop/LICENSE
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.
 
SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------------*/

 
#pragma once
 
#include "qdmi/constants.h" // IWYU pragma: export
#include "qdmi/types.h"     // IWYU pragma: export
 
#ifdef __cplusplus
#include <cstddef>
 
extern "C" {
#else
#include <stddef.h>
#endif
 
// The following clang-tidy warning cannot be addressed because this header is
// used from both C and C++ code.
// NOLINTBEGIN(performance-enum-size,modernize-use-using,modernize-redundant-void-arg)


int QDMI_device_initialize(void);

int QDMI_device_finalize(void);


typedef struct QDMI_Device_Session_impl_d *QDMI_Device_Session;

int QDMI_device_session_alloc(QDMI_Device_Session *session);

int QDMI_device_session_set_parameter(QDMI_Device_Session session,
                                      QDMI_Device_Session_Parameter param,
                                      size_t size, const void *value);

int QDMI_device_session_init(QDMI_Device_Session session);

void QDMI_device_session_free(QDMI_Device_Session session);
 // end of device_session_interface


int QDMI_device_session_query_device_property(QDMI_Device_Session session,
                                              QDMI_Device_Property prop,
                                              size_t size, void *value,
                                              size_t *size_ret);

int QDMI_device_session_query_site_property(QDMI_Device_Session session,
                                            QDMI_Site site,
                                            QDMI_Site_Property prop,
                                            size_t size, void *value,
                                            size_t *size_ret);

int QDMI_device_session_query_operation_property(
    QDMI_Device_Session session, QDMI_Operation operation, size_t num_sites,
    const QDMI_Site *sites, size_t num_params, const double *params,
    QDMI_Operation_Property prop, size_t size, void *value, size_t *size_ret);
 // end of device_query_interface


typedef struct QDMI_Device_Job_impl_d *QDMI_Device_Job;

int QDMI_device_session_create_device_job(QDMI_Device_Session session,
                                          QDMI_Device_Job *job);

int QDMI_device_job_set_parameter(QDMI_Device_Job job,
                                  QDMI_Device_Job_Parameter param, size_t size,
                                  const void *value);

int QDMI_device_job_query_property(QDMI_Device_Job job,
                                   QDMI_Device_Job_Property prop, size_t size,
                                   void *value, size_t *size_ret);

int QDMI_device_job_submit(QDMI_Device_Job job);

int QDMI_device_job_cancel(QDMI_Device_Job job);

int QDMI_device_job_check(QDMI_Device_Job job, QDMI_Job_Status *status);

int QDMI_device_job_wait(QDMI_Device_Job job, size_t timeout);

int QDMI_device_job_get_results(QDMI_Device_Job job, QDMI_Job_Result result,
                                size_t size, void *data, size_t *size_ret);

void QDMI_device_job_free(QDMI_Device_Job job);
 // end of device_job_interface
 // end of device_interface
 
// NOLINTEND(performance-enum-size,modernize-use-using,modernize-redundant-void-arg)
 
#ifdef __cplusplus
} // extern "C"
#endif
