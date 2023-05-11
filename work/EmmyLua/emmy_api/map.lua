---@class map : entity
---
---Maps are areas where the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) takes place. They may be rooms, houses, entire dungeon floors, parts of the outside world or any place. The active map contains many objects called [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) (or just "entities" to be short). Map entities are everything that has a position on the map, including the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), the [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html), the [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html), the [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) and even the [camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html). See the [entity API](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) for more details.
---
local m = {}

---
---Creates an entity of type [switch](http://www.solarus-games.org/doc/1.6/lua_api_switch.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `subtype` (string): Kind of switch to create:
---      * `"walkable"`: A traversable pressure plate that gets activated when the hero walks on it.
---      * `"solid"`: A non-traversable, solid switch that can be activated in various conditions: by the sword, by an explosion or by a projectile (a thrown object, an arrow, the boomerang or the hookshot).
---      * `"arrow_target"` A switch that can be only activated by shooting an arrow on it.
---    * `sprite` (string): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) to create for the switch. The animation set must at least contain animations `"activated"` and `"inactivated"`. No value means no sprite.
---    * `sound` (string, optional): Sound to play when the switch is activated. No value means no sound.
---    * `inactivate_when_leaving` (boolean): If `true`, the switch becomes inactivated when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) or the [block](http://www.solarus-games.org/doc/1.6/lua_api_block.html) leaves it (only for a walkable switch).
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([switch](http://www.solarus-games.org/doc/1.6/lua_api_switch.html)): the switch created.
---
---
---
---@param properties table
---@return switch
function m:create_switch(properties) end

---
---Creates an entity of type [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) on the map.
---
---  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number): Direction that the hero should take when arriving on the destination, between `0` (East) and `3` (South), or `-1` to keep his direction unchanged.
---    * `sprite` (string, optional): Id of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the destination. No value means no sprite (the destination will then be invisible).
---    * `save_location` (string, optional): Whether to update the [starting location](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_set_starting_location) of the player when arriving to this destination. If yes, when the player restarts his game, he will restart at this destination. Must be one of:
---      * `"when_world_changes"` (default): Updates the starting location if the current [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world) has just changed when arriving to this destination.
---      * `"yes"`: Updates the starting location.
---      * `"no"`: Does not update the starting location.
---    * `default` (boolean, optional): Sets this destination as the default one when teletransporting the hero to this map without destination specified. No value means `false`. Only one destination can be the default one on a map. If no default destination is set, then the first one declared becomes the default one.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination created.
---
---
---
---@param properties table
---@return destination
function m:create_destination(properties) end

---
---Called when the user releases a joypad button while your map is active.
---
---  * `button` (number): Index of the button that was released.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param button number
---@return boolean
function m:on_joypad_button_released(button) end

---
---When the map begins, called when the opening transition effect finishes.
---
---  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrived on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).
---
---
---
---@param destination destination
function m:on_opening_transition_finished(destination) end

---
---Removes and destroys all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.
---
---Once an entity is removed, it is destroyed and it no longer exists on the map. A good practice is to avoid keeping references to destroyed entities in your scripts so that they can be garbage-collected by Lua.
---
---  * `prefix` (string): Prefix of the entities to remove from the map.
---
---
---
---Remarks
---    Equivalent to calling [entity:remove()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_remove) on a group of entities.
---
---@param prefix string
function m:remove_entities(prefix) end

---
---Called at each cycle of the main loop while this map is the current one.
---
---Remarks
---    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
---
function m:on_update() end

---
---Enables or disables all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.
---
---Disabled entities are not displayed and are not updated. Therefore, they don't move and their collisions are no longer detected. But they still exist and can be enabled back later.
---
---  * `prefix` (string): Prefix of the entities to change.
---  * `enable` (boolean, optional): `true` to enable them, `false` to disable them. No value means `true`.
---
---
---
---Remarks
---    Equivalent to calling [entity:set_enabled()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled) on a group of entities.
---
---@param prefix string
---@param enable boolean|nil
function m:set_entities_enabled(prefix,enable) end

---
---Called when the user enters text while your map is active.
---
---  * `character` (string): A utf-8 string representing the character that was pressed.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).
---
---
---
---Remarks
---    When a character key is pressed, two events are called: [map:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_key_pressed) (indicating the raw key) and [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed) (indicating the utf-8 character). If your script needs to input text from the user, [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
---
---@param character string
---@return boolean
function m:on_character_pressed(character) end

---
---Creates an entity of type [fire](http://www.solarus-games.org/doc/1.6/lua_api_fire.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([fire](http://www.solarus-games.org/doc/1.6/lua_api_fire.html)): the fire created.
---
---
---
---@param properties table
---@return fire
function m:create_fire(properties) end

---
---Returns the camera entity of the map.
---
---  * Return value ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera.
---
---
---
---@return camera
function m:get_camera() end

---
---Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is obtaining a treasure on this map, before the treasure's dialog (if any).
---
---  * `treasure_item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): Equipment item being obtained.
---  * `treasure_variant` (number): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants).
---  * `treasure_savegame_variable` (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this treasure is found, or `nil` if this treasure is not saved.
---
---
---
---@param treasure_item item
---@param treasure_variant number
---@param treasure_savegame_variable string
function m:on_obtaining_treasure(treasure_item,treasure_variant,treasure_savegame_variable) end

---
---Returns the current game.
---
---  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The game that is currently running the map.
---
---
---
---@return game
function m:get_game() end

---
---Returns the x,y location of this map in its [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world).
---
---The engine uses this information to implement scrolling between two adjacent maps.
---
---For example, you can also use this property in scripts if you want to show the position of the hero on the minimap [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) of your outside [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world). Indeed, your outside world is probably not a single map, but it is usually composed of several adjacent maps.
---
---  * Return value 1 (number): X position of the top-left corner of this map relative to its world.
---  * Return value 2 (number): Y position of the top-left corner of this map relative to its world.
---
---
---
---@return number,number
function m:get_location() end

---
---Called when the user moves a joypad axis while your map is active.
---
---  * `axis` (number): Index of the axis that was moved. Usually, `0` is an horizontal axis and `1` is a vertical axis.
---  * `state` (number): The new state of the axis that was moved. `-1` means left or up, `0` means centered and `1` means right or down.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param axis number
---@param state number
---@return boolean
function m:on_joypad_axis_moved(axis,state) end

---
---Creates an entity of type [block](http://www.solarus-games.org/doc/1.6/lua_api_block.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number, optional): The only direction where the block can be moved, between `0` (East) and `3` (South). `nil` means no restriction and allows the block to be moved in any of the four main directions. The default value is `nil`.
---    * `sprite` (string): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) to create for the block.
---    * `pushable` (boolean): `true` to allow the block to be pushed.
---    * `pullable` (boolean): `true` to allow the block to be pulled.
---    * `max_moves` (number, optional): `How` many times the block can be moved (`nil` means unlimited). The default value is `nil`.
---    * `maximum_moves` (number, optional, deprecated): Like `max_moves`, but for historical reasons, only supports `0`, `1` or the special value `2` to mean infinite. New scripts should only use `max_moves`. It is an error to set both values.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([block](http://www.solarus-games.org/doc/1.6/lua_api_block.html)): the block created.
---
---
---
---@param properties table
---@return block
function m:create_block(properties) end

---
---Called when the user presses a finger while this map is active.
---
---  * `finger` (integer): ID of the finger that was pressed.
---  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param finger integer
---@param x integer
---@param y integer
---@param pressure number
---@return boolean
function m:on_finger_pressed(finger,x,y,pressure) end

---
---Creates an entity of type [shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `price` (number): Money amount required to buy the treasure.
---    * `font` (string, optional): Id of the font to use to display to price. The default value is the first one in alphabetical order.
---    * `dialog` (string): Id of the dialog to show when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) asks for information about the treasure.
---    * `treasure_name` (string): Kind of treasure to sell (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value or corresponds to a [non-obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable) item, then the shop treasure is not created and `nil` is returned.
---    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the player has purchased this treasure. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then the shop treasure is not created and `nil` is returned.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html)): The shop treasure created, or `nil` if the item is not [obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), or if the shop treasure was already purchased (for a saved one).
---
---
---
---Remarks
---    The state of the [shop treasure](http://www.solarus-games.org/doc/1.6/lua_api_shop_treasure.html) (purchased or not) and the possessed variant of its [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (a number) are two independent values that have different meanings and are saved separately.
---
---@param properties table
---@return shop_treasure
function m:create_shop_treasure(properties) end

---
---Returns the floor of the current map if any.
---
---The floor is an optional property defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).
---
---The engine does not do anything particular with this floor property. But you can use it in scripts, for example to show the current floor on the HUD when it changes or to make a minimap [menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html).
---
---  * Return value (number): The current floor. `0` is the first floor, `1` is the second floor, `-1` is the first basement floor, etc. `nil` means that this map is not part of a floor system.
---
---
---
---@return number
function m:get_floor() end

---
---Changes the floor of this map.
---
---The floor property remains until the map is destroyed: If you reload the same map again later, the floor is reset to the one defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).
---
---  * `floor` (number): The new floor number to set, or `nil` to set no floor.
---
---
---
---@param floor number
function m:set_floor(floor) end

---
---Creates an entity of type [stream](http://www.solarus-games.org/doc/1.6/lua_api_stream.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number): Direction where the stream moves the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html), between `0` (East) and `7` (South-East).
---    * `sprite` (string, optional): Id of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/quest_sprite_data_file.html) to create for the stream. No value means no sprite (the stream will then be invisible).
---    * `speed` (number, optional): Speed of the movement applied to the hero by the stream, in pixels per second. The default value is `64`.
---    * `allow_movement` (boolean, optional): Whether the player can still move the hero when he is on the stream. The default value is `true`.
---    * `allow_attack` (boolean, optional): Whether the player can use the sword when he is on the stream. The default value is `true`.
---    * `allow_item` (boolean, optional): Whether the player can use equipment items when he is on the stream. The default value is `true`.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([stream](http://www.solarus-games.org/doc/1.6/lua_api_stream.html)): the stream created.
---
---
---
---@param properties table
---@return stream
function m:create_stream(properties) end

---
---Creates an entity of type [crystal block](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels.
---    * `height` (number): Height of the entity in pixels.
---    * `subtype` (number): Kind of crystal block to create: `0` for a block initially lowered (orange), `1` for a block initially raised (blue).
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([crystal block](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html)): the crystal block created.
---
---
---
---@param properties table
---@return crystal block
function m:create_crystal_block(properties) end

---
---Returns the number of [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.
---
---  * `prefix` (string): Prefix of the entities to count.
---  * Return value (number): The number of entities having this prefix on the map.
---
---
---
---@param prefix string
---@return number
function m:get_entities_count(prefix) end

---
---Returns the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
---
---  * Return value ([hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)): The hero.
---
---
---
---Remarks
---    Equivalent to `map:get_entity("hero")` but shorter to write. This function is provided for convenience as getting the hero is often needed.
---
---@return hero
function m:get_hero() end

---
---Creates an entity of type [explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([explosion](http://www.solarus-games.org/doc/1.6/lua_api_explosion.html)): the explosion created.
---
---
---
---@param properties table
---@return explosion
function m:create_explosion(properties) end

---
---Closes the [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) whose name starts with the specified prefix, enables or disables relative [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) accordingly and plays the `"door_closed"` [sound](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound).
---
---Closing a door may be more complex than just modifying a single [door entity](http://www.solarus-games.org/doc/1.6/lua_api_door.html). Indeed, there is often a corresponding door is the adjacent room that you also want to open (that corresponding door is another [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)). Name both doors with the same prefix, and you can use this function to close both of them.
---
---Furthermore, you sometimes want [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) to be shown or hidden depending on the state of a door. When a door is closed, all dynamic tiles whose prefix is the door's name followed by `_open` or `_closed` are automatically disabled or enabled, respectively.
---
---  * `prefix` (string): Prefix of the name of doors to close.
---
---
---
---@param prefix string
function m:close_doors(prefix) end

---
---Called when the map has just been redrawn by the engine.
---
---The engine has already drawn the map, but not the [menus](http://www.solarus-games.org/doc/1.6/lua_api_menu.html) of this map if any. Use this event if you want to draw some additional content on the map before the menus, for example an overlay.
---
---  * `dst_surface` ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html)): The surface where the map is drawn. This surface represents the visible part of the screen, not the whole map.
---
---
---
---@param dst_surface surface
function m:on_draw(dst_surface) end

---
---Returns the name of the [tileset](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_tileset) of the current map.
---
---  * Return value (string): Id of the current tileset.
---
---
---
---@return string
function m:get_tileset() end

---
---Called when this map stops (when the player leaves it).
---
function m:on_finished() end

---
---Called when the user presses a keyboard key while your map is active.
---
---  * `key` (string): Name of the raw key that was pressed.
---  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).
---
---
---
---Remarks
---    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed). If you want the corresponding higher-level game command (if any), see [map:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_command_pressed).
---
---@param key string
---@param modifiers table
---@return boolean
function m:on_key_pressed(key,modifiers) end

---
---Creates an entity of type [crystal](http://www.solarus-games.org/doc/1.6/lua_api_crystal.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([crystal](http://www.solarus-games.org/doc/1.6/lua_api_crystal.html)): the crystal created.
---
---
---
---@param properties table
---@return crystal
function m:create_crystal(properties) end

---
---Called after the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) has obtained a treasure on this map.
---
---In the case of a brandished treasure, this event is called once the treasure's dialog is finished. Otherwise, it is called immediately after [map:on_obtaining_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_obtaining_treasure).
---
---  * `treasure_item` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): Equipment item being obtained.
---  * `treasure_variant` (number): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants).
---  * `treasure_savegame_variable` (string): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this treasure is found, or `nil` if this treasure is not saved.
---
---
---
---@param treasure_item item
---@param treasure_variant number
---@param treasure_savegame_variable string
function m:on_obtained_treasure(treasure_item,treasure_variant,treasure_savegame_variable) end

---
---Changes the [tileset](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_tileset) of the current map.
---
---It is your responsability to make sure that the new tileset is be compatible with the previous one: every tile of the previous tileset must exist in the new one and have the exact same properties, and only the images can differ.
---
---  * `tileset_id` (string): Id of the new tileset to set.
---
---
---
---Remarks
---    If the new tileset is not compatible with the previous one, tiles will be displayed with wrong graphics.
---
---@param tileset_id string
function m:set_tileset(tileset_id) end

---
---Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that are in a region. Regions of the map are defined by the position of [separators](http://www.solarus-games.org/doc/1.6/lua_api_separator.html) and map limits. The region of an entity is the one of its center point.
---
---Regions should be rectangular. Non-convex regions, for example with an "L" shape, are not supported by this function.
---
---The typical usage of this function is: 
---    
---    
---    for entity in map:get_entities_in_region(my_entity) do
---      -- some code related to the entity
---    end
---    
---
---To get entities in the same region as a point:
---
---  * `x` (number): X coordinate of the region to get.
---  * `y` (number): Y coordinate of the region to get.
---  * Return value (function): An iterator to all entities in the same region as the point.
---
---
---
---To get entities in the same region as another entity:
---
---  * `entity` (entity): An entity.
---  * Return value (function): An iterator to all other entities in the same region.
---
---
---
---@param x number
---@param y number
---@return function,function
function m:get_entities_in_region(x,y) end

---
---Draws a [drawable object](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html) ([surface](http://www.solarus-games.org/doc/1.6/lua_api_surface.html), [text surface](http://www.solarus-games.org/doc/1.6/lua_api_text_surface.html) or [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)) on the [camera](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_camera) at the given map coordinates.
---
---This function can be used as an alternative to [drawable:draw()](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html#lua_api_drawable_draw) in order to draw the object relative to the map (instead of relative to the screen).
---
---If the object to draw is a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html), its origin point will be displayed at the given location, relative to the the upper left corner of the map.
---
---This function should only be called during the drawing phase of the map, for example from [map:on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_draw) or from [custom_entity:on_post_draw()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_on_post_draw).
---
---  * `drawable` ([drawable](http://www.solarus-games.org/doc/1.6/lua_api_drawable.html)): The visual object to draw on the map.
---  * `x` (number): X coordinate of where to draw the object, in map coordinates.
---  * `y` (number): Y coordinate of where to draw the object, in map coordinates.
---
---
---
---@param drawable drawable
---@param x number
---@param y number
function m:draw_visual(drawable,x,y) end

---
---Returns the name of the music associated to this map.
---
---This is the music to play when the map starts, as specified in the map file. It may be different from the music currently being played. To get the music currently being played, see [sol.audio.get_music()](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_get_music).
---
---  * Return value (string): Name of the music of this map, relative to the `musics` directory and without extension. It can also be the special value `"same"` if the map specifies to keep the music unchanged, or `nil` if the map specifies to play no music.
---
---
---
---@return string
function m:get_music() end

---
---Creates an entity of type [dynamic tile](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate of the top-left corner of the dynamic tile on the map.
---    * `y` (number): Y coordinate of the top-left corner of the dynamic tile on the map.
---    * `width` (number): Width of the dynamic tile in pixels. The tile pattern will be repeated horizontally to fit to this width.
---    * `height` (number): Height of the entity in pixels. The tile pattern will be repeated vertically to fit to this height.
---    * `pattern` (string): Id of the tile pattern to use from the tileset.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([dynamic tile](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html)): the dynamic tile created.
---
---
---
---@param properties table
---@return dynamic_tile
function m:create_dynamic_tile(properties) end

---
---Creates an entity of type [jumper](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels.
---    * `height` (number): Height of the entity in pixels.
---    * `direction` (number): Direction of the jump, between `0` (East) and `7` (South-East). If the direction is horizontal, the width must be `8` pixels. If the direction is vertical, the height must be `8` pixels. If the direction is diagonal, the size must be square.
---    * `jump_length` (number): Length of the baseline of the jump in pixels (see the [jump movement](http://www.solarus-games.org/doc/1.6/lua_api_jump_movement.html) page for details).
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([jumper](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html)): The jumper created.
---
---
---
---@param properties table
---@return jumper
function m:create_jumper(properties) end

---
---Called when the user releases a finger while this map is active.
---
---  * `finger` (integer): ID of the finger that was pressed.
---  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param finger integer
---@param x integer
---@param y integer
---@param pressure number
---@return boolean
function m:on_finger_released(finger,x,y,pressure) end

---
---Returns the id of this map.
---
---  * Return value (string): Id of the map.
---
---
---
---Remarks
---    This id appears in the name of [map files](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).
---
---@return string
function m:get_id() end

---
---Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) whose maximum bounding box intersects the given rectangle. The maximum bounding box is the union of the entity's own [bounding box](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_bounding_box) and of the bounding boxes from its sprites.
---
---The typical usage of this function is: 
---    
---    
---    for entity in map:get_entities_in_rectangle(x, y, width, height) do
---      -- some code related to the entity
---    end
---    
---
---  * `x` (number): X coordinate of the rectangle's upper-left corner.
---  * `y` (number): Y coordinate of the rectangle's upper-left corner.
---  * `width` (number): Width of the rectangle.
---  * `height` (number): Height of the rectangle.
---  * Return value (function): An iterator to all entities intersecting the rectangle. Entities are returned in Z order (insertion order).
---
---
---
---@param x number
---@param y number
---@param width number
---@param height number
---@return function
function m:get_entities_in_rectangle(x,y,width,height) end

---
---Creates an entity of type [door](http://www.solarus-games.org/doc/1.6/lua_api_door.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number): Direction of the door, between `0` (East of the room) and `3` (South of the room).
---    * `sprite` (string): Name of the animation set of the [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the door. The sprite must have an animation `"closed"`, that will be shown while the door is closed. When the door is open, no sprite is displayed. Optionally, the sprite can also have animations `"opening"` and `"closing"`, that will be shown (if they exist) while the door is being opened or closed, respectively. If they don't exist, the door will open close instantly.
---    * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this door is open. No value means that the door is not saved. If the door is saved as open, then it appears open.
---    * `opening_method` (string, optional): How the door is supposed to be opened by the player. Must be one of:
---      * `"none"` (default): Cannot be opened by the player. You can only open it from Lua.
---      * `"interaction"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it.
---      * `"interaction_if_savegame_variable"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that a specific savegame variable is set.
---      * `"interaction_if_item"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that the player has a specific [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html).
---      * `"explosion"`: Can be opened by an explosion.
---    * `opening_condition` (string, optional): The condition required to open the door. Only for opening methods `"interaction_if_savegame_variable"` and `"interaction_if_item"`.
---      * For opening method `"interaction_if_savegame_variable"`, it must be the name of a savegame variable. The [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) will be allowed to open the door if this saved value is either `true`, an integer greater than zero or a non-empty string.
---      * For opening method `"interaction_if_item"`, it must be the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). The hero will be allowed to open the door if he has that item and, for items with an amount, if the amount is greater than zero.
---      * For other opening methods, this setting has no effect.
---    * `opening_condition_consumed` (boolean, optional): Whether opening the door should consume the savegame variable or the [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) that was required. The default setting is `false`. If you set it to `true`, the following rules are applied when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) successfully opens the door:
---      * For opening method `"interaction_if_savegame_variable"`, the savegame variable that was required is reset to `false`, `0` or `""` (depending on its type).
---      * For opening method is `"interaction_if_item"`, the equipment item that was required is removed. This means setting its [possessed variant](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_variant) to `0`, unless it has an associated amount: in this case, the amount is decremented.
---      * With other opening methods, this setting has no effect.
---    * `cannot_open_dialog` (string, optional): Id of the dialog to show if the hero fails to open the door. If you don't set this value, no dialog is shown.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([door](http://www.solarus-games.org/doc/1.6/lua_api_door.html)): The [door](http://www.solarus-games.org/doc/1.6/lua_api_door.html) created.
---
---
---
---@param properties table
---@return door
function m:create_door(properties) end

