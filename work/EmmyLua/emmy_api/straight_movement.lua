---@class straight_movement : movement
---
---A straight movement follows a rectilinear trajectory. You can define the trajectory as an angle and a speed.
---
local m = {}

---
---Sets whether this movement should adjust its trajectory when an obstacle of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) or if the movement ignores obstacles.
---
---  * `smooth` (boolean, optional): `true` to make this movement smooth. No value means `true`.
---
---
---
---#  Events inherited from movement
---
---Straight movements are particular [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@param smooth boolean|nil
function m:set_smooth(smooth) end

---
---Returns whether this movement adjusts its trajectory when an obstacle of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) or if the movement ignores obstacles.
---
---  * Return value (boolean): `true` if this movement is smooth.
---
---
---
---@return boolean
function m:is_smooth() end

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
---Sets the angle of the trajectory in radians.
---
---East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible. Negative values and values greater to `2 * math.pi` are also accepted.
---
---  * `angle` (number): The new angle in radians.
---
---
---
---@param angle number
function m:set_angle(angle) end

---
---Sets the maximum distance of this movement.
---
---The movement will stop when this distance is reached.
---
---  * `max_distance` (number): The maximum distance in pixels (`0` means no limit).
---
---
---
---@param max_distance number
function m:set_max_distance(max_distance) end

---
---Returns the maximum distance of this movement.
---
---The movement will stop when this distance is reached.
---
---  * Return value (number): The maximum distance in pixels (`0` means no limit).
---
---
---
---@return number
function m:get_max_distance() end

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
---Returns the angle of the trajectory in radians.
---
---East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible.
---
---  * Return value (number): The angle in radians.
---
---
---
---Remarks
---    If you prefer a value in a 4-direction system, see [movement:get_direction4()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_get_direction4).
---
---@return number
function m:get_angle() end

_G.straight_movement = m

return m