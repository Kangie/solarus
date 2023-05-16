---@class path_movement : movement
---
---A path movement follows a specified path on an 8*8 pixels grid, in an 8-direction system. A path is a succession of steps of 8 pixels in one of the 8 main directions. You can define each step of the path and make it repeated if you want.
---
local m = {}

---
---Sets whether this movement repeats itself once the end of the path is reached.
---
---  * `loop` (boolean, optional): `true` to make the path repeat itself. No value means `true`.
---
---
---
---@param loop boolean|nil
function m:set_loop(loop) end

---
---Sets whether this movement should automatically snap to the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) grid the [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) that it controls.
---
---The map grid is composed of squares of 8*8 pixels. All tiles are aligned to the grid. This property has no effect if there is no current map of if this movement is not attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html).
---
---  * `snap` (boolean, optional): `true` to make this movement automatically snap its map entity to the map grid. No value means `true`.
---
---
---
---@param snap boolean|nil
function m:set_snap_to_grid(snap) end

---
---Returns whether this movement automatically snaps to the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) grid the [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) that it controls.
---
---The map grid is composed of squares of 8*8 pixels. All tiles are aligned to the grid. This property has no effect if there is no current map of if this movement is not attached to a map entity.
---
---  * Return value (boolean): `true` if this movement automatically snaps its map entity to the map grid.
---
---
---
---@return boolean
function m:get_snap_to_grid() end

---
---Sets the path of this movement.
---
---  * `path` (table): The path as an array of integers. Each value is a number between 0 and 7 that represents a step (move of 8 pixels) in the path. 0 is East, 1 is North-East, etc.
---
---
---
---Example of use: 
---    
---    
---    -- Example of code from a map script.
---    -- Assume that there is an NPC called "scared_cat" on this map.
---    function scared_cat:on_interaction()
---      -- The hero is talking to me: run away!
---      sol.audio.play_sound("meow")
---      local movement = sol.movement.create("path")
---      -- This path is arbitrary, it's just an example (North and then West).
---      movement:set_path{2,2,2,2,2,2,4,4,4,4}
---      movement:set_speed(80)
---      self:start_movement(movement)
---    end
---    
---
---@param path table
function m:set_path(path) end

---
---Returns the angle of the current trajectory in radians.
---
---East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2`.
---
---  * Return value (number): The angle in radians.
---
---
---
---Remarks
---    If you prefer a value in a 4-direction system, see [movement:get_direction4()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_get_direction4).
---
---#  Events inherited from movement
---
---Path movements are particular [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@return number
function m:get_angle() end

---
---Returns the speed of this movement.
---
---  * Return value (number): The speed in pixels per second.
---
---
---
---@return number
function m:get_speed() end

---
---Sets the speed of this movement.
---
---  * `speed` (number): The new speed in pixels per second.
---
---
---
---@param speed number
function m:set_speed(speed) end

---
---Returns the path of this movement.
---
---  * Return value (table): The path as an array of integers. Each value is a number between 0 and 7 that represents a step (move of 8 pixels) in the path. 0 is East, 1 is North-East, etc.
---
---
---
---@return table
function m:get_path() end

---
---Returns whether this movement repeats itself once the end of the path is reached.
---
---  * Return value (boolean): `true` if the path repeats itself.
---
---
---
---@return boolean
function m:get_loop() end

_G.path_movement = m

return m