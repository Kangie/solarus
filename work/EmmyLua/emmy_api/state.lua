---@class state
---
---This module provides a datatype `state` that represents a custom state allowing advanced customization of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
---
local m = {}

---
---Called when the [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) of the entity was stopped because of an obstacle during this state.
---
---When an obstacle is reached, this event is called instead of [state:on_position_changed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_position_changed).
---
---  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement of the entity.
---
---
---
function m:on_obstacle_reached() end

---
---Sets whether this state remembers the last solid position of the entity as a place to come back to later if it falls into bad ground like holes or lava.
---
---The default value is `true`.
---
---  * `can_come_from_bad_ground` (boolean): `true` if solid positions in this state should be considered as places to come back to when falling into bad grounds.
---
---
---
function m:set_can_come_from_bad_ground() end

---
---Called just after the entity is drawn on the map during this state.
---
---You may display additional things above the entity. To do so, you can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).
---
---  * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera where this entity is being drawn.
---
---
---
---@param camera camera
function m:on_post_draw(camera) end

---
---Called at each cycle of the main loop while this state is active.
---
---Remarks
---    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html) and other events.
---
function m:on_update() end

---
---Sets whether the entity can swing the sword during this state.
---
---The default value is `true`.
---
---  * `can_use_sword` (boolean): `true` to allow to use the sword.
---
---
---
---@param can_use_sword boolean
function m:set_can_use_sword(can_use_sword) end

---
---Returns whether the entity should be visible during this state.
---
---  * `visible` (boolean, optional): `true` to make the entity visible during this state, `false` to hide it. No value means `true`.
---
---
---
---@param visible boolean|nil
function m:set_visible(visible) end

---
---Returns whether the player controls the movement of the entity during this state.
---
---  * Return value (boolean): `true` if the player controls the movement.
---
---
---
---@return boolean
function m:get_can_control_movement() end

---
---When a map begins during this state, called when the opening transition effect finishes.
---
---  * `map` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The map.
---  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrived on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).
---
---
---
---@param map map
---@param destination destination
function m:on_map_opening_transition_finished(map,destination) end

---
---Returns the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) of the entity controlled by this state.
---
---  * Return value ([game](http://www.solarus-games.org/doc/1.6/lua_api_game.html)): The game, or `nil` if the state is not associated to an entity yet.
---
---
---
---@return game
function m:get_game() end

---
---Called when the user moves a joypad axis during this state.
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
---Called just before the entity is drawn on the map during this state.
---
---You may display additional things below the entity. To do so, you can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).
---
---  * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): The camera where this entity is being drawn.
---
---
---
---@param camera camera
function m:on_pre_draw(camera) end

---
---Called when the user releases a mouse button during this state.
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
---Returns whether the entity can try to push the obstacles it is facing.
---
---  * Return value (boolean): `true` if pushing is allowed in this state.
---
---
---
---@return boolean
function m:get_can_push() end

---
---Returns whether the entity can stop attacks with the shield during this state.
---
---  * Return value (boolean): `true` if the entity can stop attacks with the shield.
---
---
---
---@return boolean
function m:get_can_use_shield() end

