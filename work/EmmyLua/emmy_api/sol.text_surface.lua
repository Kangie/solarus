---@class sol.text_surface
---
---A text surface is a single line of text that you can display. A text surface can be seen as a special [surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html) able to contain text.
---
local m = {}

---
---Creates a text surface with the specified properties.
---
---  * `properties` (optional table): A table that describes all properties of the text surface to create. Its key-value pairs are all optional, they can be:
---    * `horizontal_alignment` (string, default `"left"`): `"left"`, `"center"` or `"right"`. When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
---    * `vertical_alignment` (string, default `"middle"`): `"top"`, `"middle"` or `"bottom"`. When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
---    * `font` (string, default the first one in alphabetical order): Name of the font file to use, relative to the `fonts` directory and without extension. It must be a declared in the resource list of the [quest database](https://doxygen.solarus-games.org/latest/quest_database_file.html). The following extensions are auto-detected in this order: ```.png`, ```.ttf`, ```.otf`, ```.ttc` and ```.fon`.
---    * `rendering_mode` (string, default `"solid"`): `"solid"` (faster) or `"antialiasing"` (smooth effect on letters).
---    * `color` (table, default white): Color of the text to draw (array of 3 RGB values between 0 and 255). No effect on bitmap fonts.
---    * `font_size` (number, default `11`): Font size to use. No effect on bitmap fonts.
---    * `text` (string, default `""`): The text to show (must be valid UTF-8).
---    * `text_key` (string, default `nil`): Key of the localized text to show. The string must exist in the file [text/strings.dat](https://doxygen.solarus-games.org/latest/quest_language_strings.html) of the current [language](https://doxygen.solarus-games.org/latest/lua_api_language.html).
---    * Return value (text surface): The text surface created.
---
---
---
---@param properties table|nil
---@return text_surface
function m.create(properties) end

---
---Predicts the size of a text surface while avoid its costly creation. This can be useful for example to split text into lines or to insert an image in your dialog box.
---
---  * `font_id` (string) : Name of the font file to use, relative to the `fonts` directory and without extension. It must be declared in the resource list of the [quest database](https://doxygen.solarus-games.org/latest/quest_database_file.html). The following extensions are auto-detected in this order: ```.png`, ```.ttf`, ```.otf`, ```.ttc` and ```.fon`.
---  * `font_size` (number) : Font size to use. No effect on bitmap fonts.
---  * `text` (string) : Text to predict the surface size for. Must be valid UTF-8.
---  * Return value 1 (number) : Predicted width in pixels.
---  * Return value 2 (number) : Predicted height in pixels.
---
---
---
---#  Methods inherited from drawable
---
---Text surfaces are particular [drawable](https://doxygen.solarus-games.org/latest/lua_api_drawable.html) objects. Therefore, they inherit all methods from the type drawable.
---
---See [Methods of all drawable types](https://doxygen.solarus-games.org/latest/lua_api_drawable.html#lua_api_drawable_methods) to know these methods.
---
---#  Methods of the type text surface
---
---The following methods are specific to text surfaces.
---
function m.get_predicted_size() end

return m