---@class surface : drawable
---
---A surface is a 2D image. It is essentially a rectangle of pixels. Its main feature is that you can draw objects on it.
---
local m = {}

---
---Returns the size of this surface.
---
---  * Return value 1 (number): Width of the surface in pixels.
---  * Return value 2 (number): Height of the surface in pixels.
---
---
---
---@return number,number
function m:get_size() end

---
---Returns all pixel values of this surface.
---
---  * Return value (string): The pixels as a pack of bytes in 32-bit RGBA format. Every pixel is stored on 4 bytes (red, green, blue, alpha).
---
---
---
---@return string
function m:get_pixels() end

---
---Erases all pixels of this surface.
---
---All pixels become transparent. The opacity property and the size of the surface are preserved.
---
function m:clear() end

---
---Binds this surface as a target for next OpenGL calls.
---
---This method is only useful for advanced users who want to directly call OpenGL primitives, which is possible with Lua bindings, for example via LuaJIT FFI.
---
---This is equivalent to `glBindFramebuffer(GL_DRAW_FRAMEBUFFER, ...)`. It will make this surface the destination for any further OpenGL draw call.
---
---When you call OpenGL directly, it is your responsability to restore the OpenGL state if you want the Solarus rendering to remain correct. In particular, pay attention to restore :
---
---  * The currently bound `glProgram`
---  * The current `glBlendModes`
---  * The currently bound `VertexBufferObjects`
---  * Face culling and alpha tests.
---
---
---
---Remarks
---    Note that Solarus surfaces have no depth buffer attached. A new framebuffer with depth attachement must be used to benefit from `GL_DEPTH_TEST`.
---
function m:gl_bind_as_target() end

---
---Bind this surface as the current texture for next OpenGL calls.
---
---This method is only useful for advanced users who want to directly call OpenGL primitives, which is possible with Lua bindings, for example via LuaJIT FFI.
---
---This is equivalent to `glBindTexture(...)`.
---
---See [surface:gl_bind_as_target()](http://www.solarus-games.org/doc/1.6/lua_api_surface.html#lua_api_surface_gl_bind_as_target) for details about calling OpenGL directly. 
---
function m:gl_bind_as_texture() end

---
---Sets all pixel values of this surface.
---
---The number of pixels should match the size of the surface (the size does not change).
---
---  * `pixels` (string): The pixels as a pack of bytes in 32-bit RGBA format. Every pixel is stored on 4 bytes (red, green, blue, alpha).
---
---
---
---@param pixels string
function m:set_pixels(pixels) end

---
---Fills a region of this surface with a color.
---
---If no region is specified, the entire surface is filled. If the color has an alpha component different from 255 (opaque), then the color is blended onto the existing pixels.
---
---  * `color` (table): The color as an array of 3 RGB values or 4 RGBA values (`0` to `255`).
---  * `x` (number, optional): X coordinate of the region to fill on this surface.
---  * `y` (number, optional): Y coordinate of the region to fill on this surface.
---  * `width` (number, optional): Width of the region to fill on this surface.
---  * `height` (number, optional): Height of the region to fill on this surface.
---
---
---
---@param color table
---@param x number|nil
---@param y number
---@param width number
---@param height number
function m:fill_color(color,x,y,width,height) end

_G.surface = m

return m