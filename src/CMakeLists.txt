add_subdirectory(core)

# intergrate libfmt through submodule
add_subdirectory(extern/fmt EXCLUDE_FROM_ALL)

# 强制 fmt 生成位置无关代码-fPIC: 生成动态库libkaleidoscope_lib.so，依赖于静态库fmt，所以fmt必须是-fPIC.
set_target_properties(fmt PROPERTIES
  POSITION_INDEPENDENT_CODE ON
)

file(GLOB_RECURSE FMT_FILES CONFIGURE_DEPENDS *.cpp *.h)
# 排除第三方库文件
list(FILTER FMT_FILES EXCLUDE REGEX "${CMAKE_CURRENT_SOURCE_DIR}/extern/fmt/.*")
message("fmt_files: ${FMT_FILES}")

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp)
    add_executable(${PROJECT_NAME}_main)
    target_sources(${PROJECT_NAME}_main PUBLIC main.cpp)

    target_link_libraries(${PROJECT_NAME}_main PRIVATE ${PROJECT_NAME}_lib)

    # 理论上main不需要再显式链接fmt::fmt，如果库${PROJECT_NAME}_lib通过 `PUBLIC` 方式依赖fmt, 会传递给main.
    # 下面这行可以注释掉，但是显式声明所有直接依赖，可以使得项目依赖更加清晰
    # target_link_libraries(${PROJECT_NAME}_main PRIVATE fmt::fmt)

endif()