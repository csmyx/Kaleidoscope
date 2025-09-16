#include "Kaleidoscope.h"
#include "fmt/core.h"
#include "global.h"
#include "util.h"
#include <llvm-14/llvm/Transforms/InstCombine/InstCombine.h>
#include <llvm-14/llvm/Transforms/Scalar.h>
#include <llvm-14/llvm/Transforms/Scalar/GVN.h>

/// numberexpr ::= number
std::unique_ptr<ExprAST> ParseNumberExpr() {
    auto Result = std::make_unique<NumberExprAST>(GlobNumVal);
    getNextToken(); // consume the number
    return std::move(Result);
}

/// parenexpr ::= '(' expression ')'
std::unique_ptr<ExprAST> ParseExpression();
std::unique_ptr<ExprAST> ParseParenExpr() {
    getNextToken();
    auto v = ParseExpression();
    if (!v) {
        return nullptr;
    }
    if (GlobCurTok != ')') {
        return LogError("expected ')'");
    }
    getNextToken();
    return v;
}

/// identifierexpr
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
        return std::make_unique<VariableAST>(ident);
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
                return LogError("expected ')' or ',' in argment list");
            }
            getNextToken(); // eat ','
        }
    }
    getNextToken(); // eat ')'

    return std::make_unique<CallExprAST>(ident, std::move(args));
}

/// primaryexpr
///   ::= identifierexpr
///   ::= numberexpr
///   ::= parenexpr
std::unique_ptr<ExprAST> ParsePrimaryExpr() {
    switch (GlobCurTok) {
    default:
        return LogError("unknown token when expecting an expression");
    case tok_identifier:
        return ParseIdentifierExpr();
    case tok_number:
        return ParseNumberExpr();
    case '(':
        return ParseParenExpr();
    }
}

#define INVALID_TOK_PREC -1
int GetCurTokPrecedence() {
    switch (GlobCurTok) {
    case '<':
    case '>':
        return 10;
    case '+':
    case '-':
        return 20;
    case '*':
    case '/':
        return 40;
    default:
        return INVALID_TOK_PREC;
    }
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
        auto RHS = ParsePrimaryExpr();
        int NextPrec = GetCurTokPrecedence();
        if (CurPrec < NextPrec) {
            RHS = ParseBinOpRHS(CurPrec + 1, std::move(RHS));
            if (!RHS)
                return nullptr;
        }
        LHS = std::make_unique<BinaryExprAST>(BinOp, std::move(LHS), std::move(RHS));
    }
}

/// expression
///   ::= primary binoprhs
///
std::unique_ptr<ExprAST> ParseExpression() {
    auto v = ParsePrimaryExpr();
    if (!v) {
        return nullptr;
    }
    return ParseBinOpRHS(INVALID_TOK_PREC + 1, std::move(v));
}

/// toplevelexpr ::= expression
std::unique_ptr<FunctionAST> ParseTopLevelExpr() {
    if (auto E = ParseExpression()) {
        // Make an anonymous proto.
        auto Proto = std::make_unique<PrototypeAST>("__anon_expr", std::vector<std::string>());
        return std::make_unique<FunctionAST>(std::move(Proto), std::move(E));
    }
    return nullptr;
}

/// prototype
///   ::= identifier '(' identifier* ')'
std::unique_ptr<PrototypeAST> ParsePrototype() {
    if (GlobCurTok != tok_identifier)
        return LogErrorP("Expected function name in prototype");

    std::string Name = GlobIdentifierStr;
    getNextToken();

    if (GlobCurTok != '(') {
        return LogErrorP("expected '(' in prototype");
    }
    getNextToken();
    std::vector<std::string> Args;
    while (GlobCurTok == tok_identifier) {
        Args.push_back(GlobIdentifierStr);
        getNextToken();
    }
    if (GlobCurTok != ')') {
        return LogErrorP("expected ')' in prototype");
    }
    getNextToken(); // eat ')'
    return std::make_unique<PrototypeAST>(Name, std::move(Args));
}

