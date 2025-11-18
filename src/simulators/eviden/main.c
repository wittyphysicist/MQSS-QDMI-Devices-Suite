// main.c
#include <stdio.h>
#include <dlfcn.h>

// C function type matching the cdef public in qaptiva.pyx
typedef int (*qaptiva_self_test_fn)(void);

int main(void)
{
   void *handle = NULL;
   qaptiva_self_test_fn self_test = NULL;
   char *err = NULL;

   // 1. Load the Cython-built shared library.
   //    Adjust this path/name to whatever file `setup.py build_ext --inplace`
   //    produces (e.g. qaptiva.cpython-311-x86_64-linux-gnu.so).
   handle = dlopen("./qaptiva.cpython-311-x86_64-linux-gnu.so", RTLD_NOW);
   if (!handle) {
       fprintf(stderr, "dlopen failed: %s\n", dlerror());
       return 1;
   }

   // 2. Clear any old error
   dlerror();

   // 3. Resolve the symbol exported by Cython
   self_test = (qaptiva_self_test_fn)dlsym(handle, "qaptiva_self_test");
   if ((err = dlerror()) != NULL) {
       fprintf(stderr, "dlsym failed: %s\n", err);
       dlclose(handle);
       return 1;
   }

   // 4. Call the function
   int rc = self_test();
   printf("qaptiva_self_test() returned %d\n", rc);

   // 5. Clean up
   dlclose(handle);
   return 0;
}
