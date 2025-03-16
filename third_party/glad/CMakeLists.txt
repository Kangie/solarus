# Add Glad as a library.
add_library(glad STATIC)

target_sources(glad
  PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include/glad/glad.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/include/KHR/khrplatform.h"
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/glad.c"
)

target_include_directories(glad
  PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

set_target_properties(glad
  PROPERTIES
    FOLDER "third_party"
    POSITION_INDEPENDENT_CODE ON
)

add_library(Glad::Glad ALIAS glad)
