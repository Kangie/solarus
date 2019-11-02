# Generate version.h with versioning info.

configure_file(
  "${CMAKE_SOURCE_DIR}/include/version.h.in"
  "${CMAKE_BINARY_DIR}/include/version.h"
)
