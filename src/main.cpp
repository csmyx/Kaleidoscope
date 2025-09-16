#include "Kaleidoscope.h"
#include "global.h"
#include <fmt/core.h>

int main() {
    llvm::InitializeNativeTarget();
    llvm::InitializeNativeTargetAsmPrinter();
    llvm::InitializeNativeTargetAsmParser();

    TheJIT = ExitOnErr(llvm::orc::KaleidoscopeJIT::Create());

    // Prime the first token.
    fmt::print(stderr, "ready> ");
    getNextToken();

    // Make the module, which holds all the code.
    InitializeModuleAndManager();

    // Run the main "interpreter loop" now.
    ParseMainLoop();

    // Print out all of the generated code.
    TheModule->print(llvm::errs(), nullptr);

    return 0;
}