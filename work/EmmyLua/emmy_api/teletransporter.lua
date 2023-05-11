---@class teletransporter : entity
---
---A teletransporter is a detector that sends the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) to another place when he walks on it.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_teletransporter()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_teletransporter).
---
local m = {}

---
---Sets the destination place on the destination map.
---
---  * `destination_name` (string): Location on the destination map. Can be the name of a [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) entity, the special value `"_same"` to keep the hero's coordinates, or the special value `"_side"` to place on hero on the corresponding side of an adjacent map (normally used with the scrolling transition style). `nil` means the default destination entity of the map.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Teletransporters are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type teletransporter
---
---The following events are specific to teletransporters.
---
---@param destination_name string
function m:set_destination_name(destination_name) end

---
---Sets the style of transition to play when the hero uses this teletransporter.
---
---  * `transition_style` (string): The transition style. Can be one of:
---    * `"immediate"`: No transition.
---    * `"fade"`: Fade-out and fade-in effect.
---    * `"scrolling"`: Scrolling between maps.
---
---
---
---@param transition_style string
function m:set_transition(transition_style) end

---
---Returns the sound to be played when the hero uses this teletransporter.
---
---  * Return value (string): Id of the teletransporter's sound. `nil` means that no sound will be played.
---
---
---
---@return string
function m:get_sound() end

---
---Returns the style of transition to play when the hero uses this teletransporter.
---
---  * Return value (string): The transition style. Can be one of:
---    * `"immediate"`: No transition.
---    * `"fade"`: Fade-out and fade-in effect.
---    * `"scrolling"`: Scrolling between maps.
---
---
---
---@return string
function m:get_transition() end

---
---Sets the sound to be played when the hero uses this teletransporter.
---
---  * `sound_id` (string): Id of the teletransporter's sound. `nil` means that no sound will be played.
---
---
---
---@param sound_id string
function m:set_sound(sound_id) end

---
---Sets the destination [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) of this teletransporter.
---
---  * `map_id` (string): Id of the destination map to set.
---
---
---
---@param map_id string
function m:set_destination_map(map_id) end

---
---Returns the name of the destination place on the destination map.
---
---  * Return value (string): Location on the destination map. Can be the name of a [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) entity, the special value `"_same"` to keep the hero's coordinates, or the special value `"_side"` to place on hero on the corresponding side of an adjacent map (normally used with the scrolling transition style). `nil` means the default destination entity of the map.
---
---
---
---@return string
function m:get_destination_name() end

---
---Called when the user takes this teletransporter, just before the map closing transition starts.
---
---Remarks
---    If you [disable](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled) or [remove](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_remove) the teletransporter during this event, then the teletransportation does not occur. 
---
function m:on_activated() end

---
---Returns the id of the destination [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) of this teletransporter.
---
---  * Return value (string): Id of the destination map.
---
---
---
---@return string
function m:get_destination_map() end

_G.teletransporter = m

return m