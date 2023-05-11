---@class random_movement : movement
---
---This type of movement is a rectilinear movement whose trajectory changes randomly over time. It can be seen as a particular case of the [straight movement](http://www.solarus-games.org/doc/1.6/lua_api_straight_movement.html) type, where the angle is automatically changed after random delays.
---
local m = {}

---
---Returns whether this movement adjusts its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.
---
---  * Return value (boolean): `true` if this movement is smooth.
---
---
---
---@return boolean
function m:is_smooth() end

---
---Returns the maximum distance of this movement.
---
---If the movement goes further than this distance, it automatically comes back towards the initial position.
---
---  * Return value (number): The maximum distance in pixels (`0` means no limit).
---
---
---
---@return number
function m:get_max_distance() end

---
---Sets whether this movement should adjust its trajectory when an obstacle of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) or if the movement ignores obstacles.
---
---  * `smooth` (boolean, optional): `true` to make this movement smooth. No value means `true`.
---
---
---
---#  Events inherited from movement
---
---Random movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@param smooth boolean|nil
function m:set_smooth(smooth) end

---
---Sets the speed applied to this movement when it is started.
---
---  * `speed` (number): The new speed in pixels per second.
---
---
---
---@param speed number
function m:set_speed(speed) end

---
---Sets the maximum distance of this movement.
---
---If the movement goes further than this distance, it automatically comes back towards the initial position.
---
---  * `max_distance` (number): The maximum distance in pixels (`0` means no limit).
---
---
---
---@param max_distance number
function m:set_max_distance(max_distance) end

---
---Returns the angle of the current trajectory in radians.
---
---East is `0`, North is `math.pi / 2`, West is `math.pi`, South is `3 * math.pi / 2` and any intermediate value is possible.
---
---  * Return value (number): The angle in radians.
---
---
---
---Remarks
---    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).
---
---@return number
function m:get_angle() end

---
---Returns the speed applied to this movement when it is started.
---
---  * Return value (number): The speed in pixels per second.
---
---
---
---@return number
function m:get_speed() end

_G.random_movement = m

return m