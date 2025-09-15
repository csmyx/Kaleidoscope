#include "ast.h"
#include "fmt/core.h"
#include "global.h"
#include "util.h"
#include <memory>
#include <string>

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
            fprintf(stderr, "Read function definition:");
            FnIR->print(llvm::errs());
            fprintf(stderr, "\n");
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

void HandleExtern() {
    if (auto ProtoAST = ParseExtern()) {
        if (auto *FnIR = ProtoAST->codegen()) {
            fprintf(stderr, "Read extern: ");
            FnIR->print(llvm::errs());
            fprintf(stderr, "\n");
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

            // Remove the anonymous expression.
            FnIR->eraseFromParent();
        }
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

// Must be called before calling [ParseMainLoop]
void InitializeModule() {
  // Open a new context and module.
  TheContext = std::make_unique<llvm::LLVMContext>();
  TheModule = std::make_unique<llvm::Module>("my cool jit", *TheContext);

  // Create a new builder for the module.
  Builder = std::make_unique<llvm::IRBuilder<>>(*TheContext);
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