---
---Returns the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) with the specified name if it exists on this map. Entity names are unique (two entities cannot exist on the map with the same name at the same time). The name is optional: some entities may have no name. In this case, you cannot access them from this function.
---
---As a convenient feature, map entities can also be accessed directly through the environment of the [map script](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). In other words, you can just write `bob:get_position()` as an equivalent to `map:get_entity("bob"):get_position()`.
---
---  * `name` (string): Name of the map entity to get.
---  * Return value ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The corresponding entity, or `nil` if there exists no entity with this name on the map.
---
---
---
---Remarks
---    Technical note for curious Lua experts: the mechanism that makes map entities directly accessible in the map script environment is lazy (it is implemented as an `__index` metamethod). Entities are imported to the Lua side only when your script requests them. If you have thousands of named entities in your map, you won't have thousands of useless objects living in Lua. Only the ones your script tries to access are imported.
---
---@param name string
---@return entity
function m:get_entity(name) end

---
---Returns the world name that was set on this map.
---
---The world name is an optional property defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). Worlds allow to group maps together. The world can be any arbitrary name. Maps that have the same world name are considered to be part of the same environment. For example, your map can be in a world named `"outside_world"`, `"dungeon_1"` or `"some_scary_cave"`. A map that has no world is always considered to be alone in its own environment.
---
---The world property is used to decide when to set the starting location of the player (the place where he starts when loading his [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html)). By default, the starting location is automatically set by the engine when the world changes (not when the map changes). This can be changed by defining the "Save starting location" property of destinations, from the quest editor or from a script (with [destination:set_starting_location_mode()](http://www.solarus-games.org/doc/1.6/lua_api_destination.html#lua_api_destination_set_starting_location_mode)).
---
---Some other features may also rely on the world property, like the state of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html). Their state persists between all maps of the current world and is reset when entering a map whose world is different.
---
---  * Return value (string): Name of the world of the current map. `nil` means no world.
---
---
---
---@return string
function m:get_world() end

---
---Opens the [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) whose name starts with the specified prefix, enables or disables relative [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) accordingly and plays the `"door_open"` [sound](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound).
---
---Opening a door may be more complex than just modifying a single [door entity](http://www.solarus-games.org/doc/1.6/lua_api_door.html). Indeed, there is often a corresponding door is the adjacent room that you also want to open (that corresponding door is another [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)). Name both doors with the same prefix, and you can use this function to open both of them.
---
---Furthermore, you sometimes want [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html) to be shown or hidden depending on the state of a door. When a door is open, all dynamic tiles whose prefix is the door's name followed by `_open` or `_closed` are automatically enabled or disabled, respectively.
---
---  * `prefix` (string): Prefix of the name of doors to open.
---
---
---
---Remarks
---    The doors will be really closed once the opening animation of their sprite is finished. However, they immediately become obstacles.
---
---@param prefix string
function m:open_doors(prefix) end

---
---Called when the user moves a joypad hat while your map is active.
---
---  * `hat` (number): Index of the hat that was moved.
---  * `direction8` (number): The new direction of the hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param hat number
---@param direction8 number
---@return boolean
function m:on_joypad_hat_moved(hat,direction8) end

---
---Returns the size of this map in pixels.
---
---  * Return value 1 (number): The width in pixels (always a multiple of 8).
---  * Return value 2 (number): The height in pixels (always a multiple of 8).
---
---
---
---@return number,number
function m:get_size() end

---
---Creates an entity of type [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number): Initial direction of the enemy, between `0` (East) and `3` (South).
---    * `breed` (string): Model of enemy to create.
---    * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this enemy is dead. No value means that the enemy is not saved. If the enemy is saved and was already killed, then no enemy is created. Instead, its [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) is created if it is a saved one.
---    * `treasure_name` (string, optional): Kind of [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) to drop when the enemy is killed (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, then the enemy won't drop anything. If the treasure is not obtainable when the enemy is killed, then nothing is dropped either.
---    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) of this enemy was obtained. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then the enemy won't drop anything.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) or [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html)): The enemy created, except when it is a saved enemy that is already dead. In this case, if the enemy dropped a saved treasure that is not obtained yet, this [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) is created and returned. Otherwise, `nil` is returned.
---
---
---
---Remarks
---    The state of the [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) (alive or dead), the state of its [treasure dropped](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) (obtained or not) and the possessed variant of the [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) dropped (a number) are three independent values that have different meanings and are saved separately.
---
---@param properties table
---@return enemy|pickable treasure
function m:create_enemy(properties) end

---
---Creates an entity of type [custom entity](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) on the map.
---
---  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `direction` (number): Direction of the custom entity, between `0` (East) and `3` (South). This direction will be applied to the entity's sprites if possible.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels (default `16`).
---    * `height` (number): Height of the entity in pixels (default `16`).
---    * `sprite` (string, optional): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the custom entity.
---    * `model` (string, optional): Model of custom entity or `nil`. The model is the name of a Lua script in the `"entities"` directory of your quest. It will define the behavior of your entity. This script will be called with the entity as parameter. Models are useful when you need to create lots of similar entities, especially in different maps. `nil` means no model: in this case, no particular script will be called but you can still define the behavior of your entity in the map script.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([custom entity](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html)): The custom entity created.
---
---
---
---#  Events of a map
---
---Events are callback methods automatically called by the engine if you define them. In the case of maps, they are only called on the current map.
---
---@param properties table
---@return custom_entity
function m:create_custom_entity(properties) end

---
---Returns whether there exists at least one [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) having the specified prefix.
---
---This function can be used for example to checker whether a group of [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) is dead.
---
---  * `prefix` (string): Prefix of the entities to check.
---  * Return value (boolean): `true` if at least one entity with this prefix exists on the map.
---
---
---
---Remarks
---    Equivalent to `map:get_entities_count(prefix) > 0` but faster when there are a lot of entities (because it stops searching as soon as there is a match).
---
---@param prefix string
---@return boolean
function m:has_entities(prefix) end

---
---Creates an entity of type [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) on the map.
---
---  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `treasure_name` (string, optional): Kind of treasure to create (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, or corresponds to a [non-obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable) item, then no entity is created and `nil` is returned.
---    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this pickable treasure was found. No value means that the treasure is not saved. If the treasure is saved and the player already has it, then no entity is be created and `nil` is returned.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html)): The pickable treasure created, or `nil` if the item is not set, not [obtainable](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_is_obtainable), or if the pickable treasure is already found (for a saved one).
---
---
---
---@param properties table
---@return pickable treasure
function m:create_pickable(properties) end

---
---Called when the user moves a finger while this map is active.
---
---  * `finger` (integer): ID of the finger that was pressed.
---  * `x` (integer): The x position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `dx` (integer): The horizontal distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `dy` (integer): The vertical distance moved by finger in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `pressure` (number): The pressure of the finger, normalized between 0 and 1.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---#  Deprecated methods of the type map
---
---The following methods are deprecated and may be removed it future releases.
---
---@param finger integer
---@param x integer
---@param y integer
---@param dx integer
---@param dy integer
---@param pressure number
---@return boolean
function m:on_finger_moved(finger,x,y,dx,dy,pressure) end

---
---Draws a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) on the screen at the given map coordinates.
---
---Warning
---    This method is deprecated since Solarus 1.5.
---
---Use [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) instead.
---
function m:draw_sprite() end

