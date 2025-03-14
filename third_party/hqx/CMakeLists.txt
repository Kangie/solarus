# Add hqx as a library.
add_library(hqx STATIC)
target_sources(hqx
PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include/hqx/common.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/include/hqx/hqx.h"
PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/src/hq2x.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/hq3x.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/hq4x.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/init.c"
)
# Some calls to std::abs() on unsigned integers.
# set_source_files_properties(
#     "${CMAKE_CURRENT_SOURCE_DIR}/include/hqx/common.h"
#   PROPERTIES
#     COMPILE_OPTIONS "$<$<CXX_COMPILER_ID:GNU,Clang>:-Wno-absolute-value>"
# )
target_include_directories(hqx PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
target_compile_options(hqx PRIVATE -w)
set_target_properties(hqx PROPERTIES
  FOLDER "third_party"
  POSITION_INDEPENDENT_CODE ON
)
add_library(HQX::HQX ALIAS hqx)
