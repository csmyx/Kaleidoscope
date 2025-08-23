#include "ast.h"
#include "global.h"
#include "util.h"
#include <llvm-14/llvm/IR/Attributes.h>
#include <llvm-14/llvm/IR/BasicBlock.h>
#include <llvm-14/llvm/IR/Verifier.h>

llvm::Value *NumberExprAST::codegen() {
    return llvm::ConstantFP::get(*TheContext, llvm::APFloat(Val));
}

llvm::Value *VariableAST::codegen() {
    llvm::Value *v = NamedValues[Name];
    if (!v) {
        return LogErrorV("Unknown variable name");
    }
    return v;
}

llvm::Value *BinaryExprAST::codegen() {
    llvm::Value *LHS = Lhs->codegen();
    llvm::Value *RHS = Rhs->codegen();
    if (!LHS || !RHS) {
        return nullptr;
    }

    switch (Op) {
    default:
        return LogErrorV("Invalid binary operator");
    case '+':
        return Builder->CreateAdd(LHS, RHS, "addtmp");
    case '-':
        return Builder->CreateSub(LHS, RHS, "subtmp");
    case '*':
        return Builder->CreateMul(LHS, RHS, "multmp");
    case '<':
        LHS = Builder->CreateFCmpULT(LHS, RHS, "cmptmp");
        // Convert bool 0/1 to double 0.0 or 1.0
        return Builder->CreateUIToFP(LHS, llvm::Type::getDoubleTy(*TheContext), "booltmp");
    }
}

llvm::Value *CallExprAST::codegen() {
    // Look up the name in the global module table.
    llvm::Function *CalleeF = TheModule->getFunction(Callee);
    if (!CalleeF)
        return LogErrorV("Unknown function referenced");

    if (CalleeF->arg_size() != Args.size())
        return LogErrorV("Incorrect # arguments passed");

    std::vector<llvm::Value *> ArgsV;
    for (unsigned i = 0, e = Args.size(); i != e; ++i) {
        ArgsV.push_back(Args[i]->codegen());
        if (!ArgsV.back()) {
            return nullptr;
        }
    }
    return Builder->CreateCall(CalleeF, ArgsV, "calltmp");
}

llvm::Function *PrototypeAST::codegen() {
    std::vector<llvm::Type *> Doubles(Args.size(), llvm::Type::getDoubleTy(*TheContext));
    llvm::FunctionType *FT =
        llvm::FunctionType::get(llvm::Type::getDoubleTy(*TheContext), Doubles, false);
    llvm::Function *F = llvm::Function::Create(FT, llvm::Function::ExternalLinkage, Name, TheModule.get());

    unsigned Idx = 0;
    for (auto &Arg : F->args()) {
        Arg.setName(Args[Idx++]);
    }
    return F;
}

llvm::Function *FunctionAST::codegen() {
    llvm::Function *TheFunction = TheModule->getFunction(Proto->getName());
    if (!TheFunction) {
        TheFunction = Proto->codegen();
    }
    if (!TheFunction) {
        return nullptr;
    }

    llvm::BasicBlock *BB = llvm::BasicBlock::Create(*TheContext, "entry", TheFunction);
    Builder->SetInsertPoint(BB);

    NamedValues.clear();
    for (auto &Arg : TheFunction->args()) {
        NamedValues[std::string(Arg.getName())] = &Arg;
    }

    if (llvm::Value *RetVal = Body->codegen()) {
        // Finish off the function
        Builder->CreateRet(RetVal);

        llvm::verifyFunction(*TheFunction);

        return TheFunction;
    }

    // Error reading body, remove function
    TheFunction->eraseFromParent();
    return nullptr;
}