---
---Returns the configuration of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html).
---
---  * Return value (boolean): `false` initially (orange blocks lowered), `true` otherwise (blue blocks lowered).
---
---
---
---@return boolean
function m:get_crystal_state() end

---
---Called when the user releases a mouse button while this map is active.
---
---  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param button string
---@param x integer
---@param y integer
---@return boolean
function m:on_mouse_released(button,x,y) end

---
---Called when the user presses a mouse button while this map is active.
---
---  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * `x` (integer): The x position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the mouse in [quest size](http://www.solarus-games.org/doc/1.6/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param button string
---@param x integer
---@param y integer
---@return boolean
function m:on_mouse_pressed(button,x,y) end

---
---Creates an entity of type [destructible object](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `treasure_name` (string, optional): Kind of [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) to hide in the destructible object (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, then no treasure is placed in the destructible object. If the treasure is not obtainable when the object is destroyed, no pickable treasure is created.
---    * `treasure_variant` (number, optional): Variant of the treasure if any (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) hidden in the destructible object was found. No value means that the treasure (if any) is not saved. If the treasure is saved and the player already has it, then no treasure is put in the destructible object.
---    * `sprite` (string): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the destructible object.
---    * `destruction_sound` (string, optional): Sound to [play](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound) when the destructible object is cut or broken after being thrown. No value means no sound.
---    * `weight` (number, optional): Level of `"lift"` [ability](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) required to lift the object. `0` allows the player to lift the object unconditionally. The special value `-1` means that the object can never be lifted. The default value is `0`.
---    * `can_be_cut` (boolean, optional): Whether the hero can cut the object with the sword. No value means `false`.
---    * `can_explode` (boolean, optional): Whether the object should explode when it is cut, hit by a weapon and after a delay when the hero lifts it. The default value is `false`.
---    * `can_regenerate` (boolean, optional): Whether the object should automatically regenerate after a delay when it is destroyed. The default value is `false`.
---    * `damage_on_enemies` (number, optional): Number of life points to remove from an enemy that gets hit by this object after the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws it. If the value is `0`, enemies will ignore the object. The default value is `1`.
---    * `ground` (string, optional): Ground defined by this entity. The ground is usually `"wall"`, but you may set `"traversable"` to make the object traversable, or for example `"grass"` to make it traversable too but with an additional grass sprite below the hero. The default value is `"wall"`.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([destructible object](http://www.solarus-games.org/doc/1.6/lua_api_destructible.html)): The destructible object created.
---
---
---
---Remarks
---    The state of the [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) placed in the destructible object (obtained or not) and the possessed variant of the [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (a number) are two independent values that have different meanings and are saved separately.
---
---@param properties table
---@return destructible object
function m:create_destructible(properties) end

---
---Returns the index of the highest layer of this map.
---
---  * Return value (number): The highest layer (0 or more).
---
---
---
---@return number
function m:get_max_layer() end

---
---Called when the player presses a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior) while this map is active. You can use this event to override the normal built-in behavior of the game command.
---
---  * `command` (string): Name of the built-in game command that was pressed. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of pressing this game command).
---
---
---
---Remarks
---    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
---
---@param command string
---@return boolean
function m:on_command_pressed(command) end

---
---Changes the world of this map.
---
---The world property remains until the map is destroyed: If you reload the same map again later, the world is reset to the one defined in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files).
---
---  * `world` (string): The new world name to set, or `nil` to set no world.
---
---
---
---@param world string
function m:set_world(world) end

---
---Called when the user presses a joypad button while your map is active.
---
---  * `button` (number): Index of the button that was pressed.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects.
---
---
---
---@param button number
---@return boolean
function m:on_joypad_button_pressed(button) end

---
---Called when the user releases a keyboard key while your map is active.
---
---  * `key` (string): Name of the raw key that was released.
---  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).
---
---
---
---Remarks
---    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [map:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_character_pressed). If you want the corresponding higher-level game command (if any), see [map:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_command_pressed).
---
---@param key string
---@param modifiers table
---@return boolean
function m:on_key_released(key,modifiers) end

---
---Called when the map has just been suspended or resumed.
---
---The map is suspended by the engine in a few cases, like when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is paused or when a dialog is active. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation.
---
---  * `suspended` (boolean): `true` if the map was just suspended, `false` if it was resumed.
---
---
---
---@param suspended boolean
function m:on_suspended(suspended) end

---
---Returns the index of the lowest layer of this map.
---
---  * Return value (number): The lowest layer (0 or less).
---
---
---
---@return number
function m:get_min_layer() end

---
---Called when this map starts (when the player enters it).
---
---  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrives on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).
---
---
---
---@param destination destination
function m:on_started(destination) end

---
---Sets the configuration of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html).
---
---This state persists accross maps of the same [world](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_world). It is reset when the world changes and when the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is reloaded.
---
---  * `state` (boolean): `false` to set the initial configuration (orange blocks lowered), `true` to the modified one (blue blocks lowered).
---
---
---
---@param state boolean
function m:set_crystal_state(state) end

