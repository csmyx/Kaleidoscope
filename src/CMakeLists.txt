add_subdirectory(extern/fmt EXCLUDE_FROM_ALL)

add_executable(main)

file(GLOB_RECURSE sources CONFIGURE_DEPENDS *.cpp *.h)
# 排除第三方库 (fmt) 的文件
list(FILTER sources EXCLUDE REGEX "${CMAKE_CURRENT_SOURCE_DIR}/extern/fmt/.*")
message("source files: ${sources}")

target_sources(main PUBLIC ${sources})


##### begin of [clang-tidy] settings #####
function(enable_clang_tidy TARGET)
  find_program(CLANG_TIDY "clang-tidy")
  if(CLANG_TIDY)
    message(STATUS "clang-tidy found: ${CLANG_TIDY}")
    # 设置目标级 clang-tidy
    set_target_properties(${TARGET} PROPERTIES
      CXX_CLANG_TIDY "${CMAKE_CXX_CLANG_TIDY}"
    )
    
    # 添加自定义检查目标
    add_custom_target(${TARGET}-clang-tidy
      COMMAND ${CLANG_TIDY}
        -p ${CMAKE_BINARY_DIR}
        $<TARGET_PROPERTY:${TARGET},SOURCES>
      COMMENT "Running clang-tidy on ${TARGET}"
      DEPENDS ${TARGET}
    )
  endif()
endfunction()

# 使用示例
enable_clang_tidy(main)
##### end of [clang-tidy] settings #####

##### begin of [clang-format] settings #####
find_program(CLANG_FORMAT clang-format)
if(CLANG_FORMAT)
  message(STATUS "clang-format found: ${CLANG_FORMAT}")

  # 定义一个自定义目标来执行 clang-format
  add_custom_target(
    format
    COMMAND ${CLANG_FORMAT} --style=file -i ${sources}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Formatting C/C++ code with clang-format"
  )

#   可选：添加一个依赖，使得在构建目标时自动执行格式化
#   add_dependencies(all format) # 假设 "all" 是你的主目标

#   可选：配置 clang-format 的行为，例如指定配置文件
#   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ferror-limit=0") # 示例：不限制错误数量

else()
  message(WARNING "clang-format not found, skipping format target")
endif()
##### end of [clang-format] settings #####
target_link_libraries(main PRIVATE fmt::fmt)