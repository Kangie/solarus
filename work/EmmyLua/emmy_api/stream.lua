---@class stream : entity
---
---When walking on a stream, the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) automatically moves into one of the eight main directions.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_stream()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_stream).
---
local m = {}

---
---Returns the direction of this stream.
---
---This direction will be applied to entities that follow the stream.
---
---  * Return value (number): The direction between `0` (East) and `7` (South-East).
---
---
---
---@return number
function m:get_direction() end

---
---Returns whether the player can still use equipment items while being on this stream.
---
---  * Return value (boolean): `true` if the player can still use equipment itens.
---
---
---
---@return boolean
function m:get_allow_item() end

---
---Sets the direction of this stream.
---
---This direction will be applied to entities that follow the stream.
---
---  * `direction` (number): The direction to set, between `0` (East) and `7` (South-East).
---
---
---
---@param direction number
function m:set_direction(direction) end

---
---Sets whether the player can still use equipment items while being on this stream.
---
---  * `allow_item` (boolean): `true` to allow the player to use equipment items. No value means `true`.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Streams are particular [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type stream
---
---None. 
---
---@param allow_item boolean
function m:set_allow_item(allow_item) end

---
---Returns whether the player can still use the sword while being on this stream.
---
---  * Return value (boolean): `true` if the player use his sword.
---
---
---
---@return boolean
function m:get_allow_attack() end

---
---Sets whether the player can still move the hero while being on this stream.
---
---  * `allow_movement` (boolean): `true` to allow the player to move, `false` to make a blocking stream. No value means `true`.
---
---
---
---@param allow_movement boolean
function m:set_allow_movement(allow_movement) end

---
---Returns the speed applied by this stream.
---
---  * Return value (number): The speed of the stream in pixels per second.
---
---
---
---@return number
function m:get_speed() end

---
---Sets whether the player can still use the sword while being on this stream.
---
---  * `allow_attack` (boolean): `true` to allow the player to use the sword. No value means `true`.
---
---
---
---@param allow_attack boolean
function m:set_allow_attack(allow_attack) end

---
---Returns whether the player can still move the hero while being on this stream.
---
---  * Return value (boolean): `true` if the player can still move, `false` if this is a blocking stream.
---
---
---
---@return boolean
function m:get_allow_movement() end

---
---Sets the speed applied by this stream.
---
---  * `speed` (number): The speed to set in pixels per second. The default value is `40`.
---
---
---
---@param speed number
function m:set_speed(speed) end

_G.stream = m

return m