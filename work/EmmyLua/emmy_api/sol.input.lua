---@class sol.input
---
---You can get information about the low-level keyboard and joypad inputs through `sol.input`.
---
---But remember that when a low-level keyboard or joypad input event occurs, all useful objects ([sol.main](https://doxygen.solarus-games.org/latest/lua_api_main.html), the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html), [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) and [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html)) are already notified. For example, when the user presses a keyboard key, the engine automatically calls [sol.main:on_key_pressed()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_on_key_pressed).
---
---Also note that during the game, there exists the higher-level notion of [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) to ease your life.
---
local m = {}

---
---Returns the current direction of a hat of the joypad.
---
---  * `hat` (number): Index of a joypad hat. The first one is `0`.
---  * Return value (number): The direction of that hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
---
---
---
---@param hat number
---@return number
function m.get_joypad_hat_direction(hat) end

---
---Enables or disables joypad support.
---
---Joypad support may be enabled even without any joypad plugged.
---
---  * `joypad_enabled` `true` to enable joypad support, false to disable it. No value means `true`.
---
---
---
function m.set_joypad_enabled() end

---
---Simulates releasing a keyboard key.
---
---  * `key` (string): The keyboard key to simulate. 
---
---
---
---@param key string
function m.simulate_key_released(key) end

---
---Returns the current position of the mouse cursor relative to the quest size.
---
---If the mouse is outside the window, mouse coordinates are captured only if a mouse button is pressed. In this case, the returned values can be out of bounds of the quest size and can be negative. This allows you to keep track of the mouse movement when dragging something. Otherwise, when no mouse button is pressed, the returned coordinates are the last position of the mouse in the window.
---
---  * Return value 1 (integer): The `x` position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * Return value 2 (integer): The `y` position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---
---
---
---@return integer|integer
function m.get_mouse_position() end

---
---Simulates pressing a keyboard key.
---
---  * `key` (string): The keyboard key to simulate.
---
---
---
---@param key string
function m.simulate_key_pressed(key) end

---
---Returns whether a joypad button is currently down.
---
---  * `button` (number): Index of a button of the joypad.
---  * Return value (boolean): `true` if this joypad button is currently down.
---
---
---
---@param button number
---@return boolean
function m.is_joypad_button_pressed(button) end

---
---Returns whether a keyboard key is currently down.
---
---  * `key` (string): The name of a keyboard key.
---  * Return value (boolean): `true` if this keyboard key is currently down.
---
---
---
---@param key string
---@return boolean
function m.is_key_pressed(key) end

---
---Returns whether a finger is currently pressed.
---
---  * `finger` (integer): The finger id to check.
---  * Return value (boolean): `true` if the finger is down.
---
---
---
---@param finger integer
---@return boolean
function m.is_finger_pressed(finger) end

---
---Returns the current pressure of a finger if it exists.
---
---  * `finger` (integer): The finger id to check.
---  * Return value 1 (number): The `pressure` of the finger between `0.0` and `1.0`. Return `nil` if there is no such finger.
---
---
---
---@param finger integer
---@return number
function m.get_finger_pressure(finger) end

---
---Returns the current position of a finger if it exists.
---
---  * `finger` (integer): The finger id to check.
---  * Return value 1 (integer): The `x` position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates. Return `nil` if the finger does not exist or is not pressed.
---  * Return value 2 (integer): The `y` position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---
---
---
---@param finger integer
---@return integer|integer
function m.get_finger_position(finger) end

---
---Returns the current state of an axis of the joypad.
---
---  * `axis` (number): Index of a joypad axis. The first one is `0`.
---  * Return value (number): The state of that axis. `-1` means left or up, `0` means centered and `1` means right or down.
---
---
---
---@param axis number
---@return number
function m.get_joypad_axis_state(axis) end

---
---Returns the keyboard key modifiers currently active.
---
---  * Return value (table): A table whose keys indicate what modifiers are currently down. Possible table keys are `"shift"`, `"control"`, `"alt"` and `"caps lock"`. Table values are `true`.
---
---
---
---@return table
function m.get_key_modifiers() end

---
---Returns whether a mouse button is currently down.
---
---  * `button` (string): The name of a mouse button. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * Return value (boolean): `true` if mouse button is down.
---
---
---
---@param button string
---@return boolean
function m.is_mouse_button_pressed(button) end

---
---Returns whether joypad support is enabled.
---
---This may be true even without any joypad plugged.
---
---  * Return value (boolean): `true` if joypad support is enabled.
---
---
---
---@return boolean
function m.is_joypad_enabled() end

return m