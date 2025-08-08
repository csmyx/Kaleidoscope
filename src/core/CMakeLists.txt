file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)
# 排除第三方库 (fmt) 的文件
# list(FILTER SOURCES EXCLUDE REGEX "${CMAKE_CURRENT_SOURCE_DIR}/extern/fmt/.*")
message("source files in core: ${SOURCES}")


# 生成静态库（推荐，便于测试代码链接）
add_library(${PROJECT_NAME}_lib STATIC ${SOURCES})
# 指定库的头文件搜索路径
target_include_directories(${PROJECT_NAME}_lib PUBLIC ${INCLUDE_DIRS})

