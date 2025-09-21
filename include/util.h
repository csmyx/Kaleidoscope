#pragma once

#include <llvm-14/llvm/IR/Value.h>
#include <memory>

class ExprAST;
class PrototypeExprAST;
std::unique_ptr<ExprAST> LogError(const char *Str);
std::unique_ptr<PrototypeExprAST> LogErrorP(const char *Str);
llvm::Value *LogErrorV(const char *Str);

namespace debug {
#ifndef DEBUG_DEFAULT
#define DEBUG_DEFAULT 0
#endif

constexpr bool debug_default = (DEBUG_DEFAULT != 0);
constexpr bool show_llvm_ir = debug_default; // whether to display llvm IR info
constexpr bool show_llvm_prompt = false;     // whether to display llvm prompt
constexpr bool show_jit_res = false;         // whether to display JIT result
constexpr bool show_jit_session = true;      // whether to display JIT session
constexpr bool show_input_prompt = false;    // whether to print input prompt to users
constexpr bool show_token_cnt = true;        // whether to print token cnt
} // namespace debug