---
---Changes how this entity is drawn during this state.
---
---You can use this to replace the built-in draw implementation of the engine by your own function, if the default behavior does not fit your needs. To do so, your function can either call [map:draw_visual()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_draw_visual) or draw on [camera:get_surface()](http://www.solarus-games.org/doc/1.6/lua_api_camera.html).
---
---  * `draw_override` (function or nil): The draw function, or `nil` to restore the built-in drawing. Your function will receive the following parameters:
---    * `state` (state): The custom state of the entity to draw.
---    * `camera` ([camera](http://www.solarus-games.org/doc/1.6/lua_api_camera.html)): Camera where the entity is drawn.
---
---
---
---Remarks
---    Even when you set a draw override, events [state:on_pre_draw()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_pre_draw) and [state:on_post_draw()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_post_draw) are still called.
---
---@param draw_override function|nil
function m:set_draw_override(draw_override) end

---
---Returns whether the entity can take [stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html) during this state.
---
---  * Return value (boolean): `true` if the entity can take stairs during this state.
---
---
---
---@return boolean
function m:get_can_use_stairs() end

---
---Sets whether [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) can be picked during this state.
---
---The default value is `true`.
---
---  * `can_pick_treasure` (boolean): `true` to allow the entity to pick treasures during this state.
---
---
---
---@param can_pick_treasure boolean
function m:set_can_pick_treasure(can_pick_treasure) end

---
---Returns the delay before jumping when taking a jumper during this state.
---
---  * Return value (number): The jump delay in milliseconds (`0` means no delay).
---
---
---
---@return number
function m:get_jumper_delay() end

---
---Called when the player presses a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior) during this state. You can use this event to override the normal built-in behavior of the game command.
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
---Called when this state starts.
---
---  * `previous_state_name` (string or nil): Name of the state that was active before. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the possible values. This value is `nil` if there was no state before (only possible for the first state of an entity).
---  * `previous_state` (state or nil): Custom state object that was active before, if it was a custom one, `nil` otherwise.
---
---
---
---@param previous_state_name string|nil
---@param previous_state state|nil
function m:on_started(previous_state_name,previous_state) end

---
---Returns the draw function of this state.
---
---See [state:set_draw_override()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_set_draw_override) for more details.
---
---  * Return value (function or nil): The draw function, or `nil` if the draw function was not overridden.
---
---
---
---@return function|nil
function m:get_draw_override() end

---
---Sets what happens during this state to an object that was [carried](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) the previous state.
---
---  * `action` (string): One of:
---    * `"throw"` (default): The carried object is automatically thrown.
---    * `"remove"`: The carried object is silently destroyed.
---    * `"keep"`: The carried object continues to be carried.
---
---
---
---#  Events of a state
---
---Events are callback methods automatically called by the engine if you define them. In the case of states, they are only called on an active state.
---
---@param action string
function m:set_carried_object_action(action) end

---
---Returns whether the given kind of ground affects the entity during this state.
---
---  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
---  * Return value (boolean): `true` if this ground affects the entity during this state.
---
---
---
---@param ground string
---@return boolean
function m:is_affected_by_ground(ground) end

---
---Sets whether the player controls the movement of the entity during this state.
---
---The default value is `true`. If this setting is `true`, a movement is automatically created on the entity and this movement reacts to the player's input. If you set this to `false`, then the entity has no automatic movement during this state.
---
---  * `can_control_movement` (boolean): `true` to let the player control the movement.
---
---
---
---@param can_control_movement boolean
function m:set_can_control_movement(can_control_movement) end

---
---Sets the delay before jumping when taking a jumper during this state.
---
---This only has an effect if [state:get_can_use_jumper()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_get_can_use_jumper) is `true`.
---
---The default value is `200` ms.
---
---  * `jumper_delay` (number): The jump delay in milliseconds (`0` for no delay).
---
---
---
---@param jumper_delay number
function m:set_jumper_delay(jumper_delay) end

---
---Sets whether the entity is affected by gravity during this state.
---
---If yes, the entity will fall to the lower layer when the ground below it is `"empty"`.
---
---The default value is `true`. You should typically set this to `false` when the entity is jumping of flying.
---
---  * `gravity_enabled` (boolean): `true` to make the entity affected by gravity during this state.
---
---
---
---@param gravity_enabled boolean
function m:set_gravity_enabled(gravity_enabled) end

---
---Called when a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) is started on the entity controlled by this state.
---
---  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement that was just started on the entity.
---
---
---
---@param movement movement
function m:on_movement_started(movement) end

---
---Called when the kind of [ground](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) on the map below the entity controlled by this state has changed. It may change because the entity is moving, or when because another entity changes it.
---
---  * `ground_below` (string): The kind of ground at the [ground point](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_ground_position) of the entity controlled by this state. `nil` means empty, that is, there is no ground at this point on the current layer.
---
---
---
---@param ground_below string
function m:on_ground_below_changed(ground_below) end

---
---Returns whether this state remembers the last solid position of the entity as a place to come back to later if it falls into bad ground like holes or lava.
---
---  * Return value (boolean): `true` if solid positions in this state are considered as places to come back to when falling into bad grounds.
---
---
---
---@return boolean
function m:get_can_come_from_bad_ground() end

---
---Called when the map stops (when the player leaves it) during this state.
---
function m:on_map_finished() end

---
---Called when the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) has just been suspended or resumed.
---
---The entity is suspended by the engine in a few cases, like when the [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) is paused or when a dialog is active. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation.
---
---  * `suspended` (boolean): `true` if the entity was just suspended, `false` if it was resumed.
---
---
---
---@param suspended boolean
function m:on_suspended(suspended) end

