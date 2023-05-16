---@class entity
---
---Objects placed on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) are called map entities (or just entities).
---
---There exists many types of entities. They can be either declared in the [map data file](https://doxygen.solarus-games.org/latest/quest_map_data_file.html), or created dynamically by using the `map:create_*` methods of the [map API](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
local m = {}

---
---Like [entity:get_angle()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_angle), but instead of an angle in radians, returns the closest direction among the 8 main directions.
---
---This is a utility function that essentially rounds the result of [entity:get_angle()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_angle).
---
---To compute the direction to a specified point:
---
---  * `x` (number): X coordinate of the point.
---  * `y` (number): Y coordinate of the point.
---  * Return value (number): The direction this entity should take to look at this point, between 0 (East) and 7 (South-East).
---
---
---
---To compute the direction to another map entity:
---
---  * `other_entity` (entity): An entity to target.
---  * Return value (number): The direction this entity should take to look at the other entity, between 0 (East) and 7 (South-East).
---
---
---
---@param x number
---@param y number
---@return number|number
function m:get_direction8_to(x,y) end

---
---Enables or disables this entity.
---
---When an entity is disabled, it is not displayed on the map, it does not move and does not detect collisions. Its [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html), its [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) and its [timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) if any are suspended and will be resumed when the entity gets enabled again. While the entity is disabled, it still exists, it still has a position and it can be enabled again later.
---
---  * `enabled` (boolean, optional): `true` to enable the entity, `false` to disable it. No value means `true`.
---
---
---
---@param enabled boolean|nil
function m:set_enabled(enabled) end

---
---Returns the entity this entity is looking at, if any.
---
---This is an entity overlapping the [facing position](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_facing_position) of this entity. If several entities are overlapping the facing position, the first one in Z order is returned.
---
---  * Return value (entity): The facing entity, or `nil` if there is no entity in front of this entity.
---
---
---
---@return entity
function m:get_facing_entity() end

---
---Returns the coordinates of the point used for ground detection for this entity on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
---The ground position is the point tested by all features related to the ground, like all effects of various grounds on the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html), the result of [entity:get_ground_below()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_ground_below) and the event [custom_entity:on_ground_below_changed()](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html#lua_api_custom_entity_on_ground_below_changed).
---
---  * Return value 1 (number): X coordinate of the ground point of this entity, relative to the upper left corner of the map.
---  * Return value 2 (number): Y coordinate of the ground point of this entity, relative to the upper left corner of the map.
---  * Return value 3 (number): Layer of the entity.
---
---
---
---Remarks
---    The ground point of an entity is slightly (2 pixels) above its origin point as returned by [entity:get_position()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_position).
---
---@return number|number|number
function m:get_ground_position() end

---
---Places this entity in front of all other entities on the same layer.
---
---Since entities that are on the same layer can overlap, you can use this function to change their Z order.
---
---Remarks
---    Some entities can have have the property to be [drawn in Y order](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_is_drawn_in_y_order) rather than in Z order. This function only has an effect on entities drawn in Z order.
---
function m:bring_to_front() end

---
---Returns whether this entity is in the same region as another one.
---
---Regions of the map are defined by the position of [separators](https://doxygen.solarus-games.org/latest/lua_api_separator.html) and map limits. The region of an entity is the one of its center point.
---
---Regions should be rectangular. Non-convex regions, for example with an "L" shape, are not supported by this function.
---
---You can use this function to make sure that an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) close to the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) but in the other side of a separator won't attack him.
---
---  * `other_entity` (entity): Another entity.
---  * Return value (boolean): `true` if both entities are in the same region.
---
---
---
---@param other_entity entity
---@return boolean
function m:is_in_same_region(other_entity) end

---
---Removes this entity from the map and destroys it.
---
---After the entity is destroyed, [entity:exists()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_exists) returns `false` and there is no reason to keep a reference to it in the Lua side (though it is harmless).
---
function m:remove() end

---
---Returns the current movement of this map entity.
---
---  * Return value ([movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html)): The current movement, or `nil` if the entity has currently no movement.
---
---
---
---Note
---    Even when the entity is not moving, it can still have a movement of speed `0`.
---
---@return movement
function m:get_movement() end

