---@class shader
---
---This module provides a datatype `shader` that represents an OpenGL or OpenGL ES shader program.
---
local m = {}

---
---Sets the scaling factor of this shader.
---
---The scaling factor indicates how much the input texture will be scaled by the shader when the shader is applied to the window.
---
---This value only has an effect when the shader is applied to the window (with [sol.video.set_shader()](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_set_shader)), and does nothing when the shader is applied to a drawable object (with [drawable:set_shader()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_set_shader)).
---
---If no value is set (the default), then the output texture of the shader will directly have the size of the window. If a value is set, then the output texture of the shader will have the size of the input texture multiplied by this scaling factor (however, that output texture will then be scaled a second time to fit to the actual window). This is only useful for scaling shaders.
---
---  * `scaling_factor` (number): The scaling factor. A `nil` value means to set no scaling factor.
---
---
---
---@param scaling_factor number
function m:set_scaling_factor(scaling_factor) end

---
---Returns the fragment shader code of this shader program.
---
---  * Return value (string): The fragment shader code. If no fragment shader was set, returns the default fragment shader code.
---
---
---
---@return string
function m:get_fragment_source() end

---
---Sets a uniform value to this shader.
---
---Uniforms are input values to shader programs that are constant for all vertices and pixels during one rendering frame. Solarus automatically sets some uniform variables for you if you define them in the shader (see the [built-in variables](http://www.solarus-games.org/doc/1.6/lua_api_shader.html#lua_api_shader_overview_built_in_variables) section above).
---
---Use this function if you want to pass additional uniform values.
---
---The type of the uniform in your shader source code will depend on the Lua type you pass here:
---
---  * A `boolean:` should be declared as `bool` in the shader.
---  * A `number:` should be declared as `float` in the shader.
---  * An array of two `number`s: should be declared as `vec2` in the shader.
---  * An array of three `number`s: should be declared as `vec3` in the shader.
---  * An array of four `number`s: should be declared as `vec4` in the shader.
---  * A [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html): should be declared as `sampler2D` in the shader.
---
---
---
---If the shader has no uniform with the given name, then this method does nothing.
---
---  * `uniform_name` (string): Name of the uniform in your shader program.
---  * value (boolean, number, table or surface): The value to set. If it is a table, it should be an array of 2, 3 or 4 numbers.
---
---
---
---Remarks
---    If the value is a [surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html), it is passed by reference. This means that if you modify the surface later, the shader with automatically have its updated content. 
---
---@param uniform_name string
---@param value boolean|number|table|surface
function m:set_uniform(uniform_name,value) end

---
---Returns the name of the vertex shader file of this shader program.
---
---  * Return value (string): The vertex shader file name, relative to the `"shaders"` directory, or `nil` if no vertex shader file was set.
---
---
---
---@return string
function m:get_vertex_file() end

---
---Returns the scaling factor of this shader.
---
---The scaling factor indicates how much the input texture will be scaled by the shader. See [shader:set_scaling_factor()](http://www.solarus-games.org/doc/1.6/lua_api_shader.html#lua_api_shader_set_scaling_factor) for more details.
---
---  * Return value (number): The scaling factor. Returns `nil` if no scaling factor is set.
---
---
---
---@return number
function m:get_scaling_factor() end

---
---Returns the name of the fragment shader file of this shader program.
---
---  * Return value (string): The fragment shader file name, relative to the `"shaders"` directory, or `nil` if no fragment shader file was set.
---
---
---
---@return string
function m:get_fragment_file() end

---
---Returns the vertex shader code of this shader program.
---
---  * Return value (string): The vertex shader code. If no vertex shader was set, returns the default vertex shader code.
---
---
---
---@return string
function m:get_vertex_source() end

---
---Returns the id of this shader program.
---
---  * Return value (string): Id of this shader program (filename without extension).
---
---
---
---@return string
function m:get_id() end

_G.shader = m

return m