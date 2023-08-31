---@class random_path_movement : movement
---
---The random path movement is a particular case of [path movement](https://doxygen.solarus-games.org/latest/lua_api_path_movement.html), where the path is chosen automatically. The resulting movement is composed of repeated random steps in the four main directions only and with a length that is a multiple of 8 pixels.
---
---Remarks
---    This movement is a typical random walk movement. You will probably use it for [NPCs](https://doxygen.solarus-games.org/latest/lua_api_npc.html).
---
---Example of use: 
---    
---    
---    -- Example of code from a map script.
---    -- Assume that there is an NPC called "bob" on this map.
---    function sol.map:on_started()
---      -- The map has just started: make bob walk.
---      bob:start_movement(sol.movement.create("random_path"))
---    end
---    
---
local m = {}

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
---Returns the speed of this movement.
---
---  * Return value (number): The speed in pixels per second.
---
---
---
---@return number
function m:get_speed() end

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
---Random path movements are particular [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@return number
function m:get_angle() end

_G.random_path_movement = m

return m