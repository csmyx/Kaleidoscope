file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)
message("source files in core: ${SOURCES}")


# 生成静态库（便于测试代码链接）
add_library(${PROJECT_NAME}_lib STATIC ${SOURCES})
# 指定库的头文件搜索路径
target_include_directories(${PROJECT_NAME}_lib PUBLIC ${INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME}_lib PRIVATE fmt::fmt)

find_package(LLVM 14 REQUIRED CONFIG)
message(STATUS "Found LLVM Version: ${LLVM_PACKAGE_VERSION}")

# 将 LLVM 组件映射为库名
# 常用组件：core（核心 IR）、irreader（读取 IR 文件）、analysis（分析工具）、executionengine（JIT）等
llvm_map_components_to_libnames(llvm_libs 
  core 
  irreader 
  analysis 
)
target_link_libraries(${PROJECT_NAME}_lib PRIVATE ${llvm_libs})