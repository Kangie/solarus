---@class target_movement : movement
---
---A target movement goes towards a target point. The target point can be a fixed point of an [entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html). If the target is a moving map entity, the movement updates its angle to continue to go towards the entity. By default, the target is the [hero](https://doxygen.solarus-games.org/latest/lua_api_entity.html) when a [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is running.
---
---This type of movement can be seen as a particular case of the [straight movement](https://doxygen.solarus-games.org/latest/lua_api_straight_movement.html#lua_api_straight_movement_methods) type, where the angle is set automatically to go towards the target.
---
---Remarks
---    This type of movement goes straight towards the target. If you set the `smooth` property to `true`, it will try to avoid simple obstacles by moving to a side. This is usually enough for simple enemies that target the hero. If you want a more complex technique that calculates an intelligent path to the target, see the [path finding movement](https://doxygen.solarus-games.org/latest/lua_api_path_finding_movement.html) type.
---
local m = {}

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
---Sets whether this movement should adjust its trajectory when an obstacle of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) is reached. This property has no effect if the movement is not attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) or if the movement ignores obstacles.
---
---  * `smooth` (boolean, optional): `true` to make this movement smooth. No value means `true`.
---
---
---
---#  Events inherited from movement
---
---Target movements are particular [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@param smooth boolean|nil
function m:set_smooth(smooth) end

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
---Sets the target of this movement as a fixed point or a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html).
---
---To target a fixed point:
---
---  * `x` (number): X coordinate of the target.
---  * `y` (number): Y coordinate of the target.
---
---
---
---To target a map entity (only during a [game](https://doxygen.solarus-games.org/latest/lua_api_game.html)):
---
---  * `entity` ([entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html)): The entity to target.
---  * `x` (number, optional): X offset to add to the target entity's coordinates. Default is `0`.
---  * `y` (number, optional): Y offset to add to the target entity's coordinates. Default is `0`.
---
---
---
---@param x number
---@param y number
function m:set_target(x,y) end

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

_G.target_movement = m

return m