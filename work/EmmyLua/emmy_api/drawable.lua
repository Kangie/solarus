---@class drawable
---
---Drawable objects are things that can be drawn on a destination surface. They include the following types: [surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html), [text surface](https://doxygen.solarus-games.org/latest/lua_api_text_surface.html) and [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html). This page describes the methods common to those types.
---
local m = {}

---
---Returns the scaling factors of this drawable object.
---
---  * Return value 1 (number): Scale factor in the X dimension.
---  * Return value 2 (number): Scale factor in the Y dimension.
---
---
---
---@return number|number
function m:get_scale() end

---
---Sets the rotation angle of this object around its [transformation origin](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_set_transformation_origin). The rotation angle is in radians and goes in trigonometric direction.
---
---  * `rotation` (number): The rotation angle in radians around the transformation origin. `0` means no rotation.
---
---
---
---@param rotation number
function m:set_rotation(rotation) end

---
---Returns the blend mode of this drawable object.
---
---The blend mode defines how this drawable object will be drawn on other surfaces when you call [drawable:draw()](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_draw) or [drawable:draw_region()](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_draw_region).
---
---  * Return value (string): The blend mode. See [drawable:set_blend_mode()](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_set_blend_mode) for the possible values.
---
---
---
---@return string
function m:get_blend_mode() end

---
---Set the transformation origin point of this drawable object. The tranformation origin point is the pivot point used for rotation and scaling.
---
---The transformation point is relative to the origin point of the drawable object, which is always the upper-left corner for [surfaces](https://doxygen.solarus-games.org/latest/lua_api_surface.html) and [text surfaces](https://doxygen.solarus-games.org/latest/lua_api_text_surface.html), and the sprite origin point for [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html).
---
---  * `x` (number): X coordinate of the transformation origin.
---  * `y` (number): Y coordinate of the transformation origin.
---
---
---
---@param x number
---@param y number
function m:set_transformation_origin(x,y) end

---
---Sets the shader used to draw this object.
---
---Default drawing is done with no shader.
---
---  * `shader` ([shader](https://doxygen.solarus-games.org/latest/lua_api_shader.html)): The shader to set, or `nil` to reset drawing to normal.
---
---
---
---@param shader shader
function m:set_shader(shader) end

---
---Returns the opacity of this drawable.
---
---  * Return value (integer): The opacity: `0` (transparent) to `255` (opaque).
---
---
---
---@return integer
function m:get_opacity() end

---
---Set the scale factors for this drawable object. A scale of `1` corresponds to a normal size. A negative scale will flip the drawable in the corresponding axis. Scaling is performed around the [transformation origin](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_set_transformation_origin).
---
---  * `x` (number) : Scale factor in the X dimension.
---  * `y` (number) : Scale factor in the Y dimension.
---
---
---
function m:set_scale() end

---
---Sets the opacity of this drawable.
---
---All drawables are initially opaque.
---
---  * `opacity` (integer): The opacity: `0` (transparent) to `255` (opaque).
---
---
---
---@param opacity integer
function m:set_opacity(opacity) end

---
---Returns the rotation angle of this object around its [transformation origin](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_set_transformation_origin). The rotation angle is in radians and goes in trigonometric direction.
---
---  * Return value (number): The rotation angle in radians around the transformation origin. `0` means no rotation.
---
---
---
---@return number
function m:get_rotation() end

---
---Returns the current movement of this drawable object.
---
---  * Return value ([movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html)): The current movement, or `nil` if the drawable object is not moving.
---
---
---
---@return movement
function m:get_movement() end

---
---Sets the blend mode of this drawable object.
---
---The blend mode defines how this drawable object will be drawn on other surfaces when you call [drawable:draw()](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_draw) or [drawable:draw_region()](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_draw_region).
---
---  * `blend_mode` (string): The blend mode. Can be one of:
---    * `"none"`: No blending. The destination surface is replaced by the pixels of this drawable object.  
---`dstRGBA = srcRGBA`
---    * `"blend"` (default): This drawable object is alpha-blended onto the destination surface.  
---`dstRGB = (srcRGB * srcA) + (dstRGB * (1 - srcA))`  
---`dstA = srcA + (dstA * (1 - srcA))`
---    * `"add"`: This drawable object is drawn onto the destination surface with additive blending. The clarity of the destination surface is kept. Useful to color and lighten the destination surface.  
---`dstRGB = (srcRGB * srcA) + dstRGB`
---    * `"multiply"`: Color modulation. Can be used to darken the destination surface without degrading its content.  
---`dstRGB = srcRGB * dstRGB`
---
---
---
---@param blend_mode string
function m:set_blend_mode(blend_mode) end

---
---Stops the current movement of this drawable object if any. 
---
function m:stop_movement() end

---
---Sets the offset added where this drawable object is drawn.
---
---This value is initially `0,0`. It is added to whatever coordinates the object is drawn at.
---
---  * `x` (number): X offset to set.
---  * `y` (number): Y offset to set.
---
---
---
---@param x number
---@param y number
function m:set_xy(x,y) end

---
---Starts a fade-out effect on this object.
---
---You can specify a callback function to be executed when the fade-out effect finishes.
---
---If the drawable object is a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) during a game, the fade-out effect gets the lifetime of that entity. The behavior is probably what you expect: the fade-out effect gets suspended when the entity gets suspended, and it gets canceled (that is, the callback is never executed) when the map entity is destroyed.
---
---  * `delay` (number, optional): Delay in milliseconds between two frames of the fade-out animation (default `20`).
---  * `callback` (function, optional): A function to call when the fade-out effect finishes.
---
---
---
---Note
---    When your drawable object does not belong to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) (typically in a title screen before a game is started, or in your pause menu), the fade-out effect continues until the drawable object is garbage-collected. In other words, the callback can be executed even if you have stopped using the drawable object in the meantime. Therefore, you should use the `callback` parameter with care. In these situations, using a [timer](https://doxygen.solarus-games.org/latest/lua_api_timer.html) for your callback is easier because timers have an explicit lifetime.
---
---@param delay number|nil
---@param callback function|nil
function m:fade_out(delay,callback) end

---
---Returns the offset added where this drawable object is drawn.
---
---This value is initially `0,0`. It is added to whatever coordinates the object is drawn at.
---
---They can be modified by a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) or by [drawable:set_xy()](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_set_xy).
---
---  * Return value 1 (number): X offset of the drawable object.
---  * Return value 2 (number): Y offset of the drawable object.
---
---
---
---@return number|number
function m:get_xy() end

---
---Draws this object on a destination surface.
---
---  * `dst_surface` ([surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html)): The destination surface.
---  * `x` (number, optional): X coordinate of where to draw this object (default `0`).
---  * `y` (number, optional): Y coordinate of where to draw this object. (default `0`).
---
---
---
---@param dst_surface surface
---@param x number|nil
---@param y number
function m:draw(dst_surface,x,y) end

---
---Draws a subrectangle of this object on a destination surface.
---
---  * `region_x` (number): X coordinate of the subrectangle to draw.
---  * `region_y` (number): Y coordinate of the subrectangle to draw.
---  * `region_width` (number): Width of the subrectangle to draw.
---  * `region_height` (number): Height of the subrectangle to draw.
---  * `dst_surface` ([surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html)): The destination surface.
---  * `x` (number, optional): X coordinate of where to draw this rectangle on the destination surface (default `0`).
---  * `y` (number, optional): Y coordinate of where to draw this rectangle. on the destination surface (default `0`).
---
---
---
---@param region_x number
---@param region_y number
---@param region_width number
---@param region_height number
---@param dst_surface surface
---@param x number|nil
---@param y number
function m:draw_region(region_x,region_y,region_width,region_height,dst_surface,x,y) end

---
---Starts a fade-in effect on this object.
---
---You can specify a callback function to be executed when the fade-in effect finishes.
---
---If the drawable object is a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) during a game, the fade-in effect gets the lifetime of that entity. The behavior is probably what you expect: the fade-in effect gets suspended when the entity gets suspended, and it gets canceled (that is, the callback is never executed) when the map entity is destroyed.
---
---  * `delay` (number, optional): Delay in milliseconds between two frames of the fade-in animation (default `20`).
---  * `callback` (function, optional): A function to call when the fade-in effect finishes.
---
---
---
---Note
---    When your drawable object does not belong to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) (typically in a title screen before a game is started, or in your pause menu), the fade-in effect continues until the drawable object is garbage-collected. In other words, the callback can be executed even if you have stopped using the drawable object in the meantime. Therefore, you should use the `callback` parameter with care. In these situations, using a [timer](https://doxygen.solarus-games.org/latest/lua_api_timer.html) for your callback is easier because timers have an explicit lifetime.
---
---@param delay number|nil
---@param callback function|nil
function m:fade_in(delay,callback) end

---
---Sets the color modulator of this drawable, default is plain white {255,255,255,255}. When the drawable is draw, all the pixels are multiplied by this color (white as no effect). Alpha channel and drawable opacity are multiplied together.
---
---  * `color` (table): The color multiplier, as an array of RGBA values.
---
---
---
---@param color table
function m:set_color_modulation(color) end

---
---Returns the transformation origin of this drawable object. The tranformation origin point is the pivot point used for rotation and scaling.
---
---The transformation point is relative to the origin point of the drawable object, which is always the upper-left corner for [surfaces](https://doxygen.solarus-games.org/latest/lua_api_surface.html) and [text surfaces](https://doxygen.solarus-games.org/latest/lua_api_text_surface.html), and the sprite origin point for [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html).
---
---  * Return value 1 (number): X coordinate of the transform point.
---  * Return value 2 (number): Y coordinate of the transform point.
---
---
---
---@return number|number
function m:get_transformation_origin() end

---
---Returns the color multiplier of this drawable.
---
---  * Return value (table): The color as an array of RGBA values
---
---
---
---@return table
function m:get_color_modulation() end

---
---Returns the shader applied to this object.
---
---  * Return value ([shader](https://doxygen.solarus-games.org/latest/lua_api_shader.html)): The shader, or `nil` if no shader is set.
---
---
---
---@return shader
function m:get_shader() end

_G.drawable = m

return m