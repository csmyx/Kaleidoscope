#include "global.h"
#include "util.h"

int main() {
    InitializeNativeTraget();

    InitializeJIT();

    // Make the module, which holds all the code.
    InitializeModuleAndManager();

    // Run the main "interpreter loop" now.
    ParseMainLoop();

    if (!debug::turn_on_jit) {
        EmitObjectFile();
    }

    return 0;
}