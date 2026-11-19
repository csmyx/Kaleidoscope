#include "global.h"
#include "util.h"
#include <fcntl.h>
#include <unistd.h>
// #include <llvm/Support/Debug.h>
// #define DEBUG_TYPE "kaleidoscope"

void redirect_stdin(const char *file) {
    int fd = open(file, O_RDONLY);
    if (fd < 0) {
        perror("open");
        exit(1);
    }

    if (dup2(fd, STDIN_FILENO) < 0) {
        perror("dup2");
        close(fd);
        exit(1);
    }
    close(fd);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        llvm::errs() << "usage: " << argv[0] << " <input-file>\n";
        return 1;
    }
    redirect_stdin(argv[1]);

    InitializeNativeTraget();

    InitializeJIT();

    // Make the module, which holds all the code.
    InitializeModuleAndManager();

    // Run the main "interpreter loop" now.
    ParseMainLoop();

    if (!debug::turn_on_jit) {
        const char *object_file = "output.o";
        EmitObjectFile(object_file);
        // llvm::dbgs() << "flushed to " << object_file << "!\n";
    }

    return 0;
}