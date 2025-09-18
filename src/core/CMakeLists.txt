file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)
message("source files in core: ${SOURCES}")


# 生成静态库（便于测试代码链接）
# add_library(${PROJECT_NAME}_lib STATIC ${SOURCES})
add_library(${PROJECT_NAME}_lib SHARED ${SOURCES})

# 指定库的头文件搜索路径
target_include_directories(${PROJECT_NAME}_lib PUBLIC ${INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME}_lib PUBLIC fmt::fmt)

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
target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${llvm_libs})

# 引入 FetchContent 模块
include(FetchContent)

# 声明拉取 spdlog（可指定版本，如 GIT_TAG v1.12.0）
FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG v1.15.3  # 可选：指定版本（如最新稳定版）
)

# 拉取并编译 spdlog
FetchContent_MakeAvailable(spdlog)

# We must build deps with -fpic if we want to build our lib as a shared lib.
set_target_properties(spdlog PROPERTIES POSITION_INDEPENDENT_CODE ON)

target_link_libraries(${PROJECT_NAME}_lib PRIVATE spdlog::spdlog)

# 调试模式：设置 DEBUG_DEFAULT=1
target_compile_definitions(${PROJECT_NAME}_lib PRIVATE DEBUG_DEFAULT=1)  
