---@class jump_movement : movement
---
---This type of movement makes a jump above a specified rectilinear trajectory. We call this rectilinear trajectory the baseline. To use a jump movement, you typically specify the baseline (direction and distance), and the movement will jump above this baseline. The speed is adjusted automatically depending on the distance, but you can change it if you want.
---
---For now, the baseline can only have one of the 8 main directions. This restriction may be removed in the future.
---
local m = {}

---
---Returns the distance of the baseline of this jump.
---
---  * Return value (number): The distance of the jump in pixels.
---
---
---
---@return number
function m:get_distance() end

---
---Returns the direction of the baseline of this jump. The baseline always has one of the 8 main directions. 0 is East, 1 is North-East, etc.
---
---  * Return value (number): The direction (`0` to `7`).
---
---
---
---@return number
function m:get_direction8() end

---
---Sets the speed of this movement.
---
---  * `speed` (number): The new speed in pixels per second. `0` means to set automatically a speed based on the distance of the jump.
---
---
---
---#  Events inherited from movement
---
---Jump movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@param speed number
function m:set_speed(speed) end

---
---Sets the distance of the baseline of this jump.
---
---  * `distance` (number): The new distance of the jump in pixels.
---
---
---
---@param distance number
function m:set_distance(distance) end

---
---Sets the direction of the baseline of this jump. The baseline always has one of the 8 main directions. 0 is East, 1 is North-East, etc.
---
---  * `direction8` (number): The direction (`0` to `7`).
---
---
---
---@param direction8 number
function m:set_direction8(direction8) end

---
---Returns the speed of this movement.
---
---  * Return value (number): The speed in pixels per second.
---
---
---
---@return number
function m:get_speed() end

_G.jump_movement = m

return m