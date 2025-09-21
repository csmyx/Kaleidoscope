#include "global.h"
#include "KaleidoscopeJIT.h"
#include "ast.h"
#include <llvm-14/llvm/IR/Instructions.h>

std::string GlobIdentifierStr;
double GlobNumVal;
char GlobCharLiteral;
std::string GlobTokErrorInfo;
int GlobCurTok;
int GlobTokCnt = 0;

// llvm relative global vriables
std::unique_ptr<llvm::LLVMContext> TheContext;
std::unique_ptr<llvm::IRBuilder<>> Builder;
std::unique_ptr<llvm::Module> TheModule;
std::map<std::string, llvm::AllocaInst *> localVars; // local variables in current function scope

// std::unique_ptr<KaleidoscopeJIT> TheJIT;
std::unique_ptr<llvm::legacy::FunctionPassManager> TheFPM;
std::map<std::string, std::unique_ptr<PrototypeExprAST>> FunctionProtos;
std::map<char, int> BinopPrecedence;
std::set<char> UnaryOp;
llvm::ExitOnError ExitOnErr;
std::unique_ptr<llvm::orc::KaleidoscopeJIT> TheJIT;