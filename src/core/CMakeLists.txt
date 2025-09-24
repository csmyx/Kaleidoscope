file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)
message("source files in core: ${SOURCES}")

set(TARGET_LIB_NAME ${PROJECT_NAME}_lib)
message("TARGET_LIB_NAME: ${TARGET_LIB_NAME}")

# 生成静态库（便于测试代码链接）
# add_library(${TARGET_LIB_NAME} STATIC ${SOURCES})
add_library(${TARGET_LIB_NAME} SHARED ${SOURCES})

# 指定库的头文件搜索路径
target_include_directories(${TARGET_LIB_NAME} PUBLIC ${INCLUDE_DIR})
target_link_libraries(${TARGET_LIB_NAME} PUBLIC fmt::fmt)

set(LLVM_ROOT /home/hugo/local/llvm21_cxx)
set(LLVM_DIR "${LLVM_ROOT}/lib/cmake/llvm") # directory that includes LLVMConfig.cmake
find_package(LLVM 21.1 REQUIRED CONFIG)
message(STATUS "LLVM_DIR: ${LLVM_DIR}")
message(STATUS "Found LLVM Version: ${LLVM_PACKAGE_VERSION}")

# 函数名：llvm_config_exec
# 功能：调用llvm-config并自动处理错误
# 参数：
#   1. opts：llvm-config的选项（如--cxxflags）
#   2. output_var：接收命令输出的变量名（传递到父作用域）
function(llvm_config_exec output_var)
    set(opts ${ARGN})
    execute_process(
        COMMAND ${LLVM_ROOT}/bin/llvm-config ${opts}
        OUTPUT_VARIABLE local_output
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE local_result
    )

    # 函数内部处理错误：非0返回码则直接终止
    if(NOT local_result EQUAL 0)
        message(FATAL_ERROR 
            "llvm-config 执行失败！\n"
            "选项: ${opts}\n"
            "返回码: ${local_result}"
        )
    endif()
    
    # 将成功的输出传递到父作用域
    set(${output_var} ${local_output} PARENT_SCOPE)
endfunction()


llvm_config_exec(LLVM_CXXFLAGS_SPACES --cxxflags)
llvm_config_exec(LLVM_LIB_DIRS_SPACES --ldflags)
llvm_config_exec(LLVM_SYS_LIBS_SPACES --system-libs)
llvm_config_exec(LLVM_LIBS_SPACES --libs all)

string(REPLACE " " ";" LLVM_CXXFLAGS "${LLVM_CXXFLAGS_SPACES}")
string(REPLACE " " ";" LLVM_LIB_DIRS "${LLVM_LIB_DIRS_SPACES}")
string(REPLACE " " ";" LLVM_SYS_LIBS "${LLVM_SYS_LIBS_SPACES}")
string(REPLACE " " ";" LLVM_LIBS "${LLVM_LIBS_SPACES}")

set(LLVM_COMPILE_OPTS ${LLVM_CXXFLAGS})
message(STATUS "LLVM_COMPILE_OPTS: [${LLVM_COMPILE_OPTS}]")

set(LLVM_LINK_OPTS ${LLVM_LIB_DIRS} ${LLVM_SYS_LIBS} ${LLVM_LIBS})
message(STATUS "LLVM_LINK_OPTS: [${LLVM_LINK_OPTS}]")

target_compile_options(${TARGET_LIB_NAME} PRIVATE ${LLVM_COMPILE_OPTS})
target_link_options(${TARGET_LIB_NAME} PRIVATE ${LLVM_LINK_OPTS})


# Set -isystem, used by clangd to find the position of LLVM headers.
# this is better than target_incldue_directories, because -isystem has a greater priority than -I.
include_directories(SYSTEM 
  ${LLVM_INCLUDE_DIRS}                   
)

# 调试模式：设置 DEBUG_DEFAULT=1
target_compile_definitions(${TARGET_LIB_NAME} PRIVATE DEBUG_DEFAULT=1)  