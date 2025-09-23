#include "global.h"

int main() {
    InitializeNativeTraget();

    InitializeJIT();

    // Make the module, which holds all the code.
    InitializeModuleAndManager();

    // Run the main "interpreter loop" now.
    ParseMainLoop();

    EmitObjectFile();

    return 0;
}