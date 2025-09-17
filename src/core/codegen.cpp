#include "ast.h"
#include "global.h"
#include "util.h"
#include <cstddef>
#include <llvm-14/llvm/ADT/APFloat.h>
#include <llvm-14/llvm/IR/Attributes.h>
#include <llvm-14/llvm/IR/BasicBlock.h>
#include <llvm-14/llvm/IR/Constant.h>
#include <llvm-14/llvm/IR/Constants.h>
#include <llvm-14/llvm/IR/Instructions.h>
#include <llvm-14/llvm/IR/Type.h>
#include <llvm-14/llvm/IR/Use.h>
#include <llvm-14/llvm/IR/Value.h>
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
    case '<':
        LHS = Builder->CreateFCmpULT(LHS, RHS, "lttmp");
        // Convert bool 0/1 to double 0.0 or 1.0
        return Builder->CreateUIToFP(LHS, llvm::Type::getDoubleTy(*TheContext), "booltmp");
    case '>':
        LHS = Builder->CreateFCmpUGT(LHS, RHS, "gttmp");
        // Convert bool 0/1 to double 0.0 or 1.0
        return Builder->CreateUIToFP(LHS, llvm::Type::getDoubleTy(*TheContext), "booltmp");
    case '+':
        return Builder->CreateFAdd(LHS, RHS, "addtmp");
    case '-':
        return Builder->CreateFSub(LHS, RHS, "subtmp");
    case '*':
        return Builder->CreateFMul(LHS, RHS, "multmp");
    default:
        return LogErrorV("Invalid binary operator");
    }
}

llvm::Function *getFunction(std::string name) {
    // First see if the function has already been added to the current module.
    if (auto *f = TheModule->getFunction(name)) {
        return f;
    }

    // If not, check wherther we can codegen the declaration form some existing prototype.
    auto iter = FunctionProtos.find(name);
    if (iter != FunctionProtos.end()) {
        return iter->second->codegen();
    }

    // If no existing prototype exists, return null.
    return nullptr;
}

llvm::Value *CallExprAST::codegen() {
    // Look up the name in the global module table.
    llvm::Function *CalleeF = getFunction(Callee);
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
    llvm::Function *F =
        llvm::Function::Create(FT, llvm::Function::ExternalLinkage, Name, TheModule.get());

    unsigned Idx = 0;
    for (auto &Arg : F->args()) {
        Arg.setName(Args[Idx++]);
    }
    return F;
}