/// definition ::= 'def' prototype expression
std::unique_ptr<FunctionAST> ParseDefinition() {
    getNextToken(); // eat def
    auto Proto = ParsePrototype();
    if (!Proto)
        return nullptr;

    if (auto E = ParseExpression())
        return std::make_unique<FunctionAST>(std::move(Proto), std::move(E));
    return nullptr;
}

/// external ::= 'extern' prototype
std::unique_ptr<PrototypeAST> ParseExtern() {
    getNextToken(); // eat extern.
    return ParsePrototype();
}

void HandleDefinition() {
    if (auto FnAST = ParseDefinition()) {
        if (auto *FnIR = FnAST->codegen()) {
            fprintf(stderr, "Read function definition:\n");
            FnIR->print(llvm::errs());
            fprintf(stderr, "\n");
            ExitOnErr(TheJIT->addModule(
                llvm::orc::ThreadSafeModule(std::move(TheModule), std::move(TheContext))));
            InitializeModuleAndManager();
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

void HandleExtern() {
    if (auto ProtoAST = ParseExtern()) {
        if (auto *FnIR = ProtoAST->codegen()) {
            fprintf(stderr, "Read extern:\n");
            FnIR->print(llvm::errs());
            fprintf(stderr, "\n");
            FunctionProtos[ProtoAST->getName()] = std::move(ProtoAST);
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

void HandleTopLevelExpression() {
    // Evaluate a top-level expression into an anonymous function.
    if (auto FnAST = ParseTopLevelExpr()) {
        if (auto *FnIR = FnAST->codegen()) {
            fprintf(stderr, "Read top-level expression:\n");
            FnIR->print(llvm::errs());
            fprintf(stderr, "\n");

            // Create a ResourceTracker to track JIT'd memory allocated to our
            // anonymous expression -- that way we can free it after executing.
            auto RT = TheJIT->getMainJITDylib().createResourceTracker();

            auto TSM = llvm::orc::ThreadSafeModule(std::move(TheModule), std::move(TheContext));
            ExitOnErr(TheJIT->addModule(std::move(TSM), RT));
            InitializeModuleAndManager();

            // Search the JIT for the __anon_expr symbol.
            auto ExprSymbol = ExitOnErr(TheJIT->lookup("__anon_expr"));
            assert(ExprSymbol && "Function not found");

            // Get the symbol's address and cast it to the right type (takes no
            // arguments, return a double) so we can call it as a native function.
            double (*FP)() = (double (*)())(intptr_t)ExprSymbol.getAddress();

            fprintf(stderr, "Evaluated to %f\n", FP());

            // Delete the anonymou expression module from the JIT.
            ExitOnErr(RT->remove());
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

// Must be called before calling [ParseMainLoop]
void InitializeModuleAndManager() {
    // Open a new context and module.
    TheContext = std::make_unique<llvm::LLVMContext>();
    TheModule = std::make_unique<llvm::Module>("my cool jit", *TheContext);
    TheModule->setDataLayout(TheJIT->getDataLayout());

    // Create a new builder for the module.
    Builder = std::make_unique<llvm::IRBuilder<>>(*TheContext);

    // Create new pass and analysis managers.
    TheFPM = std::make_unique<llvm::legacy::FunctionPassManager>(TheModule.get());

    // Do simple "peephole" optimizations and bit-twiddling optimizations.
    TheFPM->add(llvm::createInstructionCombiningPass());
    // Reassociate expressions.
    TheFPM->add(llvm::createReassociatePass());
    // Eliminate Common SubExpressions.
    TheFPM->add(llvm::createGVNPass());
    // Simplify the control flow graph (deleting unrechable blocks, etc).
    TheFPM->add(llvm::createCFGSimplificationPass());

    TheFPM->doInitialization();
}

/// top ::= definition | external | expression | ';'
void ParseMainLoop() {
    while (true) {
        fmt::print(stderr, "ready> ");
        switch (GlobCurTok) {
        case tok_eof:
            return;
        case ';': // ignore top-level semicolons.
            getNextToken();
            break;
        case tok_def:
            HandleDefinition();
            break;
        case tok_extern:
            HandleExtern();
            break;
        default:
            HandleTopLevelExpression();
            break;
        }
    }
}
