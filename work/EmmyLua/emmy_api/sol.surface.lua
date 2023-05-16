---@class sol.surface
---
---A surface is a 2D image. It is essentially a rectangle of pixels. Its main feature is that you can draw objects on it.
---
local m = {}

---
---Creates a surface from an image file.
---
---  * `file_name` (string): Name of the image file to load.
---  * `language_specific` (boolean, optional): `true` to load the image from the `images` subdirectory of the current language directory (default is `false` and loads the image from the `sprites` directory).
---  * Return value (surface): The surface created, or `nil` if the image file could not be loaded.
---
---
---
---#  Methods inherited from drawable
---
---Surfaces are particular [drawable](https://doxygen.solarus-games.org/latest/lua_api_drawable.html) objects. Therefore, they inherit all methods from the type drawable.
---
---See [Methods of all drawable types](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_methods) to know these methods.
---
---#  Methods of the type surface
---
---The following methods are specific to surfaces.
---
---@param file_name string
---@param language_specific boolean|nil
---@return surface
function m.create(file_name,language_specific) end

return m