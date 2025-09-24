#include "global.h"
#include "KaleidoscopeJIT.h"
#include "ast.h"

std::string GlobIdentifierStr;
double GlobNumVal;
char GlobCharLiteral;
std::string GlobTokErrorInfo;
int GlobCurTok;
int GlobTokCnt = 0;

// llvm relative global variables
std::unique_ptr<llvm::LLVMContext> TheContext;
std::unique_ptr<llvm::IRBuilder<>> Builder;
std::unique_ptr<llvm::Module> TheModule;
llvm::ExitOnError ExitOnErr;

std::map<std::string, llvm::AllocaInst *> localVars; // local variables in current function scope
std::map<std::string, std::unique_ptr<PrototypeExprAST>> FunctionProtos;
std::map<char, int> BinopPrecedence;
std::set<char> UnaryOp;

// JIT relative global variable
std::unique_ptr<llvm::orc::KaleidoscopeJIT> TheJIT;
std::unique_ptr<llvm::FunctionPassManager> TheFPM;