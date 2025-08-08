find_package(Catch2 3 REQUIRED)

file(GLOB_RECURSE test_sources CONFIGURE_DEPENDS *.cpp *.h)
message("test files: ${test_sources}")

# 生成测试可执行文件
add_executable(${PROJECT_NAME}_test)
target_sources(${PROJECT_NAME}_test PUBLIC ${test_sources})
target_link_libraries(${PROJECT_NAME}_test PRIVATE kaleidoscope_lib)
target_link_libraries(${PROJECT_NAME}_test PRIVATE Catch2::Catch2WithMain)

# 添加测试目标（可选，便于使用ctest命令运行）
# add_test(NAME test COMMAND my_project_tests)