---@class destructible : entity
---
---A destructible object is an entity that can be cut or [lifted](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_weight) by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) and that may hide a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html).
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_destructible()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_destructible).
---
local m = {}

---
---Sets whether this object regenerates after a delay when it is destroyed.
---
---  * `can_regenerate` (boolean, optional): `true` to make the object able to regenerate. No value means `true`.
---
---
---
---@param can_regenerate boolean
function m:set_can_regenerate(can_regenerate) end

---
---Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) looks this destructible object, that is, when the player presses the action key but is not allowed to lift the object.
---
---By default, nothing happens in this case. You can for example show a dialog to give the player a hint like "This is too heavy".
---
---Remarks
---    If you want to do the same action for all destructible objects of your game, use the [metatable trick](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_metatable). Just define this event on the metatable of the destructible object type instead of each individual object, and it will be applied to all of them.
---
function m:on_looked() end

---
---Returns whether this object can be cut by the sword.
---
---  * Return value (boolean): `true` if this object can be cut by the sword.
---
---
---
---@return boolean
function m:get_can_be_cut() end

---
---Returns what [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) this object will drop when being lifted, when being cut or when exploding.
---
---  * Return value 1 (string): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` means no item (in this case, other return values are `nil` too).
---  * Return value 2 (number): Variant of this equipment item (`1` means the first variant).
---  * Return value 3 (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the treasure dropped is found. `nil` means that the treasure is not saved.
---
---
---
---@return string,number,string
function m:get_treasure() end

---
---Sets the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.
---
---  * `damage_on_enemies` (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.
---
---
---
---@param damage_on_enemies number
function m:set_damage_on_enemies(damage_on_enemies) end

---
---Returns the sound to be played when this object is cut or broken.
---
---  * Return value (string): Id of the destruction sound. `nil` means that no sound will be played.
---
---
---
---@return string
function m:get_destruction_sound() end

---
---Called when this destructible object is exploding.
---
---If [destructible:get_can_explode()](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html#lua_api_destructible_get_can_explode) is `true`, the destructible object explodes when there is an [explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html) nearby or when the hero lifts it, after a delay.
---
function m:on_exploded() end

---
---Sets the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) that this object will drop when being lifted, when being cut or when exploding.
---
---  * `item_name` (string, optional): Name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). `nil` or no value means no item.
---  * `variant` (number, optional): Variant of this equipment item (`1` means the first variant). The default value is `1`.
---  * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the treasure dropped is found. `nil` or no value means that the treasure is not saved.
---
---
---
---@param item_name string|nil
---@param variant number|nil
---@param savegame_variable string|nil
function m:set_treasure(item_name,variant,savegame_variable) end

---
---Returns whether this object regenerates after a delay when it is destroyed.
---
---  * Return value (boolean): `true` if this object can regenerate.
---
---
---
---@return boolean
function m:get_can_regenerate() end

---
---Returns whether this object explodes when it is hit or after a delay when it is lifted.
---
---  * Return value (boolean): `true` if this object can explode.
---
---
---
---@return boolean
function m:get_can_explode() end

---
---Returns the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.
---
---  * Return value (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.
---
---
---
---@return number
function m:get_damage_on_enemies() end

---
---Sets the sound to be played when this object is cut or broken.
---
---  * `destruction_sound_id` (string): Id of the destruction sound. `nil` means that no sound will be played.
---
---
---
---@param destruction_sound_id string
function m:set_destruction_sound(destruction_sound_id) end

---
---Sets whether this object explodes when it is hit or after a delay when it is lifted.
---
---  * `can_explode` (boolean, optional): `true` to make the object able to explode. No value means `true`.
---
---
---
---@param can_explode boolean
function m:set_can_explode(can_explode) end

---
---Called when the hero has just cut this destructible object.
---
function m:on_cut() end

---
---Called when this destructible object regenerates.
---
---If [destructible:get_can_regenerate()](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html#lua_api_destructible_get_can_regenerate) is `true`, the destructible object regenerates after a delay when it was lifted or exploded. 
---
function m:on_regenerating() end

---
---Returns the ground defined by this destructible object on the map.
---
---The presence of a destructible object can modify the ground of the map. The ground is usually `"wall"`, but it may sometimes be `"traversable"`, or for example `"grass"` to make the destructible object traversable too but with an additional grass sprite below the hero.
---
---  * Return value (string): The ground defined by this destructible object. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Destructible objects are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type destructible
---
---The following events are specific to destructible objects.
---
---@return string
function m:get_modified_ground() end

---
---Sets whether this object can be cut by the sword.
---
---  * `can_be_cut` (boolean, optional): `true` to allow the player to cut this object with the sword. No value means `true`.
---
---
---
---@param can_be_cut boolean
function m:set_can_be_cut(can_be_cut) end

_G.destructible = m

return m