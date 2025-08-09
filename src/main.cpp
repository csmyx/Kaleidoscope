#include "core/global.h"
#include <fmt/core.h>

int main()
{
    // Prime the first token.
    fmt::print(stderr, "ready> ");
    getNextToken();

    // Run the main "interpreter loop" now.
    ParseMainLoop();
    return 0;
}