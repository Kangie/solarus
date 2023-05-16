---@class sprite : drawable
---
---A sprite is an animated image. It is managed by an animation set. The animation set defines which animations are available and describes, for each animation, a sequence of images in each direction.
---
---A sprite has the following properties:
---
---  * a current animation from its animation set (like `"walking"` or `"hurt"`),
---  * a current direction that indicates where the sprite is facing,
---  * a current frame: the index of the current individual image in the sequence.
---
---
---
---The animation set of a sprite is composed of one or several PNG images that store all the frames, and a data file that describes how frames are organized in the PNG images. The data file also indicates the delay to make between frames when animating them and other properties like whether the animation should loop. See the [sprites syntax](https://doxygen.solarus-games.org/latest/quest_sprite_data_file.html) for more information about the format of sprites.
---
---We describe here the Lua API that you can use to show sprites during your game or your menus.
---
local m = {}

---
---Called when the current animation of this sprite is finished.
---
---If the animation loops, this function is never called. Unless you start another animation, the sprite is no longer shown.
---
---  * `animation` (string): Name of the animation that has just finished.
---
---
---
---@param animation string
function m:on_animation_finished(animation) end

---
---Returns the current direction of this sprite.
---
---  * Return value (number): The current direction (the first one is `0`).
---
---
---
---@return number
function m:get_direction() end

---
---Returns the name of the animation set used by this sprite.
---
---  * Return value (string): Name of the animation set used by this sprite. This name corresponds to a sprite sheet data file in the `sprites` directory (without its extension).
---
---
---
---@return string
function m:get_animation_set() end

---
---Returns whether the specified animation exists on a sprite.
---
---  * `animation_name` (string): Name of the animation to check.
---  * Return value (boolean): `true` if the sprite animation set contains an animation with this name.
---
---
---
---@param animation_name string
---@return boolean
function m:has_animation(animation_name) end

---
---Sets the current animation of this sprite.
---
---  * `animation_name` (string): Name of the animation to set. This animation must exist in the animation set.
---  * `next_action` (function or string, optional): What to do when the animation finishes. This parameter only has an effect if the animation finishes, that is, if it does not loop. If you pass a function, this function will be called when the animation finishes. If you pass a string, this should be the name of an animation of the sprite, and this animation will automatically be played next. No value means no action after the animation finishes: in this case, the sprite stops being displayed.
---
---
---
---@param animation_name string
---@param next_action function|string|nil
function m:set_animation(animation_name,next_action) end

---
---Stops playing the current animation of this sprite.
---
---The sprite stops being displayed, like when the last frame finishes.
---
function m:stop_animation() end

---
---Called whenever the frame of this sprite has changed.
---
---  * `animation` (string): Name of the current animation.
---  * `frame` (number): The new current frame (the first one is `0`). 
---
---
---
---@param animation string
---@param frame number
function m:on_frame_changed(animation,frame) end

---
---Returns the frame size of this sprite in an animation and direction.
---
---  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
---  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`.
---  * Return value 1 (number): The width of a frame.
---  * Return value 2 (number): The height of a frame.
---
---
---
---@param animation_name string|nil
---@param direction number
---@return number|number
function m:get_size(animation_name,direction) end

---
---Returns the delay between two frames of this sprite in an animation.
---
---The delay of the current animation may be overriden by [set_frame_delay()](https://doxygen.solarus-games.org/latest/lua_api_sprite.html#lua_api_sprite_set_frame_delay).
---
---  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
---  * Return value (number): The delay in milliseconds between two frames in the current animation. `nil` means infinite and it is only allowed for single-frame animations.
---
---
---
---@param animation_name string|nil
---@return number
function m:get_frame_delay(animation_name) end

---
---Returns whether the animation should continue even when the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is suspended.
---
---This setting only has an effect when a game is running. The default value is `false`.
---
---  * Return value (boolean): `true` to continue the animation even when the game is suspended.
---
---
---
---@return boolean
function m:get_ignore_suspend() end

---
---Called whenever the direction of this sprite has changed.
---
---  * `animation` (string): Name of the current animation.
---  * `direction` (number): The new current direction (the first one is `0`).
---
---
---
---@param animation string
---@param direction number
function m:on_direction_changed(animation,direction) end

---
---Returns the coordinates of a frame in its source image.
---
---  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
---  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`. No value means the current direction.
---  * `frame` (number, optional): A frame number. No value means the current frame.
---  * Return value 1 (number): X coordinate of the upper left corner of the frame in its source image.
---  * Return value 2 (number): Y coordinate of the upper left corner of the frame in its source image.
---
---
---
---@param animation_name string|nil
---@param direction number
---@param frame number
---@return number|number
function m:get_frame_src_xy(animation_name,direction,frame) end

---
---Sets whether the animation should continue even when the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is suspended.
---
---  * `ignore` (boolean, optional): `true` to continue the animation even when the game is suspended. No value means `true`.
---
---
---
---@param ignore boolean|nil
function m:set_ignore_suspend(ignore) end

---
---Sets the current frame of this sprite.
---
---  * `frame` (number): The frame to set (the first one is `0`). This frame must exist in the current direction.
---
---
---
---@param frame number
function m:set_frame(frame) end

---
---Returns the number of frames of this sprites in an animation and direction.
---
---  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
---  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`. No value means the current direction.
---  * Return value (number): The number of frames.
---
---
---
---@param animation_name string|nil
---@param direction number
---@return number
function m:get_num_frames(animation_name,direction) end

---
---Sets the current direction of this sprite.
---
---  * `direction` (number): The direction to set (the first one is `0`). This direction must exist in the current animation.
---
---
---
---@param direction number
function m:set_direction(direction) end

---
---Called whenever the animation of this sprite has changed.
---
---  * `animation` (string): Name of the new animation.
---
---
---
---@param animation string
function m:on_animation_changed(animation) end

---
---Returns the number of direction of an animation of this sprite.
---
---  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
---  * Return value (number): The number of directions in this animation.
---
---
---
---@param animation_name string|nil
---@return number
function m:get_num_directions(animation_name) end

---
---Changes the delay between two frames of this sprite in the current animation.
---
---Use this function if you want to override the normal delay (the one defined in the sprite data file).
---
---  * `delay` (number): The new delay in milliseconds. `nil` means infinite and is only allowed for single-frame animations.
---
---
---
---@param delay number
function m:set_frame_delay(delay) end

---
---Returns whether this sprite is paused.
---
---  * Return value (boolean): `true` if this sprite is paused.
---
---
---
---@return boolean
function m:is_paused() end

---
---Returns the coordinates of the origin point of this sprite in an animation and direction, relative to the upper left corner of a frame.
---
---The origin is the point of synchronization for sprites that have several animations or directions of different sizes, and for entity sprites that are larger than the entity itself.
---
---See [entity:get_origin()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) for more details.
---
---In a given animation and direction of a sprite, the origin point is the same for all frames.
---
---  * `animation_name` (string, optional): Name of an animation of the sprite. This animation must exist in the animation set. No value means the current animation.
---  * `direction` (number, optional): A direction of this animation, between `0` and `sprite:get_num_directions(animation_name) - 1`.
---  * Return value 1 (number): X coordinate of the origin point.
---  * Return value 2 (number): Y coordinate of the origin point.
---
---
---
---@param animation_name string|nil
---@param direction number
---@return number|number
function m:get_origin(animation_name,direction) end

---
---Returns whether the current animation is being played.
---
---  * Return value (boolean): `true` if the current animation is playing, `false` if it is finished or was [stopped](https://doxygen.solarus-games.org/latest/lua_api_sprite.html#lua_api_sprite_stop_animation).
---
---
---
---@return boolean
function m:is_animation_started() end

---
---Returns the name of the current animation of this sprite.
---
---  * Return value (string): Name of the current animation.
---
---
---
---@return string
function m:get_animation() end

---
---Pauses or resumes the animation of this sprite.
---
---  * `paused` (boolean, optional): `true` to pause the sprite, `false` to unpause it. No value means `true`.
---
---
---
---@param paused boolean|nil
function m:set_paused(paused) end

---
---Synchronizes the frames of this sprite with the frames of a reference sprite. The synchronization will be performed whenever both animation names match. The current sprite will no longer apply its normal frame delay: instead, it will now always set its current frame to the current frame of its reference sprite.
---
---  * `reference_sprite` (sprite, optional): The reference sprite. `nil` means stopping any previous synchronization.
---
---
---
---#  Events of the type sprite
---
---Events are callback methods automatically called by the engine if you define them.
---
---The following events are specific to sprites.
---
---@param reference_sprite sprite|nil
function m:synchronize(reference_sprite) end

---
---Returns the index of the current frame of this sprite.
---
---  * Return value (number): The current frame (the first one is `0`).
---
---
---
---@return number
function m:get_frame() end

_G.sprite = m

return m