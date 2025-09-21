#pragma once

#include "KaleidoscopeJIT.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
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
#include "llvm/Transforms/Utils.h"
#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <llvm-14/llvm/ExecutionEngine/Orc/ThreadSafeModule.h>
#include <llvm-14/llvm/IR/Instructions.h>
#include <map>
#include <memory>
#include <optional>
#include <string>
#include <vector>

// token precedence
#define INVALID_BINARY_OP_PREC -1 // precedenc for invalid binary op
#define ASSIGNMENT_OP_PREC 5      // precedence for: '='
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
    tok_error = -2,
    tok_def = -3,
    tok_extern = -4,
    tok_identifier = -5,
    tok_number = -6,
    tok_if = -7,
    tok_else = -8,
    tok_for = -9,
    tok_unary = -10,        // unary operator
    tok_binary = -11,       // binary operator
    tok_char_literal = -12, // char literal
    tok_var = -13,          // var definition
};

extern std::string GlobIdentifierStr;
extern double GlobNumVal;
extern char GlobCharLiteral;
extern int GlobCurTok;
extern std::string GlobTokErrorInfo;
int getNextToken();
extern int GlobTokCnt;

// parser
void ParseMainLoop();

// llvm relative global vriables
extern std::unique_ptr<llvm::LLVMContext> TheContext;
extern std::unique_ptr<llvm::IRBuilder<>> Builder;
extern std::unique_ptr<llvm::Module> TheModule;
extern std::map<std::string, llvm::AllocaInst *> localVars;
extern std::unique_ptr<llvm::legacy::FunctionPassManager> TheFPM;
class PrototypeExprAST;
extern std::map<std::string, std::unique_ptr<PrototypeExprAST>> FunctionProtos;
extern std::map<char, int> BinopPrecedence;
extern std::set<char> UnaryOp;
extern llvm::ExitOnError ExitOnErr;
extern std::unique_ptr<llvm::orc::KaleidoscopeJIT> TheJIT;
void InitializeModuleAndManager();

// lexer
int GetCurTokPrecedence();