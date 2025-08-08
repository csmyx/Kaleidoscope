add_subdirectory(extern/fmt EXCLUDE_FROM_ALL)

add_executable(main)
aux_source_directory(. sources)
target_sources(main PUBLIC ${sources})
target_link_libraries(main PRIVATE fmt::fmt)