file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)
message("source files in core: ${SOURCES}")


# 生成静态库（便于测试代码链接）
add_library(${PROJECT_NAME}_lib STATIC ${SOURCES})
# 指定库的头文件搜索路径
target_include_directories(${PROJECT_NAME}_lib PUBLIC ${INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME}_lib PRIVATE fmt::fmt)

find_package(LLVM 14 REQUIRED CONFIG)
message(STATUS "LLVM_DIR: ${LLVM_DIR}")
message(STATUS "Found LLVM Version: ${LLVM_PACKAGE_VERSION}")

# https://github.com/llvm/llvm-project/blob/llvmorg-14.0.0/llvm/examples/Kaleidoscope/Chapter4/CMakeLists.txt
llvm_map_components_to_libnames(llvm_libs
  Analysis
  Core
  ExecutionEngine
  InstCombine
  Object
  OrcJIT
  RuntimeDyld
  ScalarOpts
  Support
  native
)
target_link_libraries(${PROJECT_NAME}_lib PRIVATE ${llvm_libs})