#include "ast.h"
#include "fmt/core.h"
#include "global.h"
#include <memory>

std::unique_ptr<ExprAST> LogError(const char* Str)
{
    fmt::print(stderr, "Error: {}\n", Str);
    return nullptr;
}
std::unique_ptr<PrototypeAST> LogErrorP(const char* Str)
{
    LogError(Str);
    return nullptr;
}

llvm::Value *LogErrorV(const char *Str) {
    LogError(Str);
    return nullptr;
}