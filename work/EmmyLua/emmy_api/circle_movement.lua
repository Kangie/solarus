---@class circle_movement : movement
---
---A circle movement makes a circular trajectory around a center point.
---
---The center can either be some fixed coordinates or a possibly moving [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html).
---
local m = {}

---
---Sets whether circles are made clockwise or counter-clockwise.
---
---  * `clockwise` (boolean, optional): `true` to make circles clockwise. No value means `true`.
---
---
---
---@param clockwise boolean|nil
function m:set_clockwise(clockwise) end

---
---Sets the maximum number of rotations of this movement.
---
---When this number of rotations is reached, the movement stops.
---
---  * `max_rotations` (number): The maximum number of rotations to make (`0` means infinite).
---
---
---
---Remarks
---    The movement stops itself by setting its radius to 0. Therefore, if the radius is set to change gradually (see [circle_movement:get_radius_speed()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed)), the movement will continue for a while until the radius reaches 0.
---     When the movement has stopped, it restarts later if it was set to loop (see [circle_movement:get_loop_delay()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_loop_delay)), and again, possibly gradually.
---
---@param max_rotations number
function m:set_max_rotations(max_rotations) end

---
---Sets the center of this movement as a fixed point or a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html).
---
---To make circles around a fixed point:
---
---  * `x` (number): X coordinate of the center.
---  * `y` (number): Y coordinate of the center.
---
---
---
---To make circles around a map entity (only during a [game](https://doxygen.solarus-games.org/latest/lua_api_game.html)):
---
---  * `entity` ([entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html)): The center entity.
---  * `dx` (number, optional): X offset to add to the center entity's coordinates (default 0).
---  * `dy` (number, optional): Y offset to add to the center entity's coordinates (default 0).
---
---
---
---@param x number
---@param y number
function m:set_center(x,y) end

---
---Sets the radius of circles to make.
---
---If [circle_movement:get_radius_speed()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed) is not 0, the radius will be updated gradually.
---
---  * `radius` (number): The new wanted radius in pixels.
---
---
---
---@param radius number
function m:set_radius(radius) end

---
---Returns the center point of this movement.
---
---  * Return value 1 (number): X coordinate of the center.
---  * Return value 2 (number): Y coordinate of the center.
---
---
---
---@return number|number
function m:get_center() end

---
---Sets the position on the circle as an angle from its center.
---
---This is the angle of the vector between the center and the new position to set.
---
---  * `initial_angle` (number): The angle in radians.
---
---
---
function m:set_angle_from_center() end

---
---Returns whether circles are made clockwise or counter-clockwise.
---
---  * Return value (boolean): `true` if circles are clockwise.
---
---
---
---@return boolean
function m:is_clockwise() end

---
---Sets the maximum duration of this movement.
---
---When this delay is reached, the movement stops.
---
---  * `duration` (number): The duration of the movement in milliseconds (`0` means infinite).
---
---
---
---Remarks
---    The movement is stopped by automatically setting its radius to 0. Therefore, if the radius is set to change gradually (see [circle_movement:get_radius_speed()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed)), the movement will continue for a while until the radius reaches 0.
---     When the movement has stopped, it will then restart if it was set to loop (see [circle_movement:set_loop_delay()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_set_loop_delay)), and again, possibly gradually.
---
---@param duration number
function m:set_duration(duration) end

---
---Returns the speed of radius changes.
---
---  * Return value (number): The speed in pixels per second, or 0 if radius changes are immediate.
---
---
---
---@return number
function m:get_radius_speed() end

---
---Sets the delay after which this movement restarts.
---
---  * `loop_delay` (number): The restart delay in milliseconds (`0` means no restart).
---
---
---
---Remarks
---    This delay is applied if the movement get stopped by reaching the [maximum number of rotations](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_max_rotations) or the [maximum duration](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_duration).
---     When the movement restarts, the radius starts from 0 and gets back to its previous value, possibly gradually (see [circle_movement:set_radius_speed()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_set_radius_speed)).
---
---#  Events inherited from movement
---
---Circle movements are particular [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_events) to know these events.
---
---#  Deprecated methods of the type circle movement
---
---The following methods are deprecated and may be removed it future releases.
---
---@param loop_delay number
function m:set_loop_delay(loop_delay) end

---
---Sets the speed of the angle variation.
---
---  * `angular_speed` (number): The new angle speed in radians per second.
---
---
---
---@param angular_speed number
function m:set_angular_speed(angular_speed) end

---
---Returns the delay after which this movement restarts.
---
---  * Return value (number): The restart delay in milliseconds (`0` means no restart).
---
---
---
---@return number
function m:get_loop_delay() end

---
---Returns the angle indicating the current position on the circle.
---
---This is the angle of the vector between the center and the current position.
---
---  * Return value (number): The angle in radians.
---
---
---
---@return number
function m:get_angle_from_center() end

---
---Returns the radius of circles to make.
---
---If [circle_movement:get_radius_speed()](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html#lua_api_circle_movement_get_radius_speed) is not 0, radius changes are made gradually.
---
---  * Return value (number): The wanted radius in pixels.
---
---
---
---@return number
function m:get_radius() end

---
---Returns the maximum number of rotations of this movement.
---
---When this number of rotations is reached, the movement stops.
---
---  * Return value (number): The maximum number of rotations to make (`0` means infinite).
---
---
---
---@return number
function m:get_max_rotations() end

---
---Returns the speed of the angle variation.
---
---  * Return value (number): The angle speed in radians per second.
---
---
---
---@return number
function m:get_angular_speed() end

---
---Returns the maximum duration of this movement.
---
---When this delay is reached, the movement stops.
---
---  * Return value (number): The duration of the movement in milliseconds (`0` means infinite).
---
---
---
---@return number
function m:get_duration() end

---
---Sets the radius to be updated immediately of gradually (at the specified speed) towards its wanted value.
---
---  * `radius_speed` (number): The speed of radius changes in pixels per second, or 0 to make radius changes immediate.
---
---
---
---@param radius_speed number
function m:set_radius_speed(radius_speed) end

_G.circle_movement = m

return m