---
---Called when the user releases a finger during this state.
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
---Returns whether this state is started, that is, if it was activated on an entity (see [hero:start_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_state)) and is not finished yet.
---
---  * Return value (boolean): `true` if the state is started.
---
---
---
---@return boolean
function m:is_started() end

---
---Returns whether an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) can be used during this state.
---
---  * Return value (boolean): `true` if the player can use equipment items during this state.
---
---
---
---@return boolean
function m:get_can_use_item() end

---
---Sets whether the entity can traverse other entities in this state.
---
---By default, this depends on the other entities: for example, [sensors](http://www.solarus-games.org/doc/1.6/lua_api_sensor.html) can be traversed by default while [doors](http://www.solarus-games.org/doc/1.6/lua_api_door.html) cannot unless they are open.
---
---  * `entity_type` (string, optional): A type of entity. See [entity:get_type()](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_get_type) for the possible values. If not specified, the setting will be applied to all entity types for which you don't override this setting.
---  * `traversable` (boolean, function or `nil`): Whether the entity controlled by this state can traverse the other entity type. This can be:
---    * A boolean: `true` to allow your entity to traverse entities of the specified type, `false` otherwise.
---    * A function: Custom test. This allows you to decide dynamically. The function takes your entity (the one controlled by this state) and then the other entity as parameters, and should return `true` if you allow your entity to traverse the other entity. When your entity has a [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html), this function will be called every time it is about to overlap an entity of the specified type.
---    * `nil:` Clears any previous setting for this entity type and therefore restores the default value.
---
---
---
---@param entity_type string|nil
---@param traversable boolean|function|nil
function m:set_can_traverse(entity_type,traversable) end

---
---Returns the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) controlled by this state.
---
---  * Return value ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The entity controlled by this state (which can only by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html)), or `nil` if the state is not associated to an entity yet.
---
---
---
---Remarks
---    Even if the state is finished, this method still returns the entity that was controlled.
---
---@return entity
function m:get_entity() end

---
---Returns the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) of the entity controlled by this state.
---
---  * Return value ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The map, or `nil` if the state is not associated to an entity yet.
---
---
---
---@return map
function m:get_map() end

---
---Returns whether the entity can be hurt during this state.
---
---  * Return value (boolean): `true` if the entity can be hurt during this state.
---
---
---
---@return boolean
function m:get_can_be_hurt() end

---
---Called when the user moves a joypad hat during this state.
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
---Called when the user presses a mouse button during this state.
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
---Called when the coordinates of the entity controlled by this state have just changed.
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
---Sets whether the entity can be hurt during this state.
---
---The default value is `true`.
---
---  * `can_be_hurt` (boolean): Whether the entity controlled by this state can be hurt.
---
---
---
---@param can_be_hurt boolean
function m:set_can_be_hurt(can_be_hurt) end

---
---Sets whether the entity can traverse the given kind of ground during this state.
---
---By default, this depends on the the ground: for example, the `"grass"` ground can be traversed by default while the `"low wall"` ground cannot.
---
---  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
---  * `traversable` (boolean): Whether the entity can traverse this kind of ground during this state.
---
---
---
---@param ground string
---@param traversable boolean
function m:set_can_traverse_ground(ground,traversable) end

---
---Called when the user moves a finger during this state.
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
---@param finger integer
---@param x integer
---@param y integer
---@param dx integer
---@param dy integer
---@param pressure number
---@return boolean
function m:on_finger_moved(finger,x,y,dx,dy,pressure) end

---
---Called when the user presses a finger during this state.
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
---Sets whether the entity can start pushing the obstacles it is facing.
---
---If `true`, the entity will go to state `"pushing"` when it reaches an obstacle and continues to move toward this obstacle for a configurable [delay](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_get_pushing_delay). This does not mean that the obstacle being pushed will actually move ([blocks](http://www.solarus-games.org/doc/1.6/lua_api_block.html) can move when being pushed, but other entities usually cannot).
---
---The default value is `true`.
---
---  * `can_push` (boolean): `true` to allow to push in this state.
---
---
---
---Remarks
---    Ability [pushing](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_get_ability) is necessary so that the hero can push.
---
---@param can_push boolean
function m:set_can_push(can_push) end

---
---Called when the user releases a keyboard key during this state.
---
---  * `key` (string): Name of the raw key that was released.
---  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).
---
---
---
---Remarks
---    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed). If you want the corresponding higher-level game command (if any), see [state:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_command_pressed).
---
---@param key string
---@param modifiers table
---@return boolean
function m:on_key_released(key,modifiers) end

