---@class chest : entity
---
---A chest is a box that contains a treasure.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_chest()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_chest).
---
local m = {}

---
---Sets the treasure the player will obtain when opening this chest.
---
---If the chest is already open, this function still works, it sets the treasure that will be put back in case you [close](http://www.solarus-games.org/doc/1.6/lua_api_chest.html#lua_api_chest_set_open) the chest later.
---
---  * `item_name` (string, optional): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` makes the chest empty.
---  * `variant` (number, optional): Variant of this equipment item (`1` means the first variant). The default value is `1`. Must be `nil` when `item_name` is `nil`.
---  * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the chest is open. `nil` means that the chest is not saved.
---
---
---
---Remarks
---    If the treasure is a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), the hero will actually get no treasure when opening the chest.
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Chests are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type chest
---
---The following events are specific to chests.
---
---@param item_name string|nil
---@param variant number|nil
---@param savegame_variable string|nil
function m:set_treasure(item_name,variant,savegame_variable) end

---
---Returns the state of this chest (open or closed).
---
---  * Return value (boolean): `true` if this chest is open, `false` if it is closed.
---
---
---
---@return boolean
function m:is_open() end

---
---Returns the treasure the player will obtain when opening this chest.
---
---If the chest is already open, this function still works: it returns the treasure that was inside the chest before it was open.
---
---  * Return value 1 (string): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` means that the chest is empty.
---  * Return value 2 (number): Variant of this equipment item (`1` means the first variant). `nil` means that the chest is empty.
---  * Return value 3 (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the chest is open. `nil` means that the chest is not saved.
---
---
---
---Remarks
---    If the treasure is a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), the hero will actually get no treasure when opening the chest.
---
---@return string,number,string
function m:get_treasure() end

---
---Sets the state of this chest (open or closed). If you close the chest, its treasure (as returned by [chest:get_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_chest.html#lua_api_chest_get_treasure)) is restored and can be obtained again later.
---
---  * `open` (boolean, optional): `true` to make the chest open, `false` to make it closed. No value means `true`.
---
---
---
---@param open boolean|nil
function m:set_open(open) end

---
---Called when the hero opens this chest.
---
---At this point, if the chest is saved, then the engine has already set the corresponding savegame value to `true` (`treasure_savegame_variable`), no matter if this event is defined.
---
---Then, if you don't define this event, by default, the engine gives the treasure to the player (if there is no treasure, then nothing else happens and the hero is automatically unfrozen).
---
---Your script can define this event to customize what happens. By calling [hero:start_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_treasure), you can either give the chest's treasure or a treasure decided dynamically. Or you can do something else: show a dialog, play a sound, close the chest again, etc.
---
---The hero is automatically frozen during the whole process of opening a chest. If you don't give him a treasure, then you have to unblock him explicitly by calling [hero:unfreeze()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_unfreeze) when you want to restore control to the player.
---
---  * `treasure_item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): Equipment item in the chest, or `nil` if the chest is empty or contains a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable).
---  * `treasure_variant` (number): Variant of the treasure or `nil` if the chest is empty or contains a [non-obtainable item](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable).
---  * `treasure_savegame_variable` (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this chest is open, or `nil` if this chest is not saved. 
---
---
---
---@param treasure_item item
---@param treasure_variant number
---@param treasure_savegame_variable string
function m:on_opened(treasure_item,treasure_variant,treasure_savegame_variable) end

_G.chest = m

return m