---
---Changes instantly the position of this entity on the map (coordinates and layer). The [origin point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) of the entity gets placed at these coordinates, relative to the map's upper left corner. Any previous movement or other action performed by the entity continues normally.
---
---  * `x` (number): X coordinate to set.
---  * `y` (number): Y coordinate to set.
---  * `layer` (number, optional): Layer to set, between [map:get_min_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_max_layer). By default, the layer is unchanged.
---
---
---
---Remarks
---    Be careful: this function does not check collisions with obstacles.
---
---@param x number
---@param y number
---@param lay number|nil
function m:set_position(x,y,lay) end

---
---Called when this entity has just been created on the map.
---
function m:on_created() end

---
---Returns the angle between the X axis and the vector that joins this entity to a point.
---
---To compute the angle to a specified point:
---
---  * `x` (number): X coordinate of the point.
---  * `y` (number): Y coordinate of the point.
---  * Return value (number): The angle in radians between the origin point of this entity and the specified point. The angle is between `0` and `2 * math.pi`.
---
---
---
---To compute the angle to another map entity:
---
---  * `other_entity` (entity): The entity to compute the angle to.
---  * Return value (number): The angle in radians between the origin point of this entity and the origin point of the other entity. The angle is between `0` and `2 * math.pi`.
---
---
---
---@param x number
---@param y number
---@return number|number
function m:get_angle(x,y) end

---
---Returns the map's ground below this entity.
---
---The ground is defined by the topmost [tile](https://doxygen.solarus-games.org/latest/lua_api_tile.html) below this entity, plus potential dynamic entities that may affect the ground, like [dynamic tiles](https://doxygen.solarus-games.org/latest/lua_api_dynamic_tile.html), [destructibles](https://doxygen.solarus-games.org/latest/lua_api_destructible.html) and [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html).
---
---The exact point tested is the one returned by [entity:get_ground_position()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_ground_position), and it is slightly different from [entity:get_position()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_position).
---
---  * Return value (string): The ground below this entity. See [map:get_ground()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_ground) for the list of possible grounds.
---
---
---
---@return string
function m:get_ground_below() end

---
---Removes and destroys a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of this entity.
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html), optional): The sprite to remove. The default value is the first sprite that was created.
---
---
---
---@param sprite sprite|nil
function m:remove_sprite(sprite) end

---
---Returns the type of entity.
---
---  * Return value (string): The type of this entity. Can be one of: `"hero"`, `"dynamic_tile"`, `"teletransporter"`, `"destination"`, `"pickable"`, `"destructible"`, `"carried_object"`, `"chest"`, `"shop_treasure"`, `"enemy"`, `"npc"`, `"block"`, `"jumper"`, `"switch"`, `"sensor"`, `"separator"`, `"wall"`, `"crystal"`, `"crystal_block"`, `"stream"`, `"door"`, `"stairs"`, `"bomb"`, `"explosion"`, `"fire"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"custom_entity"`.
---
---
---
---Remarks
---    The type `"tile"` is not is this list because [tiles](https://doxygen.solarus-games.org/latest/lua_api_tile.html) don't exist at runtime for optimization reasons.
---
---@return string
function m:get_type() end

---
---Creates a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) for this entity.
---
---  * `animation_set_id` (string): Animation set to use for the sprite.
---  * `sprite_name` (string, optional): An optional name to identify the created sprite. Only useful for entities with multiple sprites (see [entity:get_sprite()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_sprite)).
---  * Return value ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The sprite created.
---
---
---
---@param animation_set_id string
---@param sprite_name string|nil
---@return sprite
function m:create_sprite(animation_set_id,sprite_name) end

---
---Returns the coordinates of the center point of this entity on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
---  * Return value 1 (number): X coordinate of the center of this entity's bounding box, relative to the upper left corner of the map.
---  * Return value 2 (number): Y coordinate of the center of this entity's bounding box, relative to the upper left corner of the map.
---  * Return value 3 (number): Layer of the entity.
---
---
---
---@return number|number|number
function m:get_center_position() end

