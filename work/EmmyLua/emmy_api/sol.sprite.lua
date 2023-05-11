---@class sol.sprite
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
---The animation set of a sprite is composed of one or several PNG images that store all the frames, and a data file that describes how frames are organized in the PNG images. The data file also indicates the delay to make between frames when animating them and other properties like whether the animation should loop. See the [sprites syntax](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) for more information about the format of sprites.
---
---We describe here the Lua API that you can use to show sprites during your game or your menus.
---
local m = {}

---
---Creates a sprite.
---
---  * `animation_set_id` (string): Name of the animation set to use. This name must correspond to a valid sprite sheet data file in the `sprites` directory (without its extension).
---  * Return value (sprite): The sprite created, or `nil` if the sprite data file could not be loaded.
---
---
---
---#  Methods inherited from drawable
---
---Sprites are particular [drawable](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) objects. Therefore, they inherit all methods from the type drawable.
---
---See [Methods of all drawable types](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_methods) to know these methods.
---
---#  Methods of the type sprite
---
---The following methods are specific to sprites.
---
---@param animation_set_id string
---@return sprite
function m.create(animation_set_id) end

return m