#include "global.h"

std::string GlobIdentifierStr;
double GlobNumVal;
int GlobCurTok;

// llvm relative global vriables
std::unique_ptr<llvm::LLVMContext> TheContext;
std::unique_ptr<llvm::IRBuilder<>> Builder;
std::unique_ptr<llvm::Module> TheModule;
std::map<std::string, llvm::Value *> NamedValues;