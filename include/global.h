#pragma once

#include "Kaleidoscope.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/StandardInstrumentations.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Scalar/GVN.h"
#include "llvm/Transforms/Scalar/Reassociate.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <llvm-14/llvm/ExecutionEngine/Orc/ThreadSafeModule.h>
#include <map>
#include <memory>
#include <optional>
#include <string>
#include <vector>

// token precedence
#define INVALID_TOK_PREC -1
#define COMPARE_OP_PREC 10        // precedence for: '<', '>'
#define SUM_OP_PREC 20            // precedence for: '+', '-'
#define MUL_OP_PREC 30            // precedence for: '*', '/'
#define DEFAULT_BINARY_OP_PREC 40 // default precedence for user defined binary op

// prototype kind
#define ID_PROTOTYPE_KIND 0
#define UNARY_PROTOTYPE_KIND 1
#define BINARY_PROTOTYPE_KIND 2

// tokenizer
enum token {
    tok_eof = -1,
    tok_def = -2,
    tok_extern = -3,
    tok_identifier = -4,
    tok_number = -5,
    // control
    tok_if = -6,
    tok_else = -7,
    // loop
    tok_for = -8,
    // operator
    tok_unary = -9,
    tok_binary = -10,
};
extern std::string GlobIdentifierStr;
extern double GlobNumVal;
extern int GlobCurTok;
int getNextToken();

// parser
void ParseMainLoop();

// llvm relative global vriables
extern std::unique_ptr<llvm::LLVMContext> TheContext;
extern std::unique_ptr<llvm::IRBuilder<>> Builder;
extern std::unique_ptr<llvm::Module> TheModule;
extern std::map<std::string, llvm::Value *> NamedValues;
extern std::unique_ptr<llvm::legacy::FunctionPassManager> TheFPM;
// extern std::unique_ptr<llvm::LoopAnalysisManager> TheLAM;
// extern std::unique_ptr<llvm::FunctionAnalysisManager> TheFAM;
// extern std::unique_ptr<llvm::CGSCCAnalysisManager> TheCGAM;
// extern std::unique_ptr<llvm::ModuleAnalysisManager> TheMAM;
// extern std::unique_ptr<llvm::PassInstrumentationCallbacks> ThePIC;
// extern std::unique_ptr<llvm::StandardInstrumentations> TheSI;
class PrototypeAST;
extern std::map<std::string, std::unique_ptr<PrototypeAST>> FunctionProtos;
extern std::map<char, int> BinopPrecedence;
extern llvm::ExitOnError ExitOnErr;
extern std::unique_ptr<llvm::orc::KaleidoscopeJIT> TheJIT;
void InitializeModuleAndManager();