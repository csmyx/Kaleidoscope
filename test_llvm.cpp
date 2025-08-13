#include "llvm/IR/LLVMContext.h"
#include <iostream>

int main() {
    llvm::LLVMContext context;
    std::cout << "LLVM context initialized successfully!" << std::endl;
    return 0;
}