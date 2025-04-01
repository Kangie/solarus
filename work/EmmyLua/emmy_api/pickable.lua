---@class pickable : entity
---
---A pickable treasure is a treasure on the ground and that the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) can pick up.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_pickable()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_pickable).
---
---Pickable treasures may also be dropped by [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) and by [destructible entities](https://doxygen.solarus-games.org/latest/lua_api_destructible.html).
---
local m = {}

---
---Returns the [entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) (if any) followed by this pickable treasure.
---
---Pickable treasures get automatically attached to entities like the boomerang or the hookshot when such entities collide with them. You can use this function to know if it happens.
---
---  * Return value ([map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html)): The entity this pickable treasure is attached to, or `nil` if the pickable treasure is free.
---
---
---
---@return entity
function m:get_followed_entity() end

---
---Returns whether this pickable treasure can detect collisions with entities even if they are not on the same layer.
---
---By default, pickable treasures can only have collisions with entities on the same layer.
---
---  * Return value (boolean): `true` if this pickable treasure can detect collisions even with entities on other layers.
---
---
---
---@return boolean
function m:has_layer_independent_collisions() end

---
---Returns the kind of treasure represented by this pickable treasure.
---
---  * Return value 1 ([item](https://doxygen.solarus-games.org/latest/lua_api_item.html)): The equipment item of this treasure.
---  * Return value 2 (number): Variant of this equipment item (`1` means the first variant).
---  * Return value 3 (string): Name of the boolean value that stores in the [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) whether this pickable treasure is found. `nil` means that the treasure is not saved.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Pickable treasures are particular [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type pickable
---
---None. 
---
---@return item|number|string
function m:get_treasure() end

---
---Indicates how high this pickable treasure falls from.
---
---This depends on how the pickable treasure was created. If is was placed on the map initially, it does not fall at all (`0` is returned). If it appears when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) lifts a [destructible object](https://doxygen.solarus-games.org/latest/lua_api_destructible.html), it falls from a low height. If it is dropped by an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html), it falls from higher.
---
---By default, the engine sets a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) that makes the pickable treasure bounce of a few pixels over the ground during a fraction of second. The number of pixels, the duration and the number of bounces of the movement depends on this height. If you want to override that movement, (by calling [movement:start(pickable)](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_start)), you may also want to make it dependent of the falling height.
---
---  * Return value (number): An integer indicating how high the pickable treasure falls from at creation time, between `0` (not falling at all) and `3` (falling from some high place).
---
---
---
---@return number
function m:get_falling_height() end

---
---Sets whether this pickable treasure can detect collisions with entities even if they are not on the same layer.
---
---By default, pickable treasures can only have collisions with entities on the same layer. For example, you can call this method if your pickable treasure is a flying object that should be able to be picked by the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) no matter his current layer.
---
---  * `independent` (boolean, optional): `true` to make this pickable treasure detect collisions even with entities on other layers. No value means `true`.
---
---
---
---@param independent boolean|nil
function m:set_layer_independent_collisions(independent) end

_G.pickable = m

return m