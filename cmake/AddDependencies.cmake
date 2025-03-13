# This file adds the necessary dependencies of the Solarus library.

# Whether LuaJIT should be used instead of vanilla Lua.
option(SOLARUS_USE_LUAJIT "Use LuaJIT instead of default Lua (recommended)" ON)

# Tell FindOpengl to use modern GL lib system
set(OpenGL_GL_PREFERENCE GLVND)

# Find dependencies.
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/")
find_package(SDL2 "2.0.18" REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)
find_package(OpenGL)
find_package(GLM REQUIRED)
find_package(OpenAL REQUIRED)
find_package(Vorbis REQUIRED)
find_package(VorbisFile REQUIRED)
find_package(Ogg REQUIRED)
find_package(ModPlug REQUIRED)
find_package(PhysFS REQUIRED)
if(SOLARUS_USE_LUAJIT)
  find_package(LuaJIT REQUIRED)
else()
  find_package(Lua "5.1" EXACT REQUIRED)
  add_library(Lua::Lua UNKNOWN IMPORTED)
  set_target_properties(Lua::Lua PROPERTIES
    IMPORTED_LOCATION "${LUA_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${LUA_INCLUDE_DIR}"
  )
endif()
if(SOLARUS_PROFILING)
  find_package(easy_profiler REQUIRED)
endif()

# # Disable warnings on imported targets.
# target_compile_options(SDL2::Core INTERFACE -w)
# target_compile_options(SDL2::Image INTERFACE -w)
# target_compile_options(SDL2::TTF INTERFACE -w)
# target_compile_options(GLM::GLM INTERFACE -w)
# target_compile_options(OpenAL::OpenAL INTERFACE -w)
# target_compile_options(Vorbis::File INTERFACE -w)
# target_compile_options(PhysFS::PhysFS INTERFACE -w)
# target_compile_options(Ogg::Ogg INTERFACE -w)
# target_compile_options(ModPlug::ModPlug INTERFACE -w)

# if(OPENGL_FOUND)
#   target_compile_options(OpenGL::GL INTERFACE -w)
# endif()

# if(LUA_FOUND)
#   target_compile_options(Lua::Lua INTERFACE -w)
# elseif(LUAJIT_FOUND)
#   target_compile_options(Lua::LuaJIT INTERFACE -w)
# endif()

# These dependencies are managed internally.
add_subdirectory(third_party)
