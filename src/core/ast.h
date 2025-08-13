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