---
---Returns the optimization threshold hint of this map entity.
---
---Above this distance from the camera, the engine may decide to skip updates or drawings. This is only a hint: the engine is responsible of the final decision. A value of `0` means an infinite distance (the entity is never optimized away).
---
---  * Return value (number): The optimization distance hint in pixels.
---
---
---
---@return number
function m:get_optimization_distance() end

---
---Returns the map this entity belongs to.
---
---  * Return value ([map](https://doxygen.solarus-games.org/latest/lua_api_map.html)): The map that contains this entity.
---
---
---
---@return map
function m:get_map() end

---
---Called just before the entity is drawn on the map.
---
---You may display additional things below the entity. To do so, you can either call [map:draw_visual()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](https://doxygen.solarus-games.org/latest/lua_api_camera.html).
---
---  * `camera` ([camera](https://doxygen.solarus-games.org/latest/lua_api_camera.html)): The camera where this entity is being drawn.
---
---
---
---@param camera camera
function m:on_pre_draw(camera) end

---
---Returns an iterator to all [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of this entity.
---
---At each step, the iterator provides two values: the name of a sprite (which is an empty string if the sprite has no name) and the sprite itself. See [entity:get_sprite()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_sprite) for more details about named sprites.
---
---Sprites are returned in their displaying order. Note that this order can be changed with [entity:bring_sprite_to_front()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_bring_sprite_to_front) and [entity:bring_sprite_to_back()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_bring_sprite_to_back).
---
---The typical usage of this function is: 
---    
---    
---    for sprite_name, sprite in entity:get_sprites() do
---      -- some code related to the sprite
---    end
---    
---
---  * Return value (function): An iterator to all sprites of this entity.
---
---
---
---@return function
function m:get_sprites() end

---
---Called when the coordinates of this entity have just changed.
---
---  * `x` (number): The new X coordinate of the entity.
---  * `y` (number): The new Y coordinate of the entity.
---  * `layer` (number): The new layer of the entity.
---
---
---
---@param x number
---@param y number
---@param lay number
function m:on_position_changed(x,y,lay) end

---
---Returns the name of this map entity.
---
---The name uniquely identifies the entity on the map.
---
---  * Return value (string): The name of this entity, or `nil` if the entity has no name (because the name is optional).
---
---
---
---@return string
function m:get_name() end

---
---Returns the rectangle surrounding the bounding box of this entity plus the bounding boxes of its sprites in all their possible animations and directions.
---
---This is usually larger than [entity:get_bounding_box()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box), because the sprite of an entity often exceeds its bounding box.
---
---  * Return value 1 (number): X coordinate of the upper left corner of the sprites bounding box.
---  * Return value 2 (number): Y coordinate of the upper left corner of the sprites bounding box.
---  * Return value 3 (number): Width of the sprites bounding box.
---  * Return value 4 (number): Height of the sprites bounding box.
---
---
---
---@return number|number|number|number
function m:get_max_bounding_box() end

---
---Called when the [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) of this entity was stopped because of an obstacle.
---
---When an obstacle is reached, this event is called instead of [entity:on_position_changed()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_on_position_changed).
---
---  * `movement` ([movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html)): The movement of the entity.
---
---
---
---@param movement movement
function m:on_obstacle_reached(movement) end

---
---Called when some characteristics of this entity's [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) (like the speed or the angle) have just changed.
---
---  * `movement` ([movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html)): The movement of the entity.
---
---
---
---@param movement movement
function m:on_movement_changed(movement) end

---
---Returns the origin point of this entity, relative to the upper left corner of its [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box).
---
---When an entity is located at some coordinates on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html), the origin points determines what exact point of the entity's bounding box is at those coordinates. It is not necessarily the upper left corner of the entity's bounding box.
---
---The default origin point depends on the type of entity. By convention, it is usually be the central point of contact between the entity and the soil. For most entities, including the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html), [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html), [non-playing characters](https://doxygen.solarus-games.org/latest/lua_api_npc.html) and [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html), the default origin point is `8, 13` as their default size is `16x16`. More generally, the convention is to have an origin point of `width / 2, height - 3`.
---
---This origin point property allows entities of different sizes to have comparable reference points. Indeed, when two entities to be drawn in Y order overlap, the engine needs to determine which one has to be displayed first (it is always the one with the lowest Y coordinate). Using the upper left corner Y coordinate for this would not work well with entities of different sizes.
---
---Similarly, if you need to compute an [angle](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_angle) between two entities to move an entity away from another one, the calculation uses the origin point of both entities. Using the upper left corner of their bounding box would not give the accurate angle with entities of different sizes.
---
---The origin point is also the point of synchronization of an entity with its [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) (because again, an entity that has a given size may have sprites with different sizes).
---
---  * Return value 1 (number): X coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.
---  * Return value 2 (number): Y coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.
---
---
---
---@return number|number
function m:get_origin() end

---
---Makes sure this entity's upper left corner is aligned with the 8*8 grid of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
---Remarks
---    Be careful: this function does not check collisions with obstacles.
---
function m:snap_to_grid() end

---
---Returns the coordinates of the point this entity is looking at. This point depends on the direction of the main sprite if any. If the entity has no sprite, or if the main sprite has not 4 directions, then the movement is considered. If there is no movement either, the entity is assumed to look to the North.
---
---  * Return value 1 (number): X coordinate of the facing point of this entity, relative to the upper left corner of the map.
---  * Return value 2 (number): Y coordinate of the facing point of this entity, relative to the upper left corner of the map.
---  * Return value 3 (number): Layer of the entity.
---
---
---
---@return number|number|number
function m:get_facing_position() end

---
---Called when this entity is about to be removed from the map (and therefore destroyed).
---
function m:on_removed() end

---
---Like [entity:get_angle()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_angle), but instead of an angle in radians, returns the closest direction among the 4 main directions.
---
---This is a utility function that essentially rounds the result of [entity:get_angle()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_angle).
---
---To compute the direction to a specified point:
---
---  * `x` (number): X coordinate of the point.
---  * `y` (number): Y coordinate of the point.
---  * Return value (number): The direction this entity should take to look at this point, between 0 (East) and 3 (South).
---
---
---
---To compute the direction to another map entity:
---
---  * `other_entity` (entity): An entity to target.
---  * Return value (number): The direction this entity should take to look at the other entity, between 0 (East) and 3 (South).
---
---
---
---@param x number
---@param y number
---@return number|number
function m:get_direction4_to(x,y) end

---
---Sets a user-defined property for this entity.
---
---If the property does not exist yet, it will be created.
---
---User-defined properties are arbitrary key-value pairs that you can set to any entity. The engine does nothing special with them, but you can use them in your scripts to store extra information.
---
---  * `key` (string): Name of the property to set. It must be a valid identifier (only alphanumeric ASCII characters or `'_'`).
---  * `value` (string or nil): The value to set, or `nil` to remove the property.
---
---
---
---@param key string
---@param value string|nil
function m:set_property(key,value) end

---
---Reorders a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of this entity to be displayed before other sprites (displayed to the back).
---
---This function is only useful for entities that have multiple sprites.
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The sprite to reorder. It must belong to this entity.
---
---
---
---@param sprite sprite
function m:bring_sprite_to_back(sprite) end

---
---Returns the layer of this entity on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
---  * Return value (number): Layer where the entity is on the map, between [map:get_min_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_max_layer).
---
---
---
---@return number
function m:get_layer() end

---
---Called when the [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) of the entity is finished (if there is an end).
---
function m:on_movement_finished() end

---
---Returns the value of a user-defined property of this entity.
---
---User-defined properties are arbitrary key-value pairs that you can set to any entity. The engine does nothing special with them, but you can use them in your scripts to store extra information.
---
---  * `key` (string): Name of the property to get.
---  * Return value (string): The corresponding value, or `nil` if there is no such property.
---
---
---
---@param key string
---@return string
function m:get_property(key) end

---
---Changes how this entity is drawn.
---
---You can use this to replace the built-in draw implementation of the engine by your own function, if the default behavior does not fit your needs. To do so, your function can either call [map:draw_visual()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](https://doxygen.solarus-games.org/latest/lua_api_camera.html).
---
---  * `draw_override` (function or nil): The draw function, or `nil` to restore the built-in drawing. Your function will receive the following parameters:
---    * `entity` (entity): The entity to draw.
---    * `camera` ([camera](https://doxygen.solarus-games.org/latest/lua_api_camera.html)): Camera where this entity is drawn.
---
---
---
---Remarks
---    Even when you set a draw override, events [entity:on_pre_draw()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_on_pre_draw) and [entity:on_post_draw()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_on_post_draw) are still called.
---
---@param draw_override function|nil
function m:set_draw_override(draw_override) end

---
---Stops the current movement of this map entity if any.
---
function m:stop_movement() end

---
---Called just after the entity is drawn on the map.
---
---You may display additional things above the entity. To do so, you can either call [map:draw_visual()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](https://doxygen.solarus-games.org/latest/lua_api_camera.html).
---
---  * `camera` ([camera](https://doxygen.solarus-games.org/latest/lua_api_camera.html)): The camera where this entity is being drawn. 
---
---
---
---@param camera camera
function m:on_post_draw(camera) end

---
---Returns a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) representing this entity.
---
---To manage entities with multiple sprites, you can set names when you create sprites with [entity:create_sprite()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_create_sprite). However, it is easier to just leave the names blank and simply store the result of these sprite creation methods. The name is more useful for built-in entities that have multiple sprites automatically created by the engine. Such entities are the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html), [pickable treasures](https://doxygen.solarus-games.org/latest/lua_api_pickable.html), [carried objects](https://doxygen.solarus-games.org/latest/lua_api_carried_object.html) and [crystals](https://doxygen.solarus-games.org/latest/lua_api_crystal.html). See the documentation pages of these entities to know their exact sprites, the name of these sprites and which one is their main sprite. For [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) and [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html), the main sprite is the first one in Z order, which is the sprite creation order unless you call [entity:bring_sprite_to_front()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_bring_sprite_to_front) or [entity:bring_sprite_to_back()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_bring_sprite_to_back).
---
---  * `name` (string, optional): Name of the sprite to get. Only useful for entities that have multiple sprites. No value means the main sprite.
---  * Return value ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The entity sprite with this name, or its main sprite if no name is specified. Returns `nil` if the entity has no such sprite.
---
---
---
---@param name string|nil
---@return sprite
function m:get_sprite(name) end

---
---Returns the position of this entity on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) (coordinates and layer).
---
---  * Return value 1 (number): X coordinate of the [origin point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) of the entity, relative to the upper left corner of the map.
---  * Return value 2 (number): Y coordinate of the [origin point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) of the entity, relative to the upper left corner of the map.
---  * Return value 3 (number): Layer where the entity is on the map, between [map:get_min_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_max_layer).
---
---
---
---@return number|number|number
function m:get_position() end

---
---Returns whether this entity is enabled.
---
---When an entity is disabled, it is not displayed on the map, it does not move and does not detect collisions. But it still exists, it still has a position and it can be enabled again later.
---
---  * Return value (boolean): `true` if this entity is enabled.
---
---
---
---@return boolean
function m:is_enabled() end

---
---Sets the optimization threshold hint of this map entity.
---
---Above this distance from the camera, the engine may decide to skip updates or drawings. This is only a hint: the engine is responsible of the final decision.
---
---A value of `0` means an infinite distance (the entity is never optimized away). The default value is `0`.
---
---  * `optimization_distance` (number): The optimization distance hint to set in pixels.
---
---
---
---@param optimization_distance number
function m:set_optimization_distance(optimization_distance) end

---
---Returns the [stream](https://doxygen.solarus-games.org/latest/lua_api_stream.html) that is currently controlling this entity, if any.
---
---  * Return value ([stream](https://doxygen.solarus-games.org/latest/lua_api_stream.html)): The current stream, or `nil` if this entity is not being controlled by a stream.
---
---
---
---@return stream
function m:get_controlling_stream() end

---
---Sets the weight of this entity.
---
---See [entity:get_weight()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_weight) for more details.
---
---  * `weight` (number): The level of `"lift"` ability required to lift this entity. `0` allows the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) to lift the entity unconditionally. The special value `-1` means that the entity can never be lifted.
---
---
---
---@param weight number
function m:set_weight(weight) end

---
---Sets the size of the [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box) of this entity.
---
---This is the effective size used to detect obstacles when moving, but the [sprite(s)](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of the entity may be larger.
---
---The default value depends on the type of entity and is often `16x16` pixels.
---
---  * `width` (number): Width of the entity in pixels.
---  * `height` (number): Height of the entity in pixels.
---
---
---
---Remarks
---    Note that the [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of an entity may have a different size than the entity itself. See [sprite:get_size()](https://doxygen.solarus-games.org/latest/lua_api_sprite.html#lua_api_sprite_get_size) to know it.
---
---@param width number
---@param height number
function m:set_size(width,height) end

---
---called when this entity has just been [disabled](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_is_enabled).
---
function m:on_disabled() end

---
---called when this entity has just been [enabled](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_is_enabled).
---
function m:on_enabled() end

---
---Changes the layer of this entity on the map. The X and Y coordinates of the entity are unchanged. Any previous movement or action performed by the entity continues normally.
---
---  * `layer` (number, optional): Layer to set, between [map:get_min_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_max_layer).
---
---
---
---Remarks
---    Be careful: this function does not check collisions with obstacles.
---
---@param layer number
function m:set_layer(layer) end

---
---Returns whether this entity should be drawn in Y order or in Z order.
---
---The map is drawn layer by layer, and each layer is drawn in two passes: first, entities displayed in Z order, and then, entities displayed in Y order.
---
---The Z order is the creation order of entities unless you call [entity:bring_to_front()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_bring_to_front) or [entity:bring_to_back()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_bring_to_back).
---
---The Y order compares the Y coordinate of entities on the map. Entities drawn in Y order are displayed from the one the most to the north to the one the most to the south.
---
---Usually, entities representing a character or something that is standing should be drawn in Y order, so that it looks correct when some of them overlap with each other, and flat entities should be drawn in Z order.
---
---The default setting depends on the type of entities.
---
---  * Return value (boolean): `true` if this entity is displayed in Y order, `false` if it is displayed in Z order.
---
---
---
---@return boolean
function m:is_drawn_in_y_order() end

---
---Sets the user-defined properties of this entity.
---
---Existing properties if any are removed.
---
---  * `properties` (table): An array of properties. Each property is a table with two fields:
---    * `key` (string): Name of the property. It must be a valid identifier (only alphanumeric ASCII characters or `'_'`).
---    * `value` (string): Value of the property.
---
---
---
---#  Events of all entity types
---
---Events are callback methods automatically called by the engine if you define them.
---
---@param properties table
function m:set_properties(properties) end

---
---Returns the size of the bounding box of this entity.
---
---The [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box) is a rectangle that determines the position of the entity on the map. The bounding box is used to detect whether the entity overlaps obstacles or other entities.
---
---  * Return value 1 (number): Width of the entity in pixels.
---  * Return value 2 (number): Height of the entity in pixels.
---
---
---
---@return number|number
function m:get_size() end

---
---Returns the user-defined properties of this entity.
---
---  * Return value (table): An array of properties. Each property is a table with two fields:
---    * `key` (string): Name of the property.
---    * `value` (string): Value of the property.
---
---
---
---@return table
function m:get_properties() end

---
---Called when a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) is started on this entity.
---
---  * `movement` ([movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html)): The movement that was just started on this entity.
---
---
---
---@param movement movement
function m:on_movement_started(movement) end

---
---Hides or shows the entity.
---
---When the entity is hidden, its sprites (if any) are not displayed, but everything else continues normally, including collisions.
---
---  * `visible` (boolean, optional): `true` to show the entity, `false` to hide it. No value means `true`.
---
---
---
---@param visible boolean|nil
function m:set_visible(visible) end

---
---Returns the draw function of this entity.
---
---See [entity:set_draw_override()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_set_draw_override) for more details.
---
---  * Return value (function or nil): The draw function, or `nil` if the draw function was not overridden.
---
---
---
---@return function|nil
function m:get_draw_override() end

---
---Returns the weight of this entity, if any.
---
---If the entity has a weight, then the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) is allowed to lift it if his [lift ability](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) is greater than or equal to that weight. You can use [entity:on_lifting()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_on_lifting) to know when an entity starts being lifted.
---
---The default weight depends on the type of entity. Most entities cannot be lifted by default.
---
---  * Return value (number): The level of `"lift"` ability required to lift this entity. `0` allows the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) to lift the entity unconditionally. The special value `-1` means that the entity can never be lifted.
---
---
---
---@return number
function m:get_weight() end

---
---Returns whether this entity is visible.
---
---When the entity is hidden, its sprites (if any) are not displayed, but everything else continues normally, including collisions.
---
---  * Return value (boolean): `true` if the entity is visible.
---
---
---
---@return boolean
function m:is_visible() end

---
---Reorders a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of this entity to be displayed after other sprites (displayed to the front).
---
---This function is only useful for entities that have multiple sprites.
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The sprite to reorder. It must belong to this entity.
---
---
---
---@param sprite sprite
function m:bring_sprite_to_front(sprite) end

---
---Returns whether there would be a collision with obstacles if this map entity was placed at a given offset from its current position.
---
---  * `dx` (number, optional): X offset in pixels (`0` means the current X position). No value means `0`.
---  * `dy` (number, optional): Y offset in pixels (`0` means the current Y position). No value means `0`.
---  * `layer` (number, optional): Layer to test. No value means the current layer.
---  * Return value (boolean): `true` if there would be a collision in this position.
---
---
---
---@param dx number|nil
---@param dy number
---@param layer number|nil
---@return boolean
function m:test_obstacles(dx,dy,layer) end

---
---Sets the origin point of this entity, relative to the upper left corner of its [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box).
---
---See [entity:get_origin()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) for details about the origin point.
---
---  * `origin_x` (number): X coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.
---  * `origin_y` (number): Y coordinate of the origin point in pixels, relative to the upper left corner of the entity's bounding box.
---
---
---
---Remarks
---    When you call this method, the bounding box of the entity is moved so that coordinates (as returned by [entity:get_position()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_position)) do not change. If this is not what you need, you can call [entity:set_position()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_set_position) then to adjust the entity's position to the coordinates you want.
---
---@param origin_x number
---@param origin_y number
function m:set_origin(origin_x,origin_y) end

---
---Called when this entity starts being lifted.
---
---At this point, the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) is in [state](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) `"lifting"`. The animation `"lifting"` of his sprites is playing and the player cannot control the hero.
---
---This entity no longer exists (unless it is a destructible object that can [regenerate](https://doxygen.solarus-games.org/latest/lua_api_destructible.html#lua_api_destructible_get_can_regenerate)). It is replaced by a [carried object](https://doxygen.solarus-games.org/latest/lua_api_carried_object.html) with the same sprite.
---
---  * `carrier` ([entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html)): Entity that is lifting this destructible object (can only be the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) for now).
---  * `carried_object` ([carried object](https://doxygen.solarus-games.org/latest/lua_api_carried_object.html)): The carried object that was created.
---
---
---
---@param carrier entity
---@param carried_object carried_object
function m:on_lifting(carrier,carried_object) end

---
---Sets whether this entity should be drawn in Y order or in Z order.
---
---See [entity:is_drawn_in_y_order()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_is_drawn_in_y_order) for details about the Y order and the Z order.
---
---  * `y_order` (boolean, optional): `true` to display this entity in Y order, `false` to display it in Z order. No value means `true`.
---
---
---
---@param y_order boolean|nil
function m:set_drawn_in_y_order(y_order) end

---
---Returns whether this entity still exists on the map.
---
---An entity gets destroyed when you call [entity:remove()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_remove) or when the engine removes it (for example an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) that gets killed or a [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) that gets picked up). If you refer from Lua to an entity that no longer exists in the C++ side, this method returns `false`.
---
---  * Return value (boolean): `true` if the entity exists, `false` if it was destroyed.
---
---
---
---@return boolean
function m:exists() end

---
---Places this entity behind all other entities on the same layer.
---
---Since entities that are on the same layer can overlap, you can use this function to change their Z order.
---
---Remarks
---    Some entities can have have the property to be [drawn in Y order](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_is_drawn_in_y_order) rather than in Z order. This function only has an effect on entities drawn in Z order.
---
function m:bring_to_back() end

---
---Returns the distance in pixels between this map entity and a point or another map entity.
---
---To compute the distance to a specified point:
---
---  * `x` (number): X coordinate of the point.
---  * `y` (number): Y coordinate of the point.
---  * Return value (number): The distance in pixels between the origin point of this entity and the point.
---
---
---
---To compute the distance to another map entity:
---
---  * `other_entity` (entity): The entity to compute the distance to.
---  * Return value (number): The distance in pixels between the origin point of this entity and the origin point of the other entity.
---
---
---
---@param x number
---@param y number
---@return number|number
function m:get_distance(x,y) end

---
---Returns whether another entity collides with this entity according to the specified collision test.
---
---  * `entity` (entity): Another entity.
---  * `collision_mode` (string, optional): Specifies what kind of collision you want to test. This may be one of:
---    * `"overlapping"`: Collision if the [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box) of both entities overlap. This is the default value.
---    * `"containing"`: Collision if the bounding box of the other entity is fully inside the bounding box of this entity.
---    * `"origin"`: Collision if the [origin point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) or the other entity is inside the bounding box of this entity.
---    * `"center"`: Collision if the [center point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_center_position) of the other entity is inside the bounding box of this entity.
---    * `"facing"`: Collision if the [facing position](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_facing_position) of the other entity's bounding box is touching this entity's bounding box. Bounding boxes don't necessarily overlap, but they are in contact: there is no space between them. When you consider the bounding box of an entity, which is a rectangle with four sides, the facing point is the middle point of the side the entity is oriented to. This `"facing"` collision test is useful when the other entity cannot traverse your custom entity. For instance, if the other entity has direction "east", there is a collision if the middle of the east side of its bounding box touches (but does not necessarily overlap) this entity's bounding box. This is typically what you need to let the hero interact with this entity when he is looking at it.
---    * `"touching"`: Like `"facing"`, but accepts all four sides of the other entity's bounding box, no matter its direction.
---    * `"sprite"`: Collision if a sprite of the other entity overlaps a sprite of this entity. The collision test is pixel precise. The last two optional sprite parameters can then indicate which sprite of both entities you want to test. If you don't set them, all sprites of both entities will be tested.
---  * `entity_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) or nil, optional): Sprite of this entity you want to test (only with collision mode `"sprite"`). `nil` or no value means to test all sprites of this entity.
---  * `other_entity_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) or nil, optional): Sprite of the other entity you want to test (only with collision mode `"sprite"`). `nil` or no value means to test all sprites of the other entity.
---  * Return value (boolean): `true` if a collision is detected with this collision test.
---
---
---
---Remarks
---    For custom entities, see also [custom_entity:add_collision_test()](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html#lua_api_custom_entity_add_collision_test) to be automatically notified when a collision is detected.
---
---@param entity entity
---@param collision_mode string|nil
---@param entity_sprite sprite|nil
---@param other_entity_sprite sprite|nil
---@return boolean
function m:overlaps(entity,collision_mode,entity_sprite,other_entity_sprite) end

---
---Returns the game that is running the map this entity belongs to.
---
---  * Return value ([game](https://doxygen.solarus-games.org/latest/lua_api_game.html)): The current game.
---
---
---
---@return game
function m:get_game() end

---
---Called when the entity has just been suspended or resumed.
---
---The entity is suspended by the engine in a few cases, like when the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is paused or when a dialog is active. When this happens, all [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html) stop moving and most [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) stop their animation.
---
---  * `suspended` (boolean): `true` if the entity was just suspended, `false` if it was resumed.
---
---
---
---@param suspended boolean
function m:on_suspended(suspended) end

---
---Returns the rectangle representing the [coordinates](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_position) and [size](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_size) of this entity on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
---The [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box) is a rectangle that determines the position of the entity on the map. The bounding box is used to detect whether the entity overlaps obstacles or other entities.
---
---  * Return value 1 (number): X coordinate of the upper left corner of the bounding box.
---  * Return value 2 (number): Y coordinate of the upper left corner of the bounding box.
---  * Return value 3 (number): Width of the bounding box.
---  * Return value 4 (number): Height of the bounding box.
---
---
---
---Remarks
---    The sprites of this entity (if any) may exceed the bounding box. See [entity:get_max_bounding_box()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_max_bounding_box).
---
---@return number|number|number|number
function m:get_bounding_box() end

_G.entity = m

return m