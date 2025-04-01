---@class door : entity
---
---A door is an obstacle that can be opened by Lua, and optionally by the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) under some conditions.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_door()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_door).
---
local m = {}

---
---Returns whether this door is open.
---
---  * Return value (boolean): `true` if this door is open, `false` if it is opening, closed or closing.
---
---
---
---@return boolean
function m:is_open() end

---
---Returns whether this door is being closed.
---
---  * Return value (boolean): `true` if this door is being closed, `false` if it is closed, open or opening.
---
---
---
---@return boolean
function m:is_closing() end

---
---Called when this door starts being closed. 
---
function m:on_closed() end

---
---Called when this door starts being opened.
---
function m:on_opened() end

---
---Makes the door open or closed like [door:open()](https://doxygen.solarus-games.org/latest/lua_api_door.html#lua_api_door_open) or [door:close()](https://doxygen.solarus-games.org/latest/lua_api_door.html#lua_api_door_close), but does not play any sound or any sprite animation.
---
---This function is intended to be called when you don't want the player to notice the change, typically when your map starts (i.e. from the [map:on_started()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_on_started) event).
---
---  * `open` (boolean, optional): `true` to open the door, `false` to close it. No value means `true`.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Doors are particular [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type door
---
---The following events are specific to doors.
---
---@param open boolean|nil
function m:set_open(open) end

---
---Opens this door, enables [dynamic tiles](https://doxygen.solarus-games.org/latest/lua_api_dynamic_tile.html) whose name starts with the door's name followed by `_open` and plays the `"door_open"` [sound](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_sound).
---
---Remarks
---    The door will be really closed once the opening animation of its sprite is finished. However, it immediately becomes an obstacle.
---
function m:open() end

---
---Closes this door, disables [dynamic tiles](https://doxygen.solarus-games.org/latest/lua_api_dynamic_tile.html) whose name starts with the door's name followed by `_closed` and plays the `"door_closed"` [sound](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_sound).
---
function m:close() end

---
---Returns whether this door is being opened.
---
---  * Return value (boolean): `true` if this door is being opened, `false` if it is open, closed or closing.
---
---
---
---@return boolean
function m:is_opening() end

---
---Returns whether this door is closed.
---
---  * Return value (boolean): `true` if this door is closed, `false` if it is closing, open or opening.
---
---
---
---@return boolean
function m:is_closed() end

_G.door = m

return m