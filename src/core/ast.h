#pragma once

#include "global.h"
#include <optional>

class ExprAST {
  public:
    virtual ~ExprAST() = default;
    virtual llvm::Value *codegen() = 0;
};

class NumberExprAST : public ExprAST {
    double Val;

  public:
    NumberExprAST(double val) : Val(val) {}
    llvm::Value *codegen() override;
};

class VariableAST : public ExprAST {
    std::string name_;

  public:
    VariableAST(const std::string &name) : name_(name) {}
    llvm::Value *codegen() override;
};

class UnaryExprAST : public ExprAST {
    char op_;
    std::unique_ptr<ExprAST> operand_;

  public:
    UnaryExprAST(char op, std::unique_ptr<ExprAST> operand)
        : op_(op), operand_(std::move(operand)) {}
    llvm::Value *codegen() override;
};

class BinaryExprAST : public ExprAST {
    char Op;
    std::unique_ptr<ExprAST> Lhs;
    std::unique_ptr<ExprAST> Rhs;

  public:
    BinaryExprAST(char op, std::unique_ptr<ExprAST> lhs, std::unique_ptr<ExprAST> rhs)
        : Op(op), Lhs(std::move(lhs)), Rhs(std::move(rhs)) {}
    llvm::Value *codegen() override;
};

class CallExprAST : public ExprAST {
    std::string Callee;
    std::vector<std::unique_ptr<ExprAST>> Args;

  public:
    CallExprAST(const std::string &callee, std::vector<std::unique_ptr<ExprAST>> args)
        : Callee(callee), Args(std::move(args)) {}
    llvm::Value *codegen() override;
};

/// PrototypeAST - This class represents the "prototype" for a function,
/// which captures its name, and its argument names (thus implicitly the number
/// of arguments the function takes).
class PrototypeAST : public ExprAST {
    std::string name_;
    std::vector<std::string> args_;
    unsigned kind;                        // 0 = identifier, 1 = unary, 2 = binary.
    std::optional<unsigned> binary_prec_; // Precedence if a binary op

  public:
    PrototypeAST(const std::string &name, std::vector<std::string> args, unsigned kind = 0,
                 std::optional<unsigned> binary_prec = std::nullopt)
        : name_(name), args_(std::move(args)), kind(kind), binary_prec_(binary_prec) {}

    const std::string &getName() const { return name_; }
    bool isUnaryOp() const { return kind == UNARY_PROTOTYPE_KIND; }
    bool isBinaryOp() const { return kind == BINARY_PROTOTYPE_KIND; }
    char getOpName() const {
        assert(kind > 0 && !name_.empty());
        return name_[name_.size() - 1];
    }
    unsigned getBinaryPrecedence() const {
        assert(isBinaryOp());
        return binary_prec_.value_or(DEFAULT_BINARY_OP_PREC);
    }

    llvm::Function *codegen() override;
};
class FunctionAST : public ExprAST {
    std::unique_ptr<PrototypeAST> proto_;
    std::unique_ptr<ExprAST> body_;

  public:
    FunctionAST(std::unique_ptr<PrototypeAST> Proto, std::unique_ptr<ExprAST> body)
        : proto_(std::move(Proto)), body_(std::move(body)) {}
    llvm::Function *codegen() override;
};

class IfExprAST : public ExprAST {
    std::unique_ptr<ExprAST> cond_;
    std::unique_ptr<ExprAST> then_br_;
    std::unique_ptr<ExprAST> else_br_;

  public:
    IfExprAST(std::unique_ptr<ExprAST> cond, std::unique_ptr<ExprAST> then_br,
              std::unique_ptr<ExprAST> else_br)
        : cond_(std::move(cond)), then_br_(std::move(then_br)), else_br_(std::move(else_br)) {}
    llvm::Value *codegen() override;
};

class ForExprAST : public ExprAST {
    std::string var_name_;
    std::unique_ptr<ExprAST> init_;
    std::unique_ptr<ExprAST> cond_;
    std::unique_ptr<ExprAST> step_;
    std::unique_ptr<ExprAST> body_;

  public:
    ForExprAST(const std::string &var_name, std::unique_ptr<ExprAST> start,
               std::unique_ptr<ExprAST> cond, std::unique_ptr<ExprAST> step,
               std::unique_ptr<ExprAST> body)
        : var_name_(var_name), init_(std::move(start)), cond_(std::move(cond)),
          step_(std::move(step)), body_(std::move(body)) {}

    llvm::Value *codegen() override;
};