---
---Called when the user releases a joypad button during this state.
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
---Sets the description of this state.
---
---The engine does nothing special with this description, but it may help you distinguish states.
---
---  * `description` (string or nil): The description to set, or `nil` to set no description.
---
---
---
---@param description string|nil
function m:set_description(description) end

---
---Called when the user presses a joypad button during this state.
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
---Sets whether the player controls the direction of entity's sprites during this state.
---
---The default value is `true`. If you set this to `false`, then the entity's sprites no longer automatically take the direction pressed by the player.
---
---  * `can_control_direction` (boolean): `true` to let the player control the sprites direction. No value means `true`.
---
---
---
---@param can_control_direction boolean
function m:set_can_control_direction(can_control_direction) end

---
---Called when the user enters text during this state.
---
---  * `character` (string): A utf-8 string representing the character that was pressed.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).
---
---
---
---Remarks
---    When a character key is pressed, two events are called: [state:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_key_pressed) (indicating the raw key) and [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed) (indicating the utf-8 character). If your script needs to input text from the user, [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
---
---@param character string
---@return boolean
function m:on_character_pressed(character) end

---
---Called when the user presses a keyboard key during this state.
---
---  * `key` (string): Name of the raw key that was pressed.
---  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation to the [commands](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands).
---
---
---
---Remarks
---    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [state:on_character_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_character_pressed). If you want the corresponding higher-level game command (if any), see [state:on_command_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_on_command_pressed).
---
---@param key string
---@param modifiers table
---@return boolean
function m:on_key_pressed(key,modifiers) end

---
---Sets whether the entity can stop attacks with the shield during this state.
---
---The default value is `true`.
---
---  * `can_use_shield` (boolean): `true` if the entity can stop attacks with the shield.
---
---
---
---@param can_use_shield boolean
function m:set_can_use_shield(can_use_shield) end

---
---Called when the entity has just attacked an enemy during this state, even if the attack was not successful.
---
---  * `enemy` ([enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html)): The attacked enemy.
---  * `enemy_sprite` ([sprite](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html)): Sprite of the enemy that received the attack, or `nil` if the attack does not come from a pixel-precise collision test.
---  * `attack` (string): How the enemy was attacked. See [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) for the possible values.
---  * `consequence` (number, string or function): How the enemy reacted to the attack. See [enemy:set_attack_consequence()](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) for the possible values.
---
---
---
---@param enemy enemy
---@param enemy_sprite sprite
---@param attack string
---@param consequence number|string|function
function m:on_attacked_enemy(enemy,enemy_sprite,attack,consequence) end

---
---Returns whether [pickable treasures](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html) can be picked during this state.
---
---  * Return value (boolean): `true` if pickable treasures can be picked during this state.
---
---
---
---@return boolean
function m:get_can_pick_treasure() end

---
---Called when some characteristics of the entity's [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) (like the speed or the angle) have just changed during this state.
---
---  * `movement` ([movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html)): The movement of the entity.
---
---
---
---@param movement movement
function m:on_movement_changed(movement) end

---
---Sets whether a kind of ground affects the entity during this state.
---
---  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
---  * `affected` (boolean): `true` to make this ground affect the entity during this state.
---
---
---
---@param ground string
---@param affected boolean
function m:set_affected_by_ground(ground,affected) end

---
---Returns whether the entity is visible during this state.
---
---  * Return value (boolean): `true` if the entity is visible during this state, `false` if it is hidden.
---
---
---
---@return boolean
function m:is_visible() end

---
---Called when this state finishes.
---
---  * `next_state_name` (string or nil): Name of the state that is about to be active after yours. See [hero:get_state()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_get_state) for the possible values. This value is `nil` if there is no state after yours (only possible if the entity is being removed).
---  * `next_state` (state or nil): Custom state object about to start, if it is a custom one, `nil` otherwise.
---
---
---
---@param next_state_name string|nil
---@param next_state state|nil
function m:on_finished(next_state_name,next_state) end

---
---Returns the description of this state.
---
---  * Return value (string): The description, or `nil` if no description was set.
---
---
---
---@return string
function m:get_description() end

---
---Returns what happens during this state to an object that was [carried](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html) the previous state.
---
---  * Return value (string): One of:
---    * `"throw"` (default): The carried object is automatically thrown.
---    * `"remove"`: The carried object is silently destroyed.
---    * `"keep"`: The carried object continues to be carried.
---
---
---
---@return string
function m:get_carried_object_action() end

---
---Returns whether the player controls the direction of entity's sprites during this state.
---
---  * Return value (boolean): `true` if the player controls the sprites direction.
---
---
---
---@return boolean
function m:get_can_control_direction() end

---
---Sets whether the entity can take [jumpers](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html) during this state.
---
---The default value is `true`.
---
---  * `can_use_jumper` (boolean): `true` to allow the entity to take jumpers during this state.
---
---
---
---@param can_use_jumper boolean
function m:set_can_use_jumper(can_use_jumper) end

---
---Returns whether the entity can activate [jumpers](http://www.solarus-games.org/doc/1.6/lua_api_jumper.html) during this state.
---
---  * Return value (boolean): `true` if the entity can take jumpers during this state.
---
---
---
---@return boolean
function m:get_can_use_jumper() end

---
---Sets whether the entity can take [stairs](http://www.solarus-games.org/doc/1.6/lua_api_stairs.html) during this state.
---
---The default value is `true`.
---
---  * `can_use_stairs` (boolean): `true` to allow the entity to take stairs during this state.
---
---
---
---@param can_use_stairs boolean
function m:set_can_use_stairs(can_use_stairs) end

---
---Called when the [movement](http://www.solarus-games.org/doc/1.6/lua_api_movement.html) of the entity controlled by this state is finished (if there is an end).
---
function m:on_movement_finished() end

---
---Returns whether the entity is affected by gravity during this state.
---
---If yes, the entity will fall to the lower layer when the ground below it is `"empty"`.
---
---  * Return value (boolean): `true` if the entity is affected by gravity during this state.
---
---
---
---@return boolean
function m:is_gravity_enabled() end

---
---Sets the delay before pushing when moving towards an obstacle during this state.
---
---This only has an effect if [state:get_can_push()](http://www.solarus-games.org/doc/1.6/lua_api_state.html#lua_api_state_get_can_push) is `true`.
---
---The default value is `1000` ms.
---
---  * `pushing_delay` (number): The pushing delay in milliseconds (`0` for no delay).
---
---
---
---@param pushing_delay number
function m:set_pushing_delay(pushing_delay) end

---
---Returns the delay before pushing when moving towards an obstacle during this state.
---
---  * Return value (number): The pushing delay in milliseconds.
---
---
---
---@return number
function m:get_pushing_delay() end

---
---Called when the player released a [game command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior). during this state. You can use this event to override the normal built-in behavior of the game command.
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
---Returns whether the entity can swing the sword during this state.
---
---  * Return value (boolean): `true` if the entity can use the sword.
---
---
---
---@return boolean
function m:get_can_use_sword() end

---
---Sets whether an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) can be used during this state.
---
---The default value is `true`.
---
---  * `can_use_item` (boolean): `true` to allow the player to use equipment items during this state.
---
---
---
---@param can_use_item boolean
function m:set_can_use_item(can_use_item) end

---
---Returns whether the entity can traverse the given kind of ground during this state.
---
---  * `ground` (string): A kind of ground. See [map:get_ground()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_get_ground) for the possible values.
---  * Return value (boolean): `true` if the ground can be traversed during this state.
---
---
---
---@param ground string
---@return boolean
function m:get_can_traverse_ground(ground) end

---
---Called when a map starts (when the player enters it) during this state.
---
---  * `map` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html)): The new map.
---  * `destination` ([destination](http://www.solarus-games.org/doc/1.6/lua_api_destination.html)): The destination entity from where the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) arrives on the map, or `nil` if he used another way than a destination entity (like the side of the map or direct coordinates).
---
---
---
---@param map map
---@param destination destination
function m:on_map_started(map,destination) end

_G.state = m

return m