---
---Creates an entity of type [separator](http://www.solarus-games.org/doc/1.6/lua_api_separator.html) on the map.
---
---  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels.
---    * `height` (number): Height of the entity in pixels. One of `width` or `height` must be 16 pixels.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([separator](http://www.solarus-games.org/doc/1.6/lua_api_separator.html)): The separator created.
---
---
---
---@param properties table
---@return separator
function m:create_separator(properties) end

---
---Like [map:open_doors()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_open_doors) or [map:close_doors()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_close_doors), but does not play any sound or any sprite animation.
---
---This function is intended to be called when you don't want the player to notice the change, typically when your map starts (i.e. from the [map:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_started) event).
---
---  * `prefix` (string): Prefix of the name of doors to set.
---  * `open` (boolean, optional): `true` to open the doors, `false` to close them (no value means `true`).
---
---
---
---@param prefix string
---@param open boolean|nil
function m:set_doors_open(prefix,open) end

---
---Creates an entity of type [sensor](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels.
---    * `height` (number): Height of the entity in pixels.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([sensor](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html)): the sensor created.
---
---
---
---@param properties table
---@return sensor
function m:create_sensor(properties) end

---
---Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) of the given type on the map.
---
---The typical usage of this function is: 
---    
---    
---    for entity in map:get_entities_by_type(type) do
---      -- some code related to the entity
---    end
---    
---
---  * `type` (string): Name of an entity type. See [entity:get_type()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_type) for the possible values.
---
---
---
---@param type string
function m:get_entities_by_type(type) end

---
---Creates an entity of type [stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number): Direction where the stairs should be turned between `0` (East of the room) and `3` (South of the room). For stairs inside a single floor, this is the direction of going upstairs.
---    * `subtype` (number): Kind of stairs to create:
---      * `0`: Spiral staircase going upstairs.
---      * `1`: Spiral staircase going downstairs.
---      * `2`: Straight staircase going upstairs.
---      * `3`: Straight staircase going downstairs.
---      * `4`: Small stairs inside a single floor (change the layer of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)).
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html)): the stairs created.
---
---
---
---@param properties table
---@return stairs
function m:create_stairs(properties) end

