---@class hero : entity
---
---The hero is the character controlled by the player. There is always exactly one hero on the current map. The hero is automatically created by the engine: you cannot create or remove him.
---
local m = {}

---
---Returns the [carried object](https://doxygen.solarus-games.org/latest/lua_api_carried_object.html) the hero is currently lifting, carrying or throwing, if any.
---
---  * Return value ([carried object](https://doxygen.solarus-games.org/latest/lua_api_carried_object.html)): The current carried object or `nil`.
---
---
---
---@return carried_object
function m:get_carried_object() end

---
---Makes the hero move with the specified path and a walking animation. The player cannot control him during the movement.
---
---  * `path` (string): The path as a string sequence of integers. Each value is a number between 0 and 7 that represents a step (move of 8 pixels) in the path. 0 is East, 1 is North-East, etc.
---  * `loop` (boolean, optional): `true` to repeat the path once it is done (default `false`).
---  * `ignore_obstacles` (boolean, optional): `true` to allow the hero to traverse obstacles during this movement (default `false`). Make sure the movement does not end inside an obstacle.
---
---
---
---@param path string
---@param loop boolean|nil
---@param ignore_obstacles boolean|nil
function m:walk(path,loop,ignore_obstacles) end

---
---Makes the hero shoot a [boomerang](https://doxygen.solarus-games.org/latest/lua_api_boomerang.html).
---
---  * `max_distance` (number): Maximum distance of the boomerang's movement in pixels.
---  * `speed` (number): Speed of the boomerang's movement in pixels per second.
---  * `tunic_preparing_animation` (string): Name of the animation that the hero's tunic sprite should take while preparing the boomerang.
---  * `sprite_name` (string): Sprite animation set to use to draw the boomerang then.
---
---
---
---@param max_distance number
---@param speed number
---@param tunic_preparing_animation string
---@param sprite_name string
function m:start_boomerang(max_distance,speed,tunic_preparing_animation,sprite_name) end

---
---Makes the hero jump towards the specified direction.
---
---  * `direction8` (number): Direction of the jump, between `0` and `7` (see [jump_movement:set_direction8()](https://doxygen.solarus-games.org/latest/lua_api_jump_movement.html#lua_api_jump_movement_set_direction8)).
---  * `distance` (number): Distance of the jump in pixels (see [jump_movement:set_distance()](https://doxygen.solarus-games.org/latest/lua_api_jump_movement.html#lua_api_jump_movement_set_distance)).
---  * `ignore_obstacles` (boolean, optional): `true` to allow the hero to traverse obstacles during this movement (default `false`). Make sure the movement does not end inside an obstacle.
---
---
---
---@param direction8 number
---@param distance number
---@param ignore_obstacles boolean|nil
function m:start_jumping(direction8,distance,ignore_obstacles) end

---
---Returns the name of the sprite representing the hero's body.
---
---  * Return value (string): The [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) animation set id of the hero's tunic.
---
---
---
---@return string
function m:get_tunic_sprite_id() end

---
---Starts a [custom state](https://doxygen.solarus-games.org/latest/lua_api_state.html) on the hero.
---
---Custom states allow advanced customization of the hero's behavior. After you call this method, the hero state string as returned by [hero:get_state()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) is `"custom"`. Use [hero:get_state_object()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state_object) to get the actual custom state object.
---
function m:start_state() end

---
---Forgets a position that was previously memorized by [hero:save_solid_ground()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_save_solid_ground) (if any).
---
---The initial behavior is restored: the hero will now get back to where he was just before falling, instead going to of a memorized position.
---
---This is equivalent to `hero:save_solid_ground(nil)`.
---
function m:reset_solid_ground() end

---
---Returns the current custom state object of the hero, if any.
---
---  * Return value ([state](https://doxygen.solarus-games.org/latest/lua_api_state.html)) : The custom state, or `nil` if the current state is not a custom one.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---The hero is a particular [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, he inherits all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type hero
---
---The following events are specific to the hero.
---
---Recall that the hero persists when the player goes to another map, and so do the events defined on the hero.
---
function m:get_state_object() end

---
---Sets the direction of the hero's [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html).
---
---  * `direction4` (number): The direction of the hero's sprites, between `0` (East) and 3 (South).
---
---
---
---Remarks
---    The direction of the hero's sprites may be different from both the direction pressed by the [player's](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_commands_direction) commands" and from the actual direction of the hero's \ref lua_api_movement "movement".
---
---@param direction4 number
function m:set_direction(direction4) end

---
---Sets a position to go back to if the hero falls into a hole or other bad ground.
---
---This replaces the usual behavior which is going back to the last solid position before the fall.
---
---The position can be specified either as coordinates and a layer, or as a function that returns coordinates and a layer. Using a function allows to decide the position at the last moment.
---
---To memorize a position directly:
---
---  * `x` (number, optional): X coordinate to memorize (no value means the current position).
---  * `y` (number, optional): Y coordinate to memorize (no value means the current position).
---  * `layer` (number, optional): Layer to memorize (no value means the current position).
---
---
---
---To set a function that indicates the position to go back to:
---
---  * `callback` (function): A function to be called whenever the hero falls into bad ground. The function should return 2 or 3 values: x, y and optionally the layer (no layer value means keeping the layer unchanged). A `nil` value unsets any position or function that was previously set.
---
---
---
---@param x number|nil
---@param y number
---@param lay number
function m:save_solid_ground(x,y,lay) end

---
---Called when the state of the hero has just changed.
---
---  * `new_state_name` (string): Name of the new state. See [hero:get_state()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) for the list of possible state names.
---
---
---
---Remarks
---    This event is called even for the initial state of the hero, right after [game:on_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_started). This initial state is always `"free"`.
---
---@param new_state_name string
function m:on_state_changed(new_state_name) end

---
---Called when the state of the hero is about to change.
---
---  * `state_name` (string): Name of the current built-in state. See [hero:get_state()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) for the list of possible built-in states.
---  * `next_state_name` (string): Name of the built-in state about to start. See [hero:get_state()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) for the list of possible built-in states.
---
---
---
---@param state_name string
---@param next_state_name string
function m:on_state_changing(state_name,next_state_name) end

---
---Makes the hero run.
---
function m:start_running() end

---
---Makes the hero use an [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html).
---
---The [item:on_using()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_on_using) event will be called and the player won't be able to control the hero until you call [item:set_finished()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_set_finished). See the documentation of [equipment items](https://doxygen.solarus-games.org/latest/lua_api_item.html) for more information.
---
---This function does the same as what happens when the player presses a game [command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) corresponding to this equipment item. You can use it to trigger the item from your script instead of from a game command.
---
---If the player is not allowed to use the item now (because he does not have it, because the item cannot be used explicitly, or because the hero is currently busy in another state), then nothing happens.
---
---  * `item` ([item](https://doxygen.solarus-games.org/latest/lua_api_item.html)): The equipment item to start using.
---
---
---
---@param item item
function m:start_item(item) end

---
---Same as [hero:start_hurt(source_x, source_y, damage)](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_hurt), but specifying the source coordinates as an optional entity and possibly its sprite.
---
---  * `source_entity` ([map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html), optional): Whatever hurts the hero. The coordinates of this source entity are used to push the hero away from that source. No value means that the hero will not be pushed away.
---  * `source_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html), optional): Which sprite of the source entity is hurting the hero. If you set this value, the hero will be pushed away from the origin of this sprite instead of from the origin of the source entity. Most of the time, you don't need to set this parameter.
---  * `damage:` Base number of life points to remove (possibly `0`). This number will be divided by the [tunic](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) level of the player, unless you override this default calculation in [hero:on_taking_damage()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_on_taking_damage).
---
---
---
---@param source_entity entity|nil
---@param source_sprite sprite|nil
---@param damage number
function m:start_hurt(source_entity,source_sprite,damage) end

---
---Makes the hero throw a [hookshot](https://doxygen.solarus-games.org/latest/lua_api_hookshot.html).
---
function m:start_hookshot() end

---
---Returns the direction of the hero's [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html).
---
---  * Return value (number): The direction of the hero's sprites, between `0` (East) and 3 (South).
---
---
---
---Remarks
---    The direction of the hero's sprites may be different from both the direction pressed by the [player's](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_commands_direction) commands" and from the actual direction of the hero's \ref lua_api_movement "movement".
---
---@return number
function m:get_direction() end

---
---Changes the sound to play when the hero uses the sword.
---
---By default, the sound used for the sword is `"swordX"`, where X is the [sword level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability), or no sound if the sword level is `0`.
---
---You can use this function if you want another sound to be played.
---
---  * `sound_id` (string): The sound id of the hero's sword. An empty string means no sword sound.
---
---
---
---@param sound_id string
function m:set_sword_sound_id(sound_id) end

---
---Makes the hero grab the obstacle he is facing.
---
---This function does the same as what happens when the player presses the `"action"` game [command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) while facing an obstacle. You can use it to start the grabbing state from your script instead of from a game command.
---
function m:start_grabbing() end

---
---Called when the hero is hurt and should take damages.
---
---This happens usually after a collision with an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) or when you call [hero:start_hurt()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_hurt).
---
---This event allows you to override what happens when the hero takes damage. By default, if you don't define this event, the hero loses some life as follows. The life lost is the damage inflicted by the attacker divided by the [tunic level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) of the player, with a minimum of `1` (unless the initial damage was already `0`).
---
---You can define this event if you need to change how the hero takes damage, for example if you want the [shield level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) to give better resistance to injuries.
---
---  * `damage` (number): Damage inflicted by the attacker, no matter if this was an enemy or a call to [hero:start_hurt()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_hurt). 
---
---
---
---@param damage number
function m:on_taking_damage(damage) end

---
---Changes the animation of the hero's sprites.
---
---The hero has several [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html), that are normally displayed or not depending on his [state](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) and his [abilities](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability):
---
---  * the body (the tunic),
---  * the shield,
---  * the sword,
---  * the sword stars,
---  * the trail of dust (by default, only shown when running).
---
---
---
---The animation of all these sprites is usually managed by the engine to represent the current state of the hero. You can use this function to customize the animation. This allows you to implement custom actions that are not provided by the built-in states. Make sure that you don't call this function when the hero is not already doing a particular action (like pushing something or attacking), unless you know what you are doing.
---
---All sprites of the hero that have an animation with the specified name take the animation. The ones that don't have such an animation are not displayed.
---
---  * `animation` (string): Name of the animation to set to hero sprites.
---  * `callback` (function, optional): A function to call when the animation ends (on the tunic sprite). If the animation loops, or is replaced by another animation before it ends, then the function will never be called.
---
---
---
---@param animation string
---@param callback function|nil
function m:set_animation(animation,callback) end

---
---Returns the name of the sprite representing the hero's sword.
---
---  * Return value (string): The [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) animation set id of the hero's sword.
---
---
---
---@return string
function m:get_sword_sprite_id() end

---
---Gives a treasure to the player. The hero will brandish the treasure as follows.
---
---The hero sprites take the animation `"treasure"`. The treasure is displayed above the hero, as the sprite `"entities/items"` with animation `treasure_name` and direction `treasure_variant - 1`. If this sprite, this animation or this direction do not exist, then no treasure sprite is displayed above the hero.
---
---If a dialog called `"_treasure.treasure_name.treasure_variant"` exists, then this dialog is displayed during the brandishing animation. For example, calling `hero:start_treasure("heart", 1)` will automatically show the dialog `_treasure.heart.1`.
---
---  * `treasure_name` (string, optional): Kind of treasure to give (the name of an [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html)). The treasure must be an [obtainable](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_is_obtainable) item.
---  * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](https://doxygen.solarus-games.org/latest/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---  * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) whether this treasure is found. No value means that the state of the treasure is not saved. It is allowed (though strange) to give the same saved treasure twice.
---  * `callback` (function, optional): A function that will be called when the treasure's dialog finishes, or after a delay of 3 seconds if there is no dialog.
---
---
---
---Remarks
---    If there is no callback, or if the callback does not change the state of the hero, then he automatically stops the brandishing animation.
---
---@param treasure_name string
---@param treasure_variant number|nil
---@param treasure_savegame_variable string|nil
---@param callback function|nil
function m:start_treasure(treasure_name,treasure_variant,treasure_savegame_variable,callback) end

---
---Makes the hero shoot an [arrow](https://doxygen.solarus-games.org/latest/lua_api_arrow.html) with a bow.
---
function m:start_bow() end

---
---Teletransports the hero to a different place.
---
---  * `map_id` (string): Id of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) to go to (may be the same map or another one). If the map does not exist, the teletransportation fails and this function generates a Lua error. If the map exists, then the teletransportation is always successful even if there is no viable destination (see below).
---  * `destination_name` (string, optional): Name of the [destination entity](https://doxygen.solarus-games.org/latest/lua_api_destination.html) where to go on that map, or the special keyword `"_same"` to keep the same coordinates. Can also be the special keyword `"_side0"`, `"_side1"`, `"_side2"` or `"_side3"` to arrive near the East, North, West or South frontier of the map respectively. But the hero should be near the corresponding side of the original map for this to look okay. This is usually used in combination with scrolling transitions. No value means the default destination entity of the map. If the destination does not exist, a debugging message is logged and the default destination is used as a fallback. Finally, if there is no destination at all, then no default destination can be used. In this case, another debugging message is logged and the hero is placed at coordinates ``(0,0).
---  * `transition_style` (string, optional): `"immediate"` (no transition effect) `"fade"` (fade-out and fade-in effect) or `"scrolling"`. No value means [game:get_transition_style()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_transition_style), which is `"fade"` by default.
---
---
---
---Remarks
---    The transportation will occur at the next cycle of the engine's main loop. Therefore, your map is not unloaded immediately and your map script continues to work.
---
---@param map_id string
---@param destination_name string|nil
---@param transition_style string|nil
function m:teleport(map_id,destination_name,transition_style) end

---
---Prevents the player from moving the hero until you call [hero:unfreeze()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_unfreeze).
---
---After you call this method, the [state](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) of the hero is `"frozen"`.
---
function m:freeze() end

---
---Changes the sprite representing the hero's shield.
---
---By default, the sprite used for the shield is `"hero/shieldX"`, where X is the [shield level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability), or no sprite if the shield level is `0`.
---
---You can use this function if you want to use another sprite.
---
---  * `sprite_id` (string): The [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) animation set id of the hero's shield. An empty string means no shield sprite.
---
---
---
---@param sprite_id string
function m:set_shield_sprite_id(sprite_id) end

---
---Makes the hero brandish his sword for a victory.
---
---  * `callback` (function, optional): A function to call when the victory sequence finishes. If you don't define it, the default behavior is to restore control to the player. If you define it, you can do other things, like teletransporting the hero somewhere else. To restore the control to the player, call [hero:unfreeze()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_unfreeze).
---
---
---
---@param callback function|nil
function m:start_victory(callback) end

---
---Returns the name of the sound played when the hero uses the sword.
---
---  * Return value (string): The sound id of the hero's sword.
---
---
---
---@return string
function m:get_sword_sound_id() end

---
---Makes the hero's sprites temporarily blink or stop blinking.
---
---This only affects displaying: see [hero:set_invincible()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_set_invincible) if you also want to make the hero invincible.
---
---  * `blinking` (boolean, optional): `true` to to make the sprites blink, or `false` to stop the blinking. No value means `true`.
---  * `duration` (number, optional): Duration in milliseconds before stopping the blinking. Only possible when you set `blinking` to `true`. No value means unlimited.
---
---
---
---@param blinking boolean|nil
---@param duration number|nil
function m:set_blinking(blinking,duration) end

---
---Returns the speed of the normal walking movement of hero.
---
---This speed is automatically reduced when the hero walks on special ground like grass, ladders or holes.
---
---  * Return value (number): The speed of normal walk in pixels par second.
---
---
---
---@return number
function m:get_walking_speed() end

---
---Returns the name of the current state of the hero, and possibly the corresponding [custom state](https://doxygen.solarus-games.org/latest/lua_api_state.html) object if any.
---
---  * Return value 1 (`string`): The current state. Can be one of: `"back to solid ground"`, `"boomerang"`, `"bow"`, `"carrying"`, `"falling"`, `"forced walking"`, `"free"`, `"frozen"`, `"grabbing"`, `"hookshot"`, `"hurt"`, `"jumping"`, `"lifting"`, `"plunging"`, `"pulling"`, `"pushing"`, `"running"`, `"stairs"`, `"swimming"`, `"sword loading"`, `"sword spin attack"`, `"sword swinging"`, `"sword tapping"`, `"treasure"`, `"using item"`, `"victory"` or `"custom"`.
---  * Return value 2 ([state](https://doxygen.solarus-games.org/latest/lua_api_state.html) or no value): The custom state object, in case the state name is `"custom"`.
---
---
---
---@return string|state|nil
function m:get_state() end

---
---Makes the hero start loading his sword.
---
---This function does the same as what happens when the player keeps pressing the `"attack"` game [command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) after using the sword.
---
---If the player is not allowed to perform this attack now (because he does not have the sword [ability](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) or because the hero is currently busy in another state that does not allow to use the sword), then nothing happens.
---
---  * `spin_attack_delay` (number, optional): Delay in milliseconds before the sword is loaded, allowing a spin attack then (default `1000`). A value of `0` allows the spin attack immediately. The special value `-1` means infinite: then, no spin attack will be possible.
---
---
---
---@param spin_attack_delay number|nil
function m:start_attack_loading(spin_attack_delay) end

---
---Makes the hero perform his main attack (swinging his sword).
---
---This function does the same as what happens when the player presses the `"attack"` game [command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands). You can use it to trigger the attack from your script instead of from a game command.
---
---If the player is not allowed to perform the attack now (because he does not have the sword [ability](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) or because the hero is currently busy in another state that does not allow to use the sword), then nothing happens.
---
function m:start_attack() end

---
---Returns the position where the hero gets back if he falls into a hole or other bad ground now.
---
---This is the position that was previously memorized by the last call to [hero:save_solid_ground()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_save_solid_ground), if any. If the position was passed to [hero:save_solid_ground()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_save_solid_ground) as a function, then this function is called to get a position.
---
---Otherwise, this is the position of the hero the last time he was on solid ground.
---
---  * Return value 1 (number): X coordinate where to get back to solid ground, or `nil` if the hero never went on solid ground on this map yet.
---  * Return value 2 (number): Y coordinate where to get back to solid ground, or no value if the hero never went on solid ground on this map yet.
---  * Return value 3 (number): Layer where to get back to solid ground, or no value if the hero never went on solid ground on this map yet.
---
---
---
---@return number|number|number
function m:get_solid_ground_position() end

---
---Restores the control to the player. The control may have been lost for example by a call to [hero:freeze()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_freeze) or to [some_movement:start(hero)](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_start).
---
function m:unfreeze() end

---
---Returns whether the hero's sprites are currently blinking.
---
---The sprites are temporarily blinking after the hero was hurt or after you called [hero:set_blinking()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_set_blinking).
---
---  * Return value (boolean): `true` if the hero's sprite are currently blinking.
---
---
---
---Remarks
---    The visibility property of the hero is independent from this. Even when the sprites are blinking, the result of [hero:is_visible()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_is_visible) is unchanged.
---
---@return boolean
function m:is_blinking() end

---
---Sets or unsets the hero temporarily invincible.
---
---When the hero is invincible, [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) cannot attack him, but you can still hurt him manually with [hero:start_hurt()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_hurt).
---
---  * `invincible` (boolean, optional): `true` to make the hero invincible, or `false` to stop the invincibility. No value means `true`.
---  * `duration` (number, optional): Duration of the invincibility in milliseconds. Only possible when you set `invincible` to `true`. No value means unlimited.
---
---
---
---@param invincible boolean|nil
---@param duration number|nil
function m:set_invincible(invincible,duration) end

---
---Returns the name of the sprite representing the hero's shield.
---
---  * Return value (string): The [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) animation set id of the hero's shield.
---
---
---
---@return string
function m:get_shield_sprite_id() end

---
---Returns whether the hero is currently invincible.
---
---The hero is temporarily invincible after being hurt or after you called [hero:set_invincible()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_set_invincible). In this situation, [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) cannot attack the hero, but you can still hurt him manually with [hero:start_hurt()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_hurt).
---
---  * Return value (boolean): `true` if the hero is currently invincible.
---
---
---
---@return boolean
function m:is_invincible() end

---
---Returns the current animation of the hero's sprites.
---
---The hero may have several sprites (see [hero:set_animation()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_set_animation). This function always returns the animation of the tunic sprite.
---
---  * Return value (string): The animation name of the tunic sprite.
---
---
---
---@return string
function m:get_animation() end

---
---Changes the sprite representing the hero's body.
---
---By default, the sprite used for the body is `"hero/tunicX"`, where X is the [tunic level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability).
---
---You can use this function if you want to use another sprite.
---
---  * `sprite_id` (string): The [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) animation set id of the hero's tunic.
---
---
---
---@param sprite_id string
function m:set_tunic_sprite_id(sprite_id) end

---
---Sets the speed of the normal walking movement of hero.
---
---The default walking speed is 88 pixels per second. This speed is automatically reduced when the hero walks on special ground like grass, ladders or holes.
---
---  * `walking` speed (number): The speed of normal walk in pixels par second.
---
---
---
function m:set_walking_speed() end

---
---Changes the sprite representing the hero's sword.
---
---By default, the sprite used for the sword is `"hero/swordX"`, where X is the [sword level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability), or no sprite if the sword level is `0`.
---
---You can use this function if you want to use another sprite.
---
---  * `sprite_id` (string): The [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) animation set id of the hero's sword. An empty string means no sword sprite.
---
---
---
---@param sprite_id string
function m:set_sword_sprite_id(sprite_id) end

_G.hero = m

return m