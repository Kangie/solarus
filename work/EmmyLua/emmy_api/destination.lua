---@class destination : entity
---
---A destination is a possible arrival place for [teletransporters](https://doxygen.solarus-games.org/latest/lua_api_teletransporter.html).
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_destination()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_destination).
---
local m = {}

---
---Called when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) arrives on this destination.
---
---The map opening transition is about to start at this point.
---
---He may come from a [teletransporter](https://doxygen.solarus-games.org/latest/lua_api_teletransporter.html), from [hero:teleport()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_teleport) or from the [saved starting location](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_starting_location). 
---
function m:on_activated() end

---
---Returns whether this destination updates the [starting location](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_starting_location) of the player when arriving on it. If yes, when the player restarts his game, he will restart at this destination. The default value is `"when_world_changes"`.
---
---  * Return value (string): The starting location mode. Can be one of:
---    * `"when_world_changes"`: Updates the starting location if the current [world](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_world) has just changed when arriving to this destination.
---    * `"yes"`: Updates the starting location.
---    * `"no"`: Does not update the starting location.
---
---
---
---@return string
function m:get_starting_location_mode() end

---
---Sets whether this destination updates the [starting location](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_starting_location) of the player when arriving on it. If yes, when the player restarts his game, he will restart at this destination. The default value is `"when world changes"`.
---
---  * `mode` (string): The starting location mode. Can be one of:
---    * `"when_world_changes"`: Updates the starting location if the current [world](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_world) has just changed when arriving to this destination.
---    * `"yes"`: Updates the starting location.
---    * `"no"`: Does not update the starting location.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Destinations are particular [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type destination
---
---The following events are specific to destinations.
---
---@param mode string
function m:set_starting_location_mode(mode) end

_G.destination = m

return m