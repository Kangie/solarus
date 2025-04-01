---@class sol.shader
---
---This module provides a datatype `shader` that represents an OpenGL or OpenGL ES shader program.
---
local m = {}

---
---Returns the GLSL or GLSL ES format supported by the OpenGL or OpenGL ES version currently used.
---
---  * Return value (string): A string describing the shading language version.
---
---
---
---#  Methods of the type shader
---
---@return string
function m.get_shading_language_version() end

---
---Loads and returns a shader program from the given parameters.
---
---This function can be used for advanced purposes, but the normal way is to use [sol.shader.create(shader_id)](https://doxygen.solarus-games.org/latest/lua_api_shader.html#lua_api_shader_create_id), that is, to load a shader already described in a data file.
---
---If the loading or the compilation of the shader program fails, a Lua error is raised.
---
---  * `properties` (table): Source and parameters of the shader program. Can have the following entries:
---    * `vertex_source` (string, optional): GLSL code of the vertex shader. No values means to use a default shader that does nothing special
---    * `fragment_source` (string, optional): GLSL code of the fragment shader. No values means to use a default shader that does nothing special.
---    * `scaling_factor` (number, optional): When the shader is applied to the whole window, indicates how much the input texture will be scaled by the shader. See [shader:set_scaling_factor()](https://doxygen.solarus-games.org/latest/lua_api_shader.html#lua_api_shader_set_scaling_factor) for more details.
---  * Return value (shader): The shader program created.
---
---
---
---@param properties table
---@return shader
function m.create(properties) end

---
---Returns the OpenGL or OpenGL ES version Solarus is being run with.
---
---  * Return value (string): A string describing the OpenGL or OpenGL ES version.
---
---
---
---@return string
function m.get_opengl_version() end

return m