#include "KaleidoscopeJIT.h"
#include "ast.h"
#include "fmt/base.h"
#include "fmt/core.h"
#include "global.h"
#include "util.h"
#include <cstdio>
#include <llvm-14/llvm/IR/LegacyPassManager.h>
#include <llvm-14/llvm/MC/TargetRegistry.h>
#include <llvm-14/llvm/Support/CodeGen.h>
#include <llvm-14/llvm/Support/Host.h>
#include <llvm-14/llvm/Support/raw_ostream.h>
#include <llvm-14/llvm/Target/TargetOptions.h>
#include <memory>
#include <optional>
#include <system_error>
#include <unistd.h>

#define EXPECT_AND_EAT_TOKEN(tok)                                                                  \
    do {                                                                                           \
        if (GlobCurTok != tok) {                                                                   \
            return LogError("expected token: " #tok);                                              \
        }                                                                                          \
        getNextToken();                                                                            \
    } while (0)

/// number_expr ::= number
std::unique_ptr<ExprAST> ParseNumberExpr() {
    auto Result = std::make_unique<NumberExprAST>(GlobNumVal);
    getNextToken(); // consume the number
    return std::move(Result);
}

/// char_literal_expr ::= '\'' character '\''
std::unique_ptr<ExprAST> ParseCharLiteralExpr() {
    double v = GlobCharLiteral; // convert char to double
    auto Result = std::make_unique<NumberExprAST>(v);
    getNextToken(); // consume the number
    return std::move(Result);
}

/// parentheses_expr ::= '(' expression ')'
std::unique_ptr<ExprAST> ParseExpression();
std::unique_ptr<ExprAST> ParseParenExpr() {
    assert(GlobCurTok == '(');
    getNextToken(); // eat '('
    auto v = ParseExpression();
    if (!v) {
        return nullptr;
    }
    if (GlobCurTok != ')') {
        return LogError("expected: ')' in parentheses_expr");
    }
    getNextToken();
    return v;
}

/// identifier_expr
///   ::= variable
///   ::= callexpr
/// variable
///   ::= identifier
/// callexpr
///   ::= identifier '(' expression [, expression]* ')'
std::unique_ptr<ExprAST> ParseIdentifierExpr() {
    std::string ident = GlobIdentifierStr;
    getNextToken();
    if (GlobCurTok != '(') {
        return std::make_unique<VariableExprAST>(ident);
    }
    getNextToken(); // eat '('
    std::vector<std::unique_ptr<ExprAST>> args;
    if (GlobCurTok != ')') {
        while (true) {
            auto v = ParseExpression();
            if (!v) {
                return LogError("expected expression");
            }
            args.push_back(std::move(v));
            if (GlobCurTok == ')') {
                break;
            }
            if (GlobCurTok != ',') {
                return LogError("expected: ')' or ',' in argment list");
            }
            getNextToken(); // eat ','
        }
    }
    getNextToken(); // eat ')'

    return std::make_unique<CallExprAST>(ident, std::move(args));
}

/// if_expr ::= if '(' expression ')' expression else expression
std::unique_ptr<ExprAST> ParseIfExpr() {
    assert(GlobCurTok == tok_if);
    getNextToken(); // eat 'if'

    // Parse condition.
    if (GlobCurTok != '(') {
        return LogError("expected: '(' in if_expr");
    }
    getNextToken(); // eat '('
    std::unique_ptr<ExprAST> cond = ParseExpression();
    if (!cond) {
        return nullptr;
    }
    if (GlobCurTok != ')') {
        return LogError("expected: ')' in if_expr");
    }
    getNextToken(); // eat ')'

    // Parse then branch.
    std::unique_ptr<ExprAST> then_br = ParseExpression();
    if (!then_br) {
        return nullptr;
    }

    // Parse else branch.
    if (GlobCurTok != tok_else) {
        return LogError("expected: 'else' in if_expr");
    }
    getNextToken(); // eat 'else'
    std::unique_ptr<ExprAST> else_br = ParseExpression();
    if (!else_br) {
        return nullptr;
    }

    return std::make_unique<IfExprAST>(std::move(cond), std::move(then_br), std::move(else_br));
}

/// for_expr  ::= for '(' init_expr ';' expression ';' step_expr ')' expression else expression
/// init_expr ::= identifier_expr '=' expression
/// step_expr ::= expression*
std::unique_ptr<ExprAST> ParseForExpr() {
    assert(GlobCurTok == tok_for);
    getNextToken(); // eat 'for'

    EXPECT_AND_EAT_TOKEN('(');

    // Parse init_expr.
    if (GlobCurTok != tok_identifier) {
        return LogError("expected: identifier in for_exr");
    }
    const std::string var_name = GlobIdentifierStr;
    getNextToken();

    EXPECT_AND_EAT_TOKEN('=');

    std::unique_ptr<ExprAST> init = ParseExpression();
    if (!init) {
        return nullptr;
    }

    EXPECT_AND_EAT_TOKEN(';');

    // Parse condtion.
    std::unique_ptr<ExprAST> cond = ParseExpression();
    if (!cond) {
        return nullptr;
    }

    EXPECT_AND_EAT_TOKEN(';');

    // Parse step_expr.
    std::unique_ptr<ExprAST> step{};
    if (GlobCurTok != ')') {
        step = ParseExpression();
        if (!step) {
            return nullptr;
        }
    }

    EXPECT_AND_EAT_TOKEN(')');

    // Parse body.
    std::unique_ptr<ExprAST> body = ParseExpression();
    if (!body) {
        return nullptr;
    }

    return std::make_unique<ForExprAST>(var_name, std::move(init), std::move(cond), std::move(step),
                                        std::move(body));
}

/// declar_expr ::= var identifier = expression
std::unique_ptr<ExprAST> ParseDeclarationExpr() {
    assert(GlobCurTok == tok_var);
    getNextToken(); // eat 'var'

    if (GlobCurTok != tok_identifier) {
        return LogError("expected: identifier in declaration");
    }

    const std::string var_name = GlobIdentifierStr;
    getNextToken();

    EXPECT_AND_EAT_TOKEN('=');

    auto init_expr = ParseExpression();
    return std::make_unique<DeclarationExprAST>(var_name, std::move(init_expr));
}

/// primary_expr
///   ::= identifier_expr
///   ::= number_expr
///   ::= char_literal_expr
///   ::= parentheses_expr
///   ::= if_expr
///   ::= for_expr
///   ::= declar_expr
std::unique_ptr<ExprAST> ParsePrimaryExpr() {
    switch (GlobCurTok) {
    default:
        return LogError("unknown token when expecting an expression");
    case tok_identifier:
        return ParseIdentifierExpr();
    case tok_number:
        return ParseNumberExpr();
    case tok_char_literal:
        return ParseCharLiteralExpr();
    case '(':
        return ParseParenExpr();
    case tok_if:
        return ParseIfExpr();
    case tok_for:
        return ParseForExpr();
    case tok_var:
        return ParseDeclarationExpr();
    }
}

/// unary_expr
///   ::= primary_expr
///   ::= unary_op unary_expr
std::unique_ptr<ExprAST> ParseUnaryExpr() {
    // check if current tok is unary operator, otherwise do primay_expr
    if (UnaryOp.contains(GlobCurTok)) {
        int unary_op = GlobCurTok;
        getNextToken(); // eat unary_op
        return std::make_unique<UnaryOpExprAST>(unary_op, ParseUnaryExpr());
    }
    return ParsePrimaryExpr();
}

/// parse BinOpExpr that start from [LHS], and end at a token with precedence strictly less than
/// [TokPrec]
std::unique_ptr<ExprAST> ParseBinOpRHS(int TokPrec, std::unique_ptr<ExprAST> LHS) {
    while (true) {
        int CurPrec = GetCurTokPrecedence();
        if (CurPrec < TokPrec) { // indecate CurTok is not BinOp or BinOp with lower precedence
            return LHS;
        }
        int BinOp = GlobCurTok;
        getNextToken(); // eat binop
        auto RHS = ParseUnaryExpr();
        int NextPrec = GetCurTokPrecedence();
        if (CurPrec < NextPrec) {
            RHS = ParseBinOpRHS(CurPrec + 1, std::move(RHS));
            if (!RHS)
                return nullptr;
        }
        LHS = std::make_unique<BinaryOpExprAST>(BinOp, std::move(LHS), std::move(RHS));
    }
}

/// expression
///   ::= unary_expr [binop unary_expr]*
///
std::unique_ptr<ExprAST> ParseExpression() {
    auto v = ParseUnaryExpr();
    if (!v) {
        return nullptr;
    }
    return ParseBinOpRHS(INVALID_BINARY_OP_PREC + 1, std::move(v));
}

/// toplevelexpr ::= expression
std::unique_ptr<FunctionExprAST> ParseTopLevelExpr() {
    if (auto E = ParseExpression()) {
        // Make an anonymous proto.
        auto Proto =
            std::make_unique<PrototypeExprAST>(TOP_EXPR_FUNC_NAME, std::vector<std::string>());
        return std::make_unique<FunctionExprAST>(std::move(Proto), std::move(E));
    }
    return nullptr;
}

/// prototype
///   ::= identifier '(' identifier* ')'
///   ::= unary LETTER '(' identifier ')'
///   ::= binary LETTER number? '(' identifier, identifier ')'
std::unique_ptr<PrototypeExprAST> ParsePrototype() {

    std::string fn_name;
    unsigned kind = ID_PROTOTYPE_KIND;
    std::optional<unsigned> binary_prec = std::nullopt;

    switch (GlobCurTok) {
    default:
        return LogErrorP("Expected function name in prototype");
    case tok_identifier:
        fn_name = GlobIdentifierStr;
        kind = ID_PROTOTYPE_KIND;
        getNextToken();
        break;
    case tok_unary:
        getNextToken();
        if (!llvm::isASCII(GlobCurTok)) {
            return LogErrorP("Expected unary operator");
        }
        fn_name = "unary";
        fn_name += (char)GlobCurTok;
        kind = UNARY_PROTOTYPE_KIND;
        getNextToken();
        break;
    case tok_binary:
        getNextToken();
        if (!llvm::isASCII(GlobCurTok)) {
            return LogErrorP("Expected binary operator");
        }
        fn_name = "binary";
        fn_name += (char)GlobCurTok;
        kind = BINARY_PROTOTYPE_KIND;
        getNextToken();

        // Set binary op precedence if present, otherwise set to default.
        if (GlobCurTok == tok_number) {
            if (GlobNumVal < 1 || GlobNumVal > 100) {
                return LogErrorP("Invalid binary precedence, must be in [1,100]");
            }
            binary_prec = (unsigned)GlobNumVal;
            getNextToken();
        } else {
            binary_prec = DEFAULT_BINARY_OP_PREC;
        }
        break;
    };

    if (GlobCurTok != '(') {
        return LogErrorP("expected: '(' in prototype");
    }
    getNextToken();
    std::vector<std::string> args;
    while (GlobCurTok == tok_identifier) {
        args.push_back(GlobIdentifierStr);
        getNextToken();
    }
    if (GlobCurTok != ')') {
        return LogErrorP("expected: ')' in prototype");
    }
    getNextToken(); // eat ')'

    // Verify args count for operator.
    if (kind && args.size() != kind) {
        return LogErrorP("Invalid number of operands for operator");
    }
    return std::make_unique<PrototypeExprAST>(fn_name, std::move(args), kind, binary_prec);
}

/// definition ::= 'def' prototype expression
std::unique_ptr<FunctionExprAST> ParseDefinition() {
    getNextToken(); // eat def
    auto Proto = ParsePrototype();
    if (!Proto)
        return nullptr;

    if (auto E = ParseExpression())
        return std::make_unique<FunctionExprAST>(std::move(Proto), std::move(E));
    return nullptr;
}

/// external ::= 'extern' prototype
std::unique_ptr<PrototypeExprAST> ParseExtern() {
    getNextToken(); // eat extern.
    return ParsePrototype();
}

void HandleDefinition() {
    if (auto FnAST = ParseDefinition()) {
        if (auto *FnIR = FnAST->codegen()) {
            if constexpr (debug::show_llvm_ir) {
                if constexpr (debug::show_llvm_prompt)
                    fprintf(stderr, "Read function definition:\n");
                FnIR->print(llvm::errs());
            }
            if constexpr (debug::turn_on_jit) {
                auto TSM = llvm::orc::ThreadSafeModule(std::move(TheModule), std::move(TheContext));
                ExitOnErr(TheJIT->addModule(std::move(TSM)));
                InitializeModuleAndManager();
            }
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

void HandleExtern() {
    if (auto ProtoAST = ParseExtern()) {
        if (auto *FnIR = ProtoAST->codegen()) {
            if constexpr (debug::show_llvm_ir) {
                if constexpr (debug::show_llvm_prompt)
                    fprintf(stderr, "Read extern:\n");
                FnIR->print(llvm::errs());
            }
            FunctionProtos[ProtoAST->getName()] = std::move(ProtoAST);
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

static void runTopExprFuncInJIT() {
    // Create a ResourceTracker to track JIT'd memory allocated to our
    // anonymous expression -- that way we can free it after executing.
    auto RT = TheJIT->getMainJITDylib().createResourceTracker();

    auto TSM = llvm::orc::ThreadSafeModule(std::move(TheModule), std::move(TheContext));
    ExitOnErr(TheJIT->addModule(std::move(TSM), RT));
    InitializeModuleAndManager();

    // Search the JIT for the __anon_expr symbol.
    auto ExprSymbol = ExitOnErr(TheJIT->lookup(TOP_EXPR_FUNC_NAME));
    assert(ExprSymbol && "Function not found");

    // Get the symbol's address and cast it to the right type (takes no
    // arguments, return a double) so we can call it as a native function.
    double (*FP)() = (double (*)())(intptr_t)ExprSymbol.getAddress();
    [[maybe_unused]] auto res = FP();

    if constexpr (debug::show_jit_evaluate_result) {
        fprintf(stderr, "Evaluated to %f\n", res);
    }

    // Delete the anonymou expression module from the JIT.
    ExitOnErr(RT->remove());
}

void HandleTopLevelExpression() {
    // Evaluate a top-level expression into an anonymous function.
    if (auto FnAST = ParseTopLevelExpr()) {
        if (auto *FnIR = FnAST->codegen()) {
            if constexpr (debug::show_llvm_ir) {
                if constexpr (debug::show_llvm_prompt)
                    fprintf(stderr, "Read top-level expression:\n");
                FnIR->print(llvm::errs());
            }
            if constexpr (debug::turn_on_jit) {
                runTopExprFuncInJIT();
            }
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

void InitializeNativeTraget() {
    llvm::InitializeNativeTarget();
    llvm::InitializeNativeTargetAsmPrinter();
    llvm::InitializeNativeTargetAsmParser();
}

void InitializeJIT() {
    if constexpr (debug::turn_on_jit) {
        TheJIT = ExitOnErr(llvm::orc::KaleidoscopeJIT::Create());
    }
}

// Must be called before calling [ParseMainLoop]
void InitializeModuleAndManager() {
    // Open a new context and module.
    TheContext = std::make_unique<llvm::LLVMContext>();
    TheModule = std::make_unique<llvm::Module>("new module", *TheContext);

    // Create a new builder for the module.
    Builder = std::make_unique<llvm::IRBuilder<>>(*TheContext);
}

void EmitObjectFile() {
    // Initialize the target registry etc.
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargets();
    llvm::InitializeAllTargetMCs();
    llvm::InitializeAllAsmParsers();
    llvm::InitializeAllAsmPrinters();

    const std::string &target_triple = llvm::sys::getDefaultTargetTriple();
    TheModule->setTargetTriple(target_triple);

    std::string error;
    const llvm::Target *target = llvm::TargetRegistry::lookupTarget(target_triple, error);

    // Print an error and exit if we couldn't find the requested target.
    // This generally occurs if we've forgotten to initialise the
    // TargetRegistry or we have a bogus target triple.
    if (!target) {
        llvm::errs() << error;
        exit(1);
    }

    auto cpu = "genric";
    auto features = "";
    llvm::TargetOptions options;
    auto rm = llvm::Optional<llvm::Reloc::Model>();
    auto the_target_machine =
        target->createTargetMachine(target_triple, cpu, features, options, rm);
    TheModule->setDataLayout(the_target_machine->createDataLayout());

    auto file_name = "output.o";
    std::error_code ec;
    llvm::raw_fd_ostream dest(file_name, ec, llvm::sys::fs::OF_None);
    if (ec) {
        llvm::errs() << "could not open file: " << ec.message();
        exit(1);
    }

    llvm::legacy::PassManager pass;
    auto file_type = llvm::CGFT_ObjectFile;
    if (the_target_machine->addPassesToEmitFile(pass, dest, nullptr, file_type)) {
        llvm::errs() << "the target machine can't emit a file of this type";
        exit(1);
    }
    pass.run(*TheModule);
    dest.flush();
    llvm::outs() << "wrote to " << file_name << "\n";
};

static void initParse() {
    BinopPrecedence['<'] = BinopPrecedence['>'] = COMPARE_OP_PREC;
    BinopPrecedence['+'] = BinopPrecedence['-'] = SUM_OP_PREC;
    BinopPrecedence['*'] = BinopPrecedence['/'] = MUL_OP_PREC;
    BinopPrecedence['='] = ASSIGNMENT_OP_PREC;
}

/// top ::= definition | external | expression | ';'
void ParseMainLoop() {
    initParse();
    if constexpr (debug::show_input_prompt) {
        fmt::print(stdout, "ready> ");
    }
    fflush(stdout);
    getNextToken();
    bool isTerminal = isatty(STDIN_FILENO);
    while (true) {
        switch (GlobCurTok) {
        case tok_eof:
            goto finish;
        case ';': // ignore top-level semicolons.
            break;
        case tok_def:
            HandleDefinition();
            continue;
        case tok_extern:
            HandleExtern();
            continue;
        default:
            HandleTopLevelExpression();
            continue;
        }
        if constexpr (debug::show_input_prompt) {
            if (isTerminal) {
                fmt::print(stdout, "ready> ");
                fflush(stdout);
            }
        }
        getNextToken();
        while (GlobCurTok == ';') { // remove all tail semicolons
            getNextToken();
        }
    }
finish:
    fflush(stdout);
    // Print out all of the generated code.
    if constexpr (debug::show_llvm_prompt) {
        TheModule->print(llvm::errs(), nullptr);
    }
}
