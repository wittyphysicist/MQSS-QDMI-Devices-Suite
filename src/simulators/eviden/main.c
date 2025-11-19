#include <stdio.h>
#include <dlfcn.h>

typedef int (*testfunc_t)(int, int);

int main() {
    void* handle = dlopen("./qaptiva.so", RTLD_LAZY | RTLD_GLOBAL);
    if (!handle) {
        fprintf(stderr, "dlopen error: %s\n", dlerror());
        return 1;
    }

    dlerror(); // clear errors

    testfunc_t cy_test_add = (testfunc_t) dlsym(handle, "cy_test_add");
    char* err = dlerror();
    if (err) {
        fprintf(stderr, "dlsym error: %s\n", err);
        return 1;
    }

    int result = cy_test_add(3, 4);
    printf("cy_test_add(3,4) = %d\n", result);

    dlclose(handle);
    return 0;
}

