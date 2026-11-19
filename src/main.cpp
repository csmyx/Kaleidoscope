#include "global.h"
#include "util.h"
// #include <llvm/Support/Debug.h>
// #define DEBUG_TYPE "kaleidoscope"

int main() {
    InitializeNativeTraget();

    InitializeJIT();

    // Make the module, which holds all the code.
    InitializeModuleAndManager();

    // Run the main "interpreter loop" now.
    ParseMainLoop();

    if (!debug::turn_on_jit) {
        const char *object_file = "test/test_emit_object/obj.o";
        EmitObjectFile(object_file);
        // llvm::dbgs() << "flushed to " << object_file << "!\n";
    }

    return 0;
}