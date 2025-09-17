#pragma once

#include "global.h"
#include <llvm-14/llvm/ADT/APFloat.h>
#include <llvm-14/llvm/IR/Constants.h>
#include <memory>
#include <string>
#include <vector>

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
    std::string Name;

  public:
    VariableAST(const std::string &name) : Name(name) {}
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
    std::string Name;
    std::vector<std::string> Args;

  public:
    PrototypeAST(const std::string &name, std::vector<std::string> args)
        : Name(name), Args(std::move(args)) {}
    std::string getName() { return Name; }
    llvm::Function *codegen() override;
};
class FunctionAST : public ExprAST {
    std::unique_ptr<PrototypeAST> Proto;
    std::unique_ptr<ExprAST> Body;

  public:
    FunctionAST(std::unique_ptr<PrototypeAST> Proto, std::unique_ptr<ExprAST> body)
        : Proto(std::move(Proto)), Body(std::move(body)) {}
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