#include "core/global.h"
#include <fmt/core.h>

int main() {
    // Prime the first token.
    fmt::print(stderr, "ready> ");
    getNextToken();

    // Make the module, which holds all the code.
    InitializeModule();

    // Run the main "interpreter loop" now.
    ParseMainLoop();

    // Print out all of the generated code.
    TheModule->print(llvm::errs(), nullptr);

    return 0;
}