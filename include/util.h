#pragma once

#include <llvm/IR/Value.h>
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

constexpr bool debug_default = DEBUG_DEFAULT;
constexpr bool show_llvm_ir = DEBUG_DEFAULT;        // whether to display llvm IR info
constexpr bool show_llvm_prompt = false;            // whether to display llvm prompt
constexpr bool show_jit_evaluate_result = false;    // whether to display JIT evaluate result
constexpr bool show_jit_session = true;             // whether to display JIT session
constexpr bool show_token_cnt = false;              // whether to print token cnt
constexpr bool jit_or_emit_obj = true;              // true is JIT mode, false is emit_obj mode
constexpr bool turn_on_jit = jit_or_emit_obj;       // whether to turn on JIT mode
constexpr bool emit_object_file = !jit_or_emit_obj; // whether to emit object file
constexpr bool show_input_prompt =
    !DEBUG_DEFAULT && jit_or_emit_obj; // whether to print input prompt to users
} // namespace debug
