#include "global.h"
#include "Kaleidoscope.h"
#include "ast.h"
#include <llvm-14/llvm/IR/Instructions.h>

std::string GlobIdentifierStr;
double GlobNumVal;
int GlobCurTok;

// llvm relative global vriables
std::unique_ptr<llvm::LLVMContext> TheContext;
std::unique_ptr<llvm::IRBuilder<>> Builder;
std::unique_ptr<llvm::Module> TheModule;
std::map<std::string, llvm::AllocaInst *> NamedValues;

// std::unique_ptr<KaleidoscopeJIT> TheJIT;
std::unique_ptr<llvm::legacy::FunctionPassManager> TheFPM;
// std::unique_ptr<llvm::LoopAnalysisManager> TheLAM;
// std::unique_ptr<llvm::FunctionAnalysisManager> TheFAM;
// std::unique_ptr<llvm::CGSCCAnalysisManager> TheCGAM;
// std::unique_ptr<llvm::ModuleAnalysisManager> TheMAM;
// std::unique_ptr<llvm::PassInstrumentationCallbacks> ThePIC;
// std::unique_ptr<llvm::StandardInstrumentations> TheSI;
std::map<std::string, std::unique_ptr<PrototypeAST>> FunctionProtos;
std::map<char, int> BinopPrecedence;
llvm::ExitOnError ExitOnErr;
std::unique_ptr<llvm::orc::KaleidoscopeJIT> TheJIT;