---@class sol.video
---
---`sol.video` allows you to manage the window and the display.
---
---The area where the game takes place has a fixed size called the quest size. The quest size is in a range specified in the [quest properties file](http://www.solarus-games.org/doc/1.6/quest_properties_file.html). This quest size is the logical size: it determines how much content the player can see on the map.
---
---The quest size is typically 320x240 pixels, but some systems may prefer other sizes, like 400x240 on Android. You can set a range of supported quest sizes in the quest properties files for portability. However, it requires more work on your part: in particular, you have to implement menus and a HUD that can adapt to any size in this range. And be aware that some players will be able to see more game content than others.
---
---The quest can be played in windowed mode or in fullscreen. In windowed mode, the window can be resized by the user or by your scripts. The quest size is independent from the actual window size: when you resize the window, the quest image is scaled to fit the window. The pixel ratio is always preserved, possibly by adding black borders.
---
---Solarus supports OpenGL shaders to modify the rendering, for example to apply a smoothing filter. See the [shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html) documentation for more details.
---
local m = {}

---
---Returns whether the mouse cursor is currently visible.
---
---  * Return value (boolean): `true` if the mouse cursor is currently visible.
---
---
---
---@return boolean
function m.is_cursor_visible() end

---
---Shows or hides the mouse cursor, keeping an equivalent video mode.
---
---  * `visible_cursor` (boolean, optional): `true` to show mouse cursor (no value means `true`).
---
---
---
function m.set_cursor_visible() end

---
---Turns on or turns off fullscreen, keeping an equivalent video mode.
---
---  * `fullscreen` (boolean, optional): `true` to set fullscreen (no value means `true`).
---
---
---
---Remarks
---    When the quest is run from the Solarus GUI, the user can also switch fullscreen from the menus of the GUI.
---
---@param fullscreen boolean|nil
function m.set_fullscreen(fullscreen) end

---
---Sets the text of the title bar of the window.
---
---By default, the window title is set to the title of your quest followed by its version. Both these properties are indicated in the [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html) file.
---
---  * `window_title` (string): The window title to set.
---
---
---
---@param window_title string
function m.set_window_title(window_title) end

---
---Sets a shader to be applied to the rendering.
---
---  * shader ([shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html)): The shader to set. It replaces the previous shader if any. A `nil` value means to apply no shader.
---
---
---
---#  Events of sol.video
---
---Events are callback methods automatically called by the engine if you define them.
---
---@param shader shader
function m.set_shader(shader) end

---
---Returns the text of the title bar of the window.
---
---  * Return value (string): The window title.
---
---
---
---@return string
function m.get_window_title() end

---
---Returns whether the current video mode is fullscreen.
---
---  * Return value (boolean): `true` if the video mode is fullscreen.
---
---
---
---@return boolean
function m.is_fullscreen() end

---
---Returns the logical size of the quest screen.
---
---This quest size is fixed at runtime. It is always in the range of allowed quest sizes specified in [quest.dat](http://www.solarus-games.org/doc/1.6/quest_properties_file.html).
---
---The quest size is independent from the actual window size.
---
---  * Return value 1 (number): Width of the quest screen in pixels.
---  * Return value 2 (number): Height of the quest screen in pixels.
---
---
---
---@return number,number
function m.get_quest_size() end

---
---Returns the size of the window.
---
---The quest image has a [fixed size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) determined when the program starts. This quest image is then scaled to the window. The size of the window can be changed at any moment by the user or by [sol.video.set_window_size()](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_set_window_size). Black borders are added if necessary to keep the correct pixel ratio.
---
---When the window is in fullscreen, this function returns the size to be used when returning to windowed mode.
---
---When Solarus starts, the size of the window is twice the quest size.
---
---  * Return value 1 (number): Width of the window in pixels.
---  * Return value 2 (number): Height of the window in pixels.
---
---
---
---@return number,number
function m.get_window_size() end

---
---Returns the shader currently applied to the rendering, if any.
---
---  * Return value ([shader](http://www.solarus-games.org/doc/1.6/lua_api_shader.html)): The current shader, or `nil` if no shader is applied.
---
---
---
---@return shader
function m.get_shader() end

---
---Sets the size of the window.
---
---See [sol.video.get_window_size()](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_window_size) for a detailed description of the window size.
---
---When the window is in fullscreen, this function still works: the changes will be visible when returning to windowed mode.
---
---  * Return value 1 (number): Width of the window in pixels.
---  * Return value 2 (number): Height of the window in pixels.
---
---
---
---@return number,number
function m.set_window_size() end

return m