llvm::Function *FunctionAST::codegen() {
    // Transfer ownership of the prototype to the FunctionProtos map, but keep a reference to it for
    // use below.
    auto &p = *Proto;
    FunctionProtos[Proto->getName()] = std::move(Proto);
    llvm::Function *TheFunction = getFunction(p.getName());

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

llvm::Value *IfExprAST::codegen() {
    // Compute condition, and convert condition to a bool by comparing not-eqaul to 0.0.
    llvm::Value *cond_v = cond_->codegen();
    if (!cond_v) {
        return nullptr;
    }
    llvm::Value *predicate = Builder->CreateFCmpONE(
        cond_v, llvm::ConstantFP::get(*TheContext, llvm::APFloat(0.0)), "if.cond");
    llvm::Function *func = Builder->GetInsertBlock()->getParent();

    // Create blocks for the then and else cases. Insert the 'then' block at the end of the
    // function.
    llvm::BasicBlock *then_bb = llvm::BasicBlock::Create(*TheContext, "if.then", func);
    llvm::BasicBlock *else_bb = llvm::BasicBlock::Create(*TheContext, "if.else");
    llvm::BasicBlock *merge_bb = llvm::BasicBlock::Create(*TheContext, "if.cont");

    Builder->CreateCondBr(predicate, then_bb, else_bb);

    // Emit then block.
    Builder->SetInsertPoint(then_bb);
    llvm::Value *then_v = then_br_->codegen();
    if (!then_v) {
        return nullptr;
    }
    Builder->CreateBr(merge_bb);
    // Codegen of 'then_br_' can change the current block, udpate then_bb for the Phi.
    then_bb = Builder->GetInsertBlock();

    // Emit else block.
    func->getBasicBlockList().push_back(else_bb);
    Builder->SetInsertPoint(else_bb);
    llvm::Value *else_v = else_br_->codegen();
    if (!else_v) {
        return nullptr;
    }
    Builder->CreateBr(merge_bb);
    // Codegen of 'else_br_' can change the current block, udpate else_bb for the Phi.
    else_bb = Builder->GetInsertBlock();

    // Emit merge block.
    func->getBasicBlockList().push_back(merge_bb);
    Builder->SetInsertPoint(merge_bb);
    llvm::PHINode *phi_node = Builder->CreatePHI(llvm::Type::getDoubleTy(*TheContext), 2, "iftmp");
    phi_node->addIncoming(then_v, then_bb);
    phi_node->addIncoming(else_v, else_bb);
    return phi_node;
}

llvm::Value *ForExprAST::codegen() {
    // Emit the start code first, without 'variable' in scope.
    llvm::Value *init_v = init_->codegen();
    if (!init_v) {
        return nullptr;
    }

    llvm::Function *func = Builder->GetInsertBlock()->getParent();
    llvm::BasicBlock *pre_bb = Builder->GetInsertBlock();

    // 1. Basic BLock of Entry, include iter_variable init codegen and cond condition codegen.
    llvm::BasicBlock *entry_bb = llvm::BasicBlock::Create(*TheContext, "forentry", func);
    Builder->SetInsertPoint(pre_bb);
    Builder->CreateBr(entry_bb); // jump to entry bb from previous bb

    auto *pre_bb_tail = Builder->GetInsertBlock();
    Builder->SetInsertPoint(entry_bb);
    // Start the Phi node with an entry for init.
    llvm::PHINode *iter_var =
        Builder->CreatePHI(llvm::Type::getDoubleTy(*TheContext), 2, var_name_);
    iter_var->addIncoming(init_v, pre_bb_tail);

    // Within the loop, the variable is defined equal to the Phi node. If it shadows an existing
    // variable, we have to restor it, so save it now.
    llvm::Value *old_val = NamedValues[var_name_];
    NamedValues[var_name_] = iter_var;

    // Emit cond codegen, convert cond to a bool by comparing not-eqaul to 0.0.
    llvm::Value *cond_v = cond_->codegen();
    if (!cond_v) {
        return nullptr;
    }

    Builder->SetInsertPoint(entry_bb); // reset insert point in case of
    llvm::Value *predicate = Builder->CreateFCmpONE(
        cond_v, llvm::ConstantFP::get(*TheContext, llvm::APFloat(0.0)), "forcond");

    llvm::BasicBlock *body_bb = llvm::BasicBlock::Create(*TheContext, "forbody", func);
    llvm::BasicBlock *post_bb = llvm::BasicBlock::Create(*TheContext, "forcont", func);
    Builder->CreateCondBr(predicate, body_bb, post_bb);

    // 2. Basic Block of body.
    Builder->SetInsertPoint(body_bb);

    // Emit the body of the loop. This, like any other expr, can change the current BB. Note
    // that we ignore the value computed by the body, bud don't allow an error.
    if (!body_->codegen()) {
        return nullptr;
    }

    // Emit the step value.
    llvm::Value *step_value = nullptr;
    if (step_) {
        step_value = step_->codegen();
        if (!step_value) {
            return nullptr;
        }
    } else {
        // If not specified, default is 1.0.
        step_value = llvm::ConstantFP::get(*TheContext, llvm::APFloat(1.0));
    }

    // Compute the next value.
    llvm::Value *next_v = Builder->CreateFAdd(iter_var, step_value, "nextvar");
    auto *body_bb_tail = Builder->GetInsertBlock();
    iter_var->addIncoming(next_v, body_bb_tail);
    Builder->CreateBr(entry_bb); // jump back to entry BB

    // 3. exit.
    Builder->SetInsertPoint(post_bb);

    // Restore the unshadowed variable.
    if (old_val) {
        NamedValues[var_name_] = old_val;
    } else {
        NamedValues.erase(var_name_);
    }
    // for expr always returns 0.0.
    return llvm::Constant::getNullValue(llvm::Type::getDoubleTy(*TheContext));
}