---@class separator : entity
---
---Separators allow to visually separate different regions of a map like if there was several maps.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_separator()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_separator).
---
local m = {}

---
---Called when the camera has finished traversing this separator.
---
---The hero is now on the other side.
---
---  * `direction4` (number): Direction of the hero when traversing the separator, `beween` 0 (East) to `3` (South). 
---
---
---
---@param direction4 number
function m:on_activated(direction4) end

---
---Called when the camera starts traversing on this separator.
---
---  * `direction4` (number): Direction of the hero when traversing the separator, `beween` 0 (East) to `3` (South).
---
---
---
---@param direction4 number
function m:on_activating(direction4) end

_G.separator = m

return m