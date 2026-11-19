find_package(Catch2 3 REQUIRED)

set(test_sources
    ./emit_object.cpp
)

message("test emit_object")

set(test_name emit_object)
add_executable(${test_name})
target_sources(${test_name} PUBLIC ${test_sources})
target_link_libraries(${test_name} PRIVATE kaleidoscope_lib)
