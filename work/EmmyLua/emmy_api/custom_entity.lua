---@class custom_entity : entity
---
---A custom entity is a map entity entirely defined by your Lua scripts.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_custom_entity()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_custom_entity).
---
local m = {}

---
---Sets whether this custom entity should follow [streams](https://doxygen.solarus-games.org/latest/lua_api_stream.html).
---
---By default, custom entities are not affected by streams and ignore them.
---
---  * `follow_streams` (boolean, optional): `true` to make this custom entity follow streams, `false` to ignore them. No value means `true`.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Custom entities are particular [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type custom entity
---
---The following events are specific to custom entities.
---
---@param follow_streams boolean|nil
function m:set_follow_streams(follow_streams) end

---
---Returns the direction of this custom entity.
---
---This direction is set at creation time or when you can call [custom_entity:set_direction()](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html#lua_api_custom_entity_set_direction).
---
---  * Return value 1 (number): The direction.
---
---
---
---@return number
function m:get_direction() end

---
---Sets whether this custom entity can be traversed by other entities.
---
---By default, a custom entity can be traversed.
---
---  * `entity_type` (string, optional): A type of entity. See [entity:get_type()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_type) for the possible values. If not specified, the setting will be applied to all entity types that do not override it.
---  * `traversable` (boolean, function or `nil`): Whether this entity type can traverse your custom entity. This can be:
---    * A boolean: `true` to make your custom entity traversable by this entity type, `false` to make it obstacle.
---    * A function: Custom test. This allows you to decide dynamically. The function takes your custom entity and then the other entity as parameters, and should return `true` if you allow the other entity to traverse your custom entity. This function will be called every time a [moving](https://doxygen.solarus-games.org/latest/lua_api_movement.html) entity of the specified type is about to overlap your custom entity.
---    * `nil:` Clears any previous setting for this entity type and therefore restores the default value.
---
---
---
---@param entity_type string|nil
---@param traversable boolean|function|nil
function m:set_traversable_by(entity_type,traversable) end

---
---Returns whether this custom entity can detect collisions with entities even if they are not on the same layer.
---
---By default, custom entities can only have collisions with entities on the same layer.
---
---  * Return value (boolean): `true` if this entity can detect collisions even with entities on other layers.
---
---
---
---@return boolean
function m:has_layer_independent_collisions() end

---
---Returns the model of this custom entity.
---
---The model is the name of a Lua script in the `"entities"` directory that manages this custom entity. This works exactly like the breed of [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html), except that it is optional.
---
---  * Return value (string): The model of custom entity, or `nil` if the custom entity has no model script.
---
---
---
---@return string
function m:get_model() end

---
---Sets whether this custom entity can detect collisions with entities even if they are not on the same layer.
---
---By default, custom entities can only have collisions with entities on the same layer. If you set this property to `true`, the [collision tests](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test) will be performed even with entities that are on a different layer.
---
---  * `independent` (boolean, optional): `true` to make this entity detect collisions even with entities on other layers. No value means `true`.
---
---
---
---@param independent boolean|nil
function m:set_layer_independent_collisions(independent) end

---
---Sets whether the sprite should be repeated with tiling to fit the size of the custom entity when the size is bigger than the sprite.
---
---  * `tiled` (boolean, optional): `true` to make the sprite tiled. No value means `true`.
---
---
---
---@param tiled boolean|nil
function m:set_tiled(tiled) end

---
---Registers a function to be called when your custom entity detects a collision when another entity.
---
---  * `collision_mode` (string or function): Specifies what kind of collision you want to test. This may be one of:
---    * `"overlapping"`: Collision if the [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box) of both entities overlap. This is often used when the other entity can traverse your custom entity.
---    * `"containing"`: Collision if the bounding box of the other entity is fully inside the bounding box of your custom entity.
---    * `"origin"`: Collision if the [origin point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) or the other entity is inside the bounding box of your custom entity.
---    * `"center"`: Collision if the [center point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_center_position) of the other entity is inside the bounding box of your custom entity.
---    * `"facing"`: Collision if the [facing position](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_facing_position) of the other entity's bounding box is touching your custom entity's bounding box. Bounding boxes don't necessarily overlap, but they are in contact: there is no space between them. When you consider the bounding box of an entity, which is a rectangle with four sides, the facing point is the middle point of the side the entity is oriented to. This `"facing"` collision test is useful when the other entity cannot traverse your custom entity. For instance, if the other entity has direction "east", there is a collision if the middle of the east side of its bounding box touches (but does not necessarily overlap) your custom entity's bounding box. This is very often what you need, typically to let the hero interact with your entity when he is looking at it.
---    * `"touching"`: Like `"facing"`, but accepts all four sides of the other entity's bounding box, no matter its direction.
---    * `"sprite"`: Collision if a sprite of the other entity overlaps a sprite of your custom entity. The collision test is pixel precise.
---    * A function: Custom collision test. The function takes your custom entity and then the other entity as parameters and should return `true` if there is a collision between them. This function will be called every time the engine needs to check collisions between your custom entity and any other entity.
---  * `callback` (function): A function that will be called when the collision test detects a collision with another entity. This allows you to decide dynamically. This function takes your custom entity and then the other entity as parameters. If the collision test was `"sprite"`, both involved sprites are also passed as third and fourth parameters: the third parameter is the sprite of your custom entity, and the fourth parameter is the sprite of the other entity. This may be useful when your entities have several sprites, otherwise you can just ignore these additional sprite parameters.
---
---
---
---Remarks
---    See also [entity:overlaps()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_overlaps_entity) to directly test a collision rather than registering a callback.
---
---@param collision_mode string|function
---@param callback function
function m:add_collision_test(collision_mode,callback) end

---
---Returns the kind of [ground](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) (terrain) defined by this custom entity on the map.
---
---  * Return value (string): The ground defined by this custom entity, or `nil` if this custom entity does not modify the ground. See [map:get_ground()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.
---
---
---
---@return string
function m:get_modified_ground() end

---
---Disables any collision test previously registered with [custom_entity:add_collision_test()](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test).
---
function m:clear_collision_tests() end

---
---Sets the direction of this custom entity.
---
---Sprites of your custom entity that have such a direction automatically take it.
---
---  * Return value 1 (number): The direction.
---
---
---
---@return number
function m:set_direction() end

---
---Called at each cycle while this custom entity lives on the map.
---
---Remarks
---    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) and other events.
---
function m:on_update() end

---
---Called when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) uses any [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html) (the player pressed an [item command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)) while facing this custom entity.
---
---  * `item_used` ([item](https://doxygen.solarus-games.org/latest/lua_api_item.html)): The item currently used by the player.
---  * Return value (boolean): `true` if an interaction happened. If you return `false` or nothing, then [item_used:on_using()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_on_using) will be called (just like if there was no custom entity in front of the hero).
---
---
---
---Remarks
---    This event is also available with [NPCs](https://doxygen.solarus-games.org/latest/lua_api_npc.html#lua_api_npc_on_interaction_item). 
---
---@param item_used item
---@return boolean
function m:on_interaction_item(item_used) end

---
---Called when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) interacts with this custom entity, that is, when the player presses the [action command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) while facing this custom entity.
---
---Remarks
---    This event is also available with [NPCs](https://doxygen.solarus-games.org/latest/lua_api_npc.html#lua_api_npc_on_interaction).
---
function m:on_interaction() end

---
---Called when the kind of [ground](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) on the map below this custom entity has changed. It may change because this custom entity is moving, or when because another entity changes it.
---
---  * `ground_below` (string): The kind of ground at the [ground point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_ground_position) of this custom entity. `nil` means empty, that is, there is no ground at this point on the current layer.
---
---
---
---@param ground_below string
function m:on_ground_below_changed(ground_below) end

---
---Sets whether this custom entity can traverse other entities.
---
---This is important only if your custom entity can [move](https://doxygen.solarus-games.org/latest/lua_api_movement.html).
---
---By default, this depends on the other entities: for example, [sensors](https://doxygen.solarus-games.org/latest/lua_api_sensor.html) can be traversed by default while [doors](https://doxygen.solarus-games.org/latest/lua_api_door.html) cannot unless they are open.
---
---  * `entity_type` (string, optional): A type of entity. See [entity:get_type()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_type) for the possible values. If not specified, the setting will be applied to all entity types for which you don't override this setting.
---  * `traversable` (boolean, function or `nil`): Whether your custom entity can traverse the other entity type. This can be:
---    * A boolean: `true` to allow your custom entity to traverse entities of the specified type, `false` otherwise.
---    * A function: Custom test. This allows you to decide dynamically. The function takes your custom entity and then the other entity as parameters, and should return `true` if you allow your custom entity to traverse the other entity. When your custom entity has a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html), this function will be called every time it is about to overlap an entity of the specified type.
---    * `nil:` Clears any previous setting for this entity type and therefore restores the default value.
---
---
---
---@param entity_type string|nil
---@param traversable boolean|function|nil
function m:set_can_traverse(entity_type,traversable) end

---
---Returns whether this custom entity can traverse a kind of ground.
---
---This is important only if your custom entity can [move](https://doxygen.solarus-games.org/latest/lua_api_movement.html).
---
---The [ground](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) is the terrain property of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html). It is defined by [tiles](https://doxygen.solarus-games.org/latest/lua_api_tile.html) and by other entities that may change it dynamically.
---
---  * `ground` (string): A kind of ground. See [map:get_ground()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) for the possible values.
---  * Return value (boolean): `true` if your custom entity can traverse this kind of ground.
---
---
---
---@param ground string
---@return boolean
function m:can_traverse_ground(ground) end

---
---Returns whether this custom entity follows [streams](https://doxygen.solarus-games.org/latest/lua_api_stream.html).
---
---By default, custom entities are not affected by streams and ignore them.
---
---  * Return value (boolean): `true` if this custom entity follows streams, `false` if it ignores them.
---
---
---
---@return boolean
function m:get_follow_streams() end

---
---Sets whether this custom entity can traverse a kind of ground.
---
---This is important only if your custom entity can [move](https://doxygen.solarus-games.org/latest/lua_api_movement.html).
---
---The [ground](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) is the terrain property of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html). It is defined by [tiles](https://doxygen.solarus-games.org/latest/lua_api_tile.html) and by other entities that may change it dynamically.
---
---By default, this depends on the the ground: for example, the `"grass"` ground can be traversed by default while the `"low wall"` ground cannot.
---
---  * `ground` (string): A kind of ground. See [map:get_ground()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) for the possible values.
---  * `traversable` (boolean): Whether your custom entity can traverse this kind of ground.
---
---
---
---@param ground string
---@param traversable boolean
function m:set_can_traverse_ground(ground,traversable) end

---
---Sets the kind of [ground](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) (terrain) defined by this custom entity on the map.
---
---The ground of the map is normally defined by tiles, but other entities may modify it dynamically.
---
---This property allows you to make a custom entity that modifies the ground of the map, for example a hole with a special sprite or ice with particular [collision callbacks](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test). The modified ground will be applied on the map in the rectangle of this custom entity's [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box). Your custom entity can move: the ground will still be correctly applied.
---
---  * `modified_ground` (string): The ground defined by this custom entity, or `nil` (or `"empty"`) to make this custom entity stop modifying the ground. See [map:get_ground()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.
---
---
---
---Remarks
---    If you only need to modify the ground of the map dynamically, for example to make a moving platform over holes, a [dynamic tile](https://doxygen.solarus-games.org/latest/lua_api_dynamic_tile.html) with a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) may be enough.
---
---@param modified_ground string
function m:set_modified_ground(modified_ground) end

---
---Returns whether the sprite is repeated with tiling to fit the size of the custom entity when the size is bigger than the sprite.
---
---  * Return value (boolean): `true` if the sprite is tiled.
---
---
---
---@return boolean
function m:is_tiled() end

_G.custom_entity = m

return m