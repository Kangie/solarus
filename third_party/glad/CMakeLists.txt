# Add Glad as a library.
add_library(glad STATIC)
target_sources(glad
  PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include/glad/glad.h"
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/glad.c"
)
target_include_directories(glad PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
target_link_libraries(glad PUBLIC KHR::KHR)
set_target_properties(glad PROPERTIES
  FOLDER "third_party"
)
add_library(Glad::Glad ALIAS glad)
