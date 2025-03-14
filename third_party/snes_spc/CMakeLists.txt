# Add snes_spc as a library.
add_library(snes_spc STATIC)
target_sources(snes_spc
  PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/src/spc.h"
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SNES_SPC.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SPC_CPU.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SPC_DSP.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SPC_Filter.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/dsp.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/blargg_common.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/blargg_config.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/blargg_endian.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/blargg_source.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SNES_SPC.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SNES_SPC_misc.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SNES_SPC_state.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SPC_DSP.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/SPC_Filter.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/dsp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/spc.cpp"
)
target_include_directories(snes_spc PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/src"
)
# # The SNES SPC emulator has a complex code made of tangling switch cases and macros.
# # Adding [[fallthrough]] without breaking something would be too complicated.
# set_source_files_properties(
#     "${CMAKE_CURRENT_SOURCE_DIR}/include/snes_spc/SNES_SPC.h"
#     "${CMAKE_CURRENT_SOURCE_DIR}/src/SNES_SPC.cpp"
#   PROPERTIES
#     COMPILE_OPTIONS "$<$<CXX_COMPILER_ID:GNU,Clang>:-Wno-implicit-fallthrough>"
# )
target_compile_options(snes_spc PRIVATE -w)
set_target_properties(snes_spc PROPERTIES
  FOLDER "third_party"
  POSITION_INDEPENDENT_CODE ON
)
add_library(SNES_SPC::SNES_SPC ALIAS snes_spc)
