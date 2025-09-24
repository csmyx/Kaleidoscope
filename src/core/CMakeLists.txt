file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)
message("source files in core: ${SOURCES}")


# 生成静态库（便于测试代码链接）
# add_library(${PROJECT_NAME}_lib STATIC ${SOURCES})
add_library(${PROJECT_NAME}_lib SHARED ${SOURCES})

# 指定库的头文件搜索路径
target_include_directories(${PROJECT_NAME}_lib PUBLIC ${INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME}_lib PUBLIC fmt::fmt)

set(LLVM_DIR "/home/hugo/local/llvm21_cxx/lib/cmake/llvm") # directory that includes LLVMConfig.cmake
find_package(LLVM 21.1 REQUIRED CONFIG)
message(STATUS "LLVM_DIR: ${LLVM_DIR}")
message(STATUS "Found LLVM Version: ${LLVM_PACKAGE_VERSION}")

# llvm_map_components_to_libnames(llvm_libs 
#   Analysis
#   Core
#   ExecutionEngine
#   InstCombine
#   Object
#   OrcJIT
#   Passes
#   RuntimeDyld
#   ScalarOpts
#   Support
#   TransformUtils
#   native
# )
# message(STATUS "llvm_libs: ${llvm_libs}")
# target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${llvm_libs})

execute_process(
    COMMAND llvm-config --libs all
    OUTPUT_VARIABLE LLVM_LIBS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REPLACE " " ";" LLVM_LIBS_LIST "${LLVM_LIBS}")
message(STATUS "LLVM_LIBS_LIST: ${LLVM_LIBS_LIST}")
target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${LLVM_LIBS_LIST})
target_link_directories(${PROJECT_NAME}_lib PUBLIC ${LLVM_LIBRARY_DIRS})

# Set -isystem, used by clangd to find the position of LLVM headers.
# this is better than target_incldue_directories, because -isystem has a greater priority than -I.
include_directories(SYSTEM 
  ${LLVM_INCLUDE_DIRS}                   
)

add_definitions(${LLVM_DEFINITIONS})
if(NOT ${LLVM_ENABLE_RTTI})
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()

target_link_libraries(${PROJECT_NAME}_lib PRIVATE z zstd)

# 调试模式：设置 DEBUG_DEFAULT=1
target_compile_definitions(${PROJECT_NAME}_lib PRIVATE DEBUG_DEFAULT=1)  
