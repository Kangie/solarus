---@class stairs : entity
---
---Stairs make fancy animations, movements and sounds when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) takes them.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_stairs()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_stairs).
---
---Remarks
---    Stairs entities provide very specific behavior for historical reasons and are not very customizable. If you need more flexibility, we recommend to use [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) instead and to script the behavior you want.
---
local m = {}

---
---Returns the direction of these stairs.
---
---Stairs can be taken in two opposite directions. The one returned here is the main one, which is: for stairs that teleport the hero, the direction when leaving the place using the stairs (and not the one when arriving from the stairs), and for inner stairs, the direction when going upwards.
---
---  * Return value (number): The stairs direction between `0` (East) and `3` (South).
---
---
---
---@return number
function m:get_direction() end

---
---Returns whether these stairs go from a layer to another layer on the same map or go to another place.
---
---  * Return value (number): The direction between `0` (East) and `3` (South).
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Stairs are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type stairs
---
---None. 
---
---@return number
function m:is_inner() end

_G.stairs = m

return m