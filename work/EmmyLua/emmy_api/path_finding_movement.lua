---@class path_finding_movement : movement
---
---A path finding movement is a particular [path movement](http://www.solarus-games.org/doc/1.6/lua_api_path_movement.html) where the path is calculated to reach a target. The target is a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (by default the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)). The movement calculates repeatedly the shortest path towards the target entity, taking into account obstacles of the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html). With this type of movement, an entity is capable of finding its way in a maze.
---
---Remarks
---    This type of movement computes a precise path on the map grid and avoids complex obstacles by using a sophisticated A.I. algorithm ([A*](http://en.wikipedia.org/wiki/A*)). If you just need to go straight towards a target, which may be more natural for basic enemies, see the [target movement](http://www.solarus-games.org/doc/1.6/lua_api_target_movement.html) type.
---
local m = {}

---
---Sets the target entity of this movement.
---
---  * `entity` ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The entity to target.
---
---
---
---@param entity entity
function m:set_target(entity) end

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
---    If you prefer a value in a 4-direction system, see [movement:get_direction4()](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_get_direction4).
---
---#  Events inherited from movement
---
---Path finding movements are particular [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) objects. Therefore, they inherit all events from the type movement.
---
---See [Events of all movement types](http://www.solarus-games.org/doc/1.6/lua_api_movement.html#lua_api_movement_events) to know these events. 
---
---@return number
function m:get_angle() end

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

_G.path_finding_movement = m

return m