---@class pixel_movement : movement
---
---A pixel movement makes a succession of basic translations, where each translation is a pixel-precise specified move (for example `(+2,-1)`). Each translation is immediate.
---
---Unlike most other types of movements, there is no notion of speed in pixels per seconds. That's because a translation can transport the object instantly to another place - the movement is not necessarily continuous. Instead, you can set the delay between each translation.
---
---Remarks
---    Pixel movements are not often needed. Most of the time, you don't want to specify pixel-by-pixel trajectories. Higher-level types of movements like [path movement](https://doxygen.solarus-games.org/latest/lua_api_path_movement.html#lua_api_path_movement_methods) or [target movement](https://doxygen.solarus-games.org/latest/lua_api_target_movement.html#lua_api_target_movement_methods) usually fit your needs when you move [NPCs](https://doxygen.solarus-games.org/latest/lua_api_npc.html) or [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html).
---
local m = {}

---
---Returns the trajectory of this movement.
---
---  * Return value (table): An array of all successive translations. Each translation is itself an array of two integers (x and y).
---
---
---
---@return table
function m:get_trajectory() end

---
---Sets whether this movement should restart automatically when the trajectory is finished.
---
---  * `loop` (boolean, optional): `true` to make the movement loop. No value means `true`.
---
---
---
---@param loop boolean|nil
function m:set_loop(loop) end

---
---Sets the trajectory of this movement.
---
---Any previous trajectory is removed and the movement starts at the beginning of the new trajectory.
---
---  * trajectory (table): An array of all successive translations to make. Each translation should be an array of two integers (x and y).
---
---
---
---@param trajectory table
function m:set_trajectory(trajectory) end

---
---Sets the delay between two steps of the trajectory.
---
---  * `delay` (number): The delay between two steps in milliseconds.
---
---
---
---#  Events inherited from movement
---
---Pixel movements are particular [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@param delay number
function m:set_delay(delay) end

---
---Returns the delay between two steps of the trajectory.
---
---  * Return value (number): The delay between two steps in milliseconds.
---
---
---
---@return number
function m:get_delay() end

---
---Returns whether this movement restarts automatically when the trajectory is finished.
---
---  * Return value (boolean): `true` if the movement loops.
---
---
---
---@return boolean
function m:get_loop() end

_G.pixel_movement = m

return m