---
---Creates an entity of type [bomb](http://www.solarus-games.org/doc/1.6/lua_api_bomb.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([bomb](http://www.solarus-games.org/doc/1.6/lua_api_bomb.html)): the bomb created.
---
---
---
---@param properties table
---@return bomb
function m:create_bomb(properties) end

---
---Inverts the configuration of [crystal blocks](http://www.solarus-games.org/doc/1.6/lua_api_crystal_block.html).
---
---Remarks
---    Equivalent to `map:set_crystal_state(not map:get_crystal_state())`.
---
function m:change_crystal_state() end

---
---Creates an entity of type [wall](http://www.solarus-games.org/doc/1.6/lua_api_wall.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels.
---    * `height` (number): Height of the entity in pixels.
---    * `stops_hero` (boolean, optional): `true` to make the wall stop the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html). No value means `false`.
---    * `stops_npcs` (boolean, optional): `true` to make the wall stop [non-playing characters](http://www.solarus-games.org/doc/1.6/lua_api_npc.html). No value means `false`.
---    * `stops_enemies` (boolean, optional): `true` to make the wall stop [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html). No value means `false`.
---    * `stops_blocks` (boolean, optional): `true` to make the wall stop [blocks](http://www.solarus-games.org/doc/1.6/lua_api_block.html). No value means `false`.
---    * `stops_projectiles` (boolean, optional): `true` to make the wall stop projectiles: [thrown objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html), [arrows](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html), the [hookshot](http://www.solarus-games.org/doc/1.6/lua_api_hookshot.html) and [the boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html). No value means `false`.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([wall](http://www.solarus-games.org/doc/1.6/lua_api_wall.html)): the wall created.
---
---
---
---@param properties table
---@return wall
function m:create_wall(properties) end

---
---Creates an entity of type [non-playing character](http://www.solarus-games.org/doc/1.6/lua_api_npc.html) (NPC) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `direction` (number): Initial direction of the NPC's sprite, between `0` (East) and `3` (South).
---    * `subtype` (number): Kind of NPC to create: `1` for a usual NPC who the player can talk to, `0` for a generalized NPC (not necessarily a person). See the [NPC documentation](http://www.solarus-games.org/doc/1.6/lua_api_npc.html) for more details.
---    * `sprite` (string, optional): Name of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the NPC. No value means no sprite (the NPC will then be invisible).
---    * `behavior` (string, optional): What to do when there is an interaction with the NPC.
---      * `"dialog#XXXX"`: Starts the dialog with id `XXXX` when the player talks to this NPC.
---      * `"map"` (default): Forwards events to the map script (for example, calls the [on_interaction()](http://www.solarus-games.org/doc/1.6/lua_api_npc.html#lua_api_npc_on_interaction) event of the NPC).
---      * `"item#XXXX"`: Forwards events to an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) script (for example, calls the [on_interaction()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_npc_interaction) event of the equipment item with id `XXXX`).
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([NPC](http://www.solarus-games.org/doc/1.6/lua_api_npc.html)): the NPC created.
---
---
---
---@param properties table
---@return NPC
function m:create_npc(properties) end

---
---Returns an iterator to all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) whose name has the specified prefix.
---
---The typical usage of this function is: 
---    
---    
---    for entity in map:get_entities("your_prefix") do
---      -- some code related to the entity
---    end
---    
---
---  * `prefix` (string, optional): Prefix of the entities to get. No value means all entities (equivalent to an empty prefix).
---  * Return value (function): An iterator to all entities with this prefix. Entities are returned in Z order (insertion order).
---
---
---
---@param prefix string|nil
---@return function
function m:get_entities(prefix) end

---
---Called when the player released a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior). while this map is active. You can use this event to override the normal built-in behavior of the game command.
---
---  * `command` (string): Name of the built-in game command that was released. Possible commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of releasing this game command).
---
---
---
---Remarks
---    This event is not triggered if you already handled its underlying low-level keyboard or joypad event.
---
---@param command string
---@return boolean
function m:on_command_released(command) end

---
---Creates an entity of type [teletransporter](http://www.solarus-games.org/doc/1.6/lua_api_teletransporter.html) on the map.
---
---  * `properties` (table): A table that describles all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `width` (number): Width of the entity in pixels.
---    * `height` (number): Height of the entity in pixels.
---    * `sprite` (string, optional): Id of the animation set of a [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the teletransporter. No value means no sprite (the teletransporter will then be invisible).
---    * `sound` (string, optional): Sound to [play](http://www.solarus-games.org/doc/1.6/lua_api_audio.html#lua_api_audio_play_sound) when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) uses the teletransporter. No value means no sound.
---    * `transition` (string, optional): Style of transition to play when the hero uses the teletransporter. Must be one of:
---      * `"immediate"`: No transition.
---      * `"fade"`: Fade-out and fade-in effect.
---      * `"scrolling"`: Scrolling between maps. The default value is `"fade"`.
---    * `destination_map` (string): Id of the map to transport to (can be the id of the current map).
---    * `destination` (string, optional): Location on the destination map. Can be the name of a [destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html) entity, the special value `"_same"` to keep the hero's coordinates, or the special value `"_side"` to place on hero on the corresponding side of an adjacent map (normally used with the scrolling transition style). No value means the default destination entity of the map.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([teletransporter](http://www.solarus-games.org/doc/1.6/lua_api_teletransporter.html)): The teletransporter created.
---
---
---
---@param properties table
---@return teletransporter
function m:create_teletransporter(properties) end

---
---Creates an entity of type [treasure chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html) on the map.
---
---  * `properties` (table): A table that describes all properties of the entity to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity or `nil`. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique.
---    * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---    * `x` (number): X coordinate on the map.
---    * `y` (number): Y coordinate on the map.
---    * `treasure_name` (string, optional): Kind of treasure to place in the chest (the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)). If this value is not set, then the chest will be empty. If the treasure is not obtainable when the hero opens the chest, it becomes empty.
---    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](http://www.solarus-games.org/doc/1.6/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](http://www.solarus-games.org/doc/1.6/lua_api_game.html) whether this chest is open. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then no treasure is placed in the chest (the chest will appear open).
---    * `sprite` (string): Name of the animation set of the [sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) to create for the chest. The sprite must have animations `"open"` and `"closed"`.
---    * `opening_method` (string, optional): Specifies the permissions for the hero to open the chest. Must be one of:
---      * `"interaction"` (default): Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it.
---      * `"interaction_if_savegame_variable"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that a specific savegame variable is set.
---      * `"interaction_if_item"`: Can be opened by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) in front of it, provided that the player has a specific [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html).
---    * `opening_condition` (string, optional): The condition required to open the chest. Only for opening methods `"interaction_if_savegame_variable"` and `"interaction_if_item"`.
---      * For opening method `"interaction_if_savegame_variable"`, it must be the name of a savegame variable. The [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) will be allowed to open the chest if this saved value is either `true`, an integer greater than zero or a non-empty string.
---      * For opening method `"interaction_if_item"`, it must be the name of an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html). The hero will be allowed to open the chest if he has that item and, for items with an amount, if the amount is greater than zero.
---      * For the default opening method (`"interaction"`), this setting has no effect.
---    * `opening_condition_consumed` (boolean, optional): Whether opening the chest should consume the savegame variable or the [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) that was required. The default setting is `false`. If you set it to `true`, the following rules are applied when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) successfully opens the chest:
---      * For opening method `"interaction_if_savegame_variable"`, the savegame variable that was required is reset to `false`, `0` or `""` (depending on its type).
---      * For opening method is `"interaction_if_item"`, the equipment item that was required is removed. This means setting its [possessed variant](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_set_variant) to `0`, unless it has an associated amount: in this case, the amount is decremented.
---    * `cannot_open_dialog` (string, optional): Id of the dialog to show if the hero fails to open the chest. If you don't set this value, no dialog is shown.
---    * `enabled_at_start` (boolean, optional): Whether the entity should be initially enabled. The default value is `true`.
---    * `properties` (table, optional): Additional user-defined properties. See [entity:set_properties()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_properties) for the specification.
---  * Return value ([chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html)): The treasure chest created.
---
---
---
---Remarks
---    The state of the [treasure chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html) (obtained or not) and the possessed variant of its [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) are two independent values that have different meanings and are saved separately.
---
---@param properties table
---@return chest
function m:create_chest(properties) end

---
---Returns whether there currently exists a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) with the specified name on the map.
---
---  * `name` (string): Name of the [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) to check.
---  * Return value (boolean): `true` if such an entity exists.
---
---
---
---Remarks
---    Equivalent to `map:get_entity(name) ~= nil` (but a bit lighter because it avoids to export the entity to Lua).
---
---@param name string
---@return boolean
function m:has_entity(name) end

---
---Returns the kind of ground (terrain) of a point.
---
---The ground is defined by [tiles](http://www.solarus-games.org/doc/1.6/lua_api_tile.html) (and other entities that may change it like [dynamic tiles](http://www.solarus-games.org/doc/1.6/lua_api_dynamic_tile.html)) that overlap this point.
---
---  * `x` (number): X coordinate of a point of the map.
---  * `y` (number): Y coordinate of a point of the map.
---  * `layer` (number): The layer, between [map:get_min_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_max_layer).
---  * Return value (string): The kind of ground. The possible values are the same as the `ground` property of the [tileset file](http://www.solarus-games.org/doc/1.6/quest_tileset_data_file.html): `"empty"`, `"traversable"`, `"wall"`, `"low_wall"`, `"wall_top_right"`, `"wall_top_left"`, `"wall_bottom_left"`, `"wall_bottom_right"`, `"wall_top_right_water"`, `"wall_top_left_water"`, `"wall_bottom_left_water"`, `"wall_bottom_right_water"`, `"deep_water"`, `"shallow_water"`, `"grass"`, `"hole"`, `"ice"`, `"ladder"`, `"prickles"` or `"lava"`.
---
---
---
---@param x number
---@param y number
---@param lay number
---@return string
function m:get_ground(x,y,lay) end

_G.map = m

return m