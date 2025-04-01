---@class text_surface : drawable
---
---A text surface is a single line of text that you can display. A text surface can be seen as a special [surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html) able to contain text.
---
local m = {}

---
---Returns the size of this text surface.
---
---  * Return value 1 (number): Width of the text surface in pixels.
---  * Return value 2 (number): Height of the text surface in pixels.
---
---
---
---Remarks
---    Note that you cannot set the size of a text surface. The size is determined by the text and the font. 
---
---@return number|number
function m:get_size() end

---
---Returns the rendering mode of the text.
---
---  * Return value (string): `"solid"` (faster) or `"antialiasing"` (smooth effect on letters).
---
---
---
---@return string
function m:get_rendering_mode() end

---
---Sets the vertical alignment of the text.
---
---When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
---
---  * `vertical_alignment` (string): `"top"`, `"middle"` or `"bottom"`.
---
---
---
---@param vertical_alignment string
function m:set_vertical_alignment(vertical_alignment) end

---
---Sets the color used to draw the text.
---
---This only has an effect for outline fonts.
---
---  * `color` (table): The text color as an array of 3 RGB values (`0` to `255`).
---
---
---
---@param color table
function m:set_color(color) end

---
---Sets the text as a localized string in the current language.
---
---  * `key` (string): Key of the text to set.
---
---
---
---Remarks
---    This function is equivalent to `text_surface:set_text(sol.language.get_string(key))`.
---
---@param key string
function m:set_text_key(key) end

---
---Sets the font used to draw this text surface.
---
---  * `font_id` (string): Name of the font file to use, relative to the `fonts` directory and without extension. It must be a declared in the resource list of the [quest database](https://doxygen.solarus-games.org/latest/quest_database_file.html). The following extensions are auto-detected in this order: ```.png`, ```.ttf`, ```.ttc` and ```.fon`.
---
---
---
---@param font_id string
function m:set_font(font_id) end

---
---Sets the size used to draw the text.
---
---This only has an effect for outline fonts.
---
---  * `font_size` (number): The font size.
---
---
---
---@param font_size number
function m:set_font_size(font_size) end

---
---Sets the horizontal alignment of the text.
---
---When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
---
---  * `horizontal_alignment` (string): `"left"`, `"center"` or `"right"`.
---
---
---
---@param horizontal_alignment string
function m:set_horizontal_alignment(horizontal_alignment) end

---
---Sets the string displayed in this object.
---
---The string must be encoded in UTF-8.
---
---  * `text` (string, optional): The text to set. No value or an empty string mean no text.
---
---
---
---@param text string|nil
function m:set_text(text) end

---
---Returns the font used to draw this text surface.
---
---  * Return value (string): Id of the font of this text surface.
---
---
---
---@return string
function m:get_font() end

---
---Returns the font size used to draw the text.
---
---This only has an effect for outline fonts.
---
---  * Return value (number): The font size.
---
---
---
---@return number
function m:get_font_size() end

---
---Returns the horizontal alignment of the text.
---
---When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
---
---  * Return value (string): `"left"`, `"center"` or `"right"`.
---
---
---
---@return string
function m:get_horizontal_alignment() end

---
---Returns the string displayed in this object.
---
---  * Return value (string): The current text (possibly an empty string).
---
---
---
---@return string
function m:get_text() end

---
---Sets the rendering mode of the text.
---
---  * `rendering_mode` (string): `"solid"` (faster) or `"antialiasing"` (smooth effect on letters).
---
---
---
---@param rendering_mode string
function m:set_rendering_mode(rendering_mode) end

---
---Returns the vertical alignment of the text.
---
---When you draw the text surface at some coordinates on a destination surface, it is anchored at this position.
---
---  * Return value (string): `"top"`, `"middle"` or `"bottom"`.
---
---
---
---@return string
function m:get_vertical_alignment() end

---
---Returns the color used to draw the text.
---
---This only has an effect for outline fonts.
---
---  * Return value (table): The text color as an array of 3 RGB values (`0` to `255`).
---
---
---
---@return table
function m:get_color() end

_G.text_surface = m

return m