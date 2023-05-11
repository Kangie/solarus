---@class dynamic_tile : entity
---
---Dynamic tiles are [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) that can be hidden, shown, created and deleted at runtime.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_dynamic_tile()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_dynamic_tile).
---
local m = {}

---
---Sets the tileset of this dynamic tile.
---
---  * `tileset_id` (string or nil): The tileset id, or `nil` to clear the tileset for the dynamic tile (in this case, the tileset of the map is used).
---
---
---
---@param tileset_id string|nil
function m:set_tileset(tileset_id) end

---
---Returns the id of the tile pattern of this dynamic tile.
---
---  * Return value (string): The tile pattern id in the tileset.
---
---
---
---@return string
function m:get_pattern_id() end

---
---Returns the id of the tileset of this dynamic tile.
---
---  * Return value (string or nil): The tileset id, or `nil` if no tileset is set for the dynamic tile (in this case, the tileset of the map is used).
---
---
---
---@return string|nil
function m:get_tileset() end

---
---Returns the ground defined by this dynamic tile on the map.
---
---The presence of a dynamic tile can modify the ground of the map. This is determined by the ground property of the tile pattern.
---
---  * Return value (string): The ground defined by this dynamic tile. `"empty"` means that this dynamic tile does not modify the ground of the map. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Dynamic tiles are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type dynamic tile
---
---None. 
---
---@return string
function m:get_modified_ground() end

_G.dynamic_tile = m

return m