---@class enemy : entity
---
---An enemy is a bad guy that hurts the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) when touching him.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_enemy()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_enemy).
---
local m = {}

---
---Returns the current life of this enemy.
---
---  * Return value (number): Number of health points of the enemy.
---
---
---
---@return number
function m:get_life() end

---
---Returns whether this enemy can hurt the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) even when the hero is running.
---
---  * Return value (boolean): `true` if the hero can be hurt by this enemy even when running.
---
---
---
---@return boolean
function m:get_can_hurt_hero_running() end

---
---Sets whether the enemy should be pushed away when it is hurt.
---
---The default value is `true`.
---
---  * `pushed_back_when_hurt` (boolean, optional): `true` to make the enemy pushed away when hurt. No value means `true`.
---
---
---
---@param pushed_back_when_hurt boolean|nil
function m:set_pushed_back_when_hurt(pushed_back_when_hurt) end

---
---Returns whether the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) is pushed away when he hits this enemy with his sword.
---
---  * Return value (boolean): `true` if the hero is pushed away when hitting this enemy with his sword.
---
---
---
---@return boolean
function m:get_push_hero_on_sword() end

---
---Sets whether this enemy can currently attack the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html).
---
---When the enemy restarts after being hurt, `can_attack` is always set to `true`.
---
---  * `can_attack` (boolean, optional): `true` to allow the enemy to attack the hero. No value means `true`.
---
---
---
---@param can_attack boolean|nil
function m:set_can_attack(can_attack) end

---
---Sets whether this enemy can be traversed by other entities.
---
---By default, the enemy is traversable. For example, if you want to prevent the [hero](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) to pass without killing the enemy, you can use this function to make the enemy become an obstacle.
---
---  * `traversable` (boolean, optional): `true` to make this enemy traversable. No value means `true`.
---
---
---
---Remarks
---    When the enemy is not traversable, the enemy can no longer hurt the hero since their sprites cannot overlap anymore (unless if the enemy's sprite is bigger than its bounding box). You can use [enemy:set_attacking_collision_mode("touching")](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attacking_collision_mode) to make the enemy still hurt the hero when touching him without overlapping.
---
---@param traversable boolean|nil
function m:set_traversable(traversable) end

---
---Called when the enemy is immobilized.
---
function m:on_immobilized() end

---
---Returns the level of protection (if any) that stops attacks from this enemy.
---
---If the player has a protection [ability](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) greater than or equal to this value, he will stop attacks from this enemy if he is facing the direction of the enemy. The special value of `0` means that attacks cannot be stopped with the protection ability. Returns the required level of protection to stop attacks from this enemy.
---
---  * Return value (number): The level of protection that stops attacks from this enemy. A value of `0` means that the hero cannot stop the attacks.
---
---
---
---@return number
function m:get_minimum_shield_needed() end

---
---Hurts this enemy if he is currently vulnerable.
---
---If the enemy is vulnerable, the hurting animation and sound start and the given number of life points are removed.
---
---Nothing happens if the enemy is currently invulnerable (for example because he is already being hurt).
---
---  * `life_points` (number): Number of life points to remove from the enemy.
---
---
---
---Remarks
---    If you just want to silently remove some life, call [enemy:remove_life()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_remove_life) instead.
---
---@param life_points number
function m:hurt(life_points) end

---
---Sets how this enemy reacts when one of his [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) receives an attack.
---
---This method overrides for a particular sprite the attack consequences defined by [enemy:set_attack_consequence()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): A sprite of this enemy.
---  * `attack` (string): Name of an attack against the enemy: "sword", "thrown_item", "explosion", "arrow", "hookshot", "boomerang" or "fire".
---  * `consequence` (number, string or function): Indicates what happens when this sprite receives the attack. The possible values are the same as in [enemy:set_attack_consequence()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).
---
---
---
---@param sprite sprite
---@param attack string
---@param consequence number|string|function
function m:set_attack_consequence_sprite(sprite,attack,consequence) end

---
---Called when the enemy's dying animation is finished.
---
---At this point, the enemy no longer exists on the map. In other words, [enemy:exists()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_exists) returns `false`, trying to get the enemy from its name returns `nil`, and functions like [map:get_entities(prefix)](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_entities_count) won't find this enemy.
---
---This means that you can safely use [map:has_entities(prefix)](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_has_entities) from `enemy:on_dead()` to detect when all enemies with a common prefix are dead.
---
function m:on_dead() end

---
---Sets whether the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) should be pushed away when he hits this enemy with his sword.
---
---The default value is `false`.
---
---  * `push_hero_on_sword` (boolean, optional): `true` to push the hero away when hitting this enemy with his sword. No value means `true`.
---
---
---
---@param push_hero_on_sword boolean|nil
function m:set_push_hero_on_sword(push_hero_on_sword) end

---
---Restores the default attack consequences for this enemy and its sprites.
---
function m:set_default_attack_consequences() end

---
---Returns the number of life points that the enemy removes from the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) when touching him. This number will be divided by the level of resistance ability of the player (his tunic).
---
---  * Return value (number): Damage inflicted to the hero.
---
---
---
---@return number
function m:get_damage() end

---
---Called at each cycle while this enemy is alive.
---
---Remarks
---    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) and other events.
---
function m:on_update() end

---
---Sets the number of life points that the enemy removes from the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) when touching him. This number will be divided by the [tunic](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) level of the player, unless you override this default calculation in [hero:on_taking_damage()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_on_taking_damage).
---
---The default value is `1`.
---
---  * `damage` (number): Damage inflicted to the hero.
---
---
---
---@param damage number
function m:set_damage(damage) end

---
---Called when this enemy receives an attack with a custom effect.
---
---This function is called if you have set [consequence of the attack](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) to `"custom"`. You have to define what happens, for example hurting the enemy, making a special reaction, etc.
---
---  * `attack` (string): The attack that was received: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"fire"`. In the particular case of a `"sword"` attack, the sword state is stopped and the hero goes back to state `"free"`.
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The sprite of this enemy that receives the attack, or `nil` if the attack does not come from a pixel-precise collision.
---
---
---
---Remarks
---    Instead of using this event and the attack consequence `"custom"`, you can now simply pass a callback parameter to [enemy:set_attack_consequence()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) or to [enemy:set_attack_consequence_sprite()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).
---
---@param attack string
---@param sprite sprite
function m:on_custom_attack_received(attack,sprite) end

---
---Returns the breed (the model) of this enemy.
---
---  * Return value (string): The enemy's breed.
---
---
---
---@return string
function m:get_breed() end

---
---Called when this enemy should start or restart its [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html) and [timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) because something happened. For example, the enemy has just been created, or it was just hurt or immobilized, or you called [enemy:restart()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_restart). If your enemy should move, this is the right place to create its movement.
---
---[Timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) associated to the enemy were automatically destroyed. Thus, you should also recreate them from this event.
---
function m:on_restarted() end

---
---Sets the current life of this enemy.
---
---The initial value is `1`.
---
---  * `life` (number): Number of health points to set. A value of `0` or lower kills the enemy.
---
---
---
---@param life number
function m:set_life(life) end

---
---Called when the enemy's life comes to `0`.
---
---When the life comes to `0`, the movement of the enemy is stopped, its timers are stopped too, the dying animation starts and a sound is played. The details of the dying animation and the sound played depend on the [hurt style](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_hurt_style) property.
---
---  * If the hurt style is `"enemy"` or `"monster"`, any sprite of the enemy is automatically removed and replaced by the sprite indicated by [enemy:get_dying_sprite_id()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_dying_sprite_id) if any (which is by default `"enemies/enemy_killed"`).
---  * If the hurt style is `"boss"`, your sprites continue to exist and to play animation "hurt", while explosions appear on the enemy.
---
---
---
---In all cases, the enemy will be removed from the map when the dying animation ends.
---
---Remarks
---    This event is called right after [enemy:on_hurt()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_on_hurt).
---
function m:on_dying() end

---
---Returns the [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) that will drop this enemy when killed.
---
---  * Return value 1 (string): Name of an [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html). `nil` means no item dropped (in this case, other return values are `nil` too).
---  * Return value 2 (number): Variant of this equipment item (`1` means the first variant).
---  * Return value 3 (string): Name of the boolean value that stores in the [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) whether the treasure dropped is found. `nil` means that the treasure is not saved.
---
---
---
---@return string|number|string
function m:get_treasure() end

---
---Called when this enemy is successfully hurt by any attack.
---
---This event can only be called if the [reaction](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) to the attack is hurting the enemy.
---
---At this point, the enemy is in the state of being hurt. His hurting animation and sound have just started and he has just lost some life.
---
---  * `attack` (string): The attack that was received: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"`, `"fire"`, or `"script"`.
---
---
---
---Remarks
---    In the case of a `"sword"` attack, this event is called right after [enemy:on_hurt_by_sword()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_on_hurt_by_sword).
---
---@param attack string
function m:on_hurt(attack) end

---
---Returns how the enemy behaves with obstacles.
---
---  * Return value (string): `"normal"`, `"flying"` or `"swimming"`.
---
---
---
---@return string
function m:get_obstacle_behavior() end

---
---Called when a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) of this enemy overlaps another enemy's sprite.
---
---  * `other_enemy` (enemy): Another enemy.
---  * `other_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): A sprite of that other enemy.
---  * `my_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): A sprite of the current enemy.
---
---
---
---@param other_enemy enemy
---@param other_sprite sprite
---@param my_sprite sprite
function m:on_collision_enemy(other_enemy,other_sprite,my_sprite) end

---
---Removes some life from the enemy.
---
---  * `life` (number): Number of health points to remove.
---
---
---
---Remarks
---    Equivalent to `enemy:set_life(enemy:get_life() - life)`
---
---@param life number
function m:remove_life(life) end

---
---Called when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) is successfully touched by this enemy.
---
---This event is not called if the hero was protected by his shield, or if he currently cannot be hurt for some reason, like when he is already being hurt, when he is [temporarily invincible](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_set_invincible), or when he is in a special [state](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_get_state) like brandishing a treasure.
---
---Your script can define this event to customize what bad things happen to the hero. If you define this event, the engine does absolutely nothing and lets you handle this.
---
---If you don't define this event, the hero is hurt with the predefined behavior as follows. The hero goes to the state `"hurt"` where is pushed away from the enemy. He loses some life depending on the enemy's [damage](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_damage) property, and on the hero's [tunic](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) and on [hero:on_taking_damage()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_on_taking_damage) if defined. Then, he recovers and his sprites blink for a while. During this short period, he is temporarily invincible.
---
---  * `hero` ([hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html)): The hero being attacked.
---  * `enemy_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The sprite of the enemy that caused the collision with the hero. You may use this information if your enemy has several sprites with different behaviors. This value is `nil` if the attack does not come from a sprite collision test (see [enemy:set_attacking_collision_mode()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attacking_collision_mode)).
---
---
---
---Remarks
---    If you call [hero:start_hurt()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_hurt_entity), you will obtain something equivalent to the default behavior. But if you don't, keep in mind that if the hero can still be hurt after your call, this event will continue to be called while there is a collision with the enemy. To avoid this, see for example [hero:set_invincible()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_set_invincible) to make the hero temporarily invincible. 
---
---@param hero hero
---@param enemy_sprite sprite
function m:on_attacking_hero(hero,enemy_sprite) end

---
---Returns how this enemy reacts when one of his [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) receives an attack.
---
---This method returns the same result as [enemy:get_attack_consequence()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_attack_consequence), unless you override the reaction of the enemy for a particular sprite with [enemy:set_attack_consequence_sprite()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): A sprite of this enemy.
---  * `attack` (string): Name of an attack against the enemy: "sword", "thrown_item", "explosion", "arrow", "hookshot", "boomerang" or "fire".
---  * `consequence` (number, string or function): Indicates what happens when this sprite receives the attack. The possible values are the same as in [enemy:set_attack_consequence()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).
---
---
---
---@param sprite sprite
---@param attack string
function m:get_attack_consequence_sprite(sprite,attack) end

---
---Creates another enemy on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html), specifying its coordinates as relative to the current enemy.
---
---This function is similar to [map:create_enemy()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_enemy) but the coordinates are relative to the current enemy, and the layer is the one of the current enemy by default.
---
---  * `properties` (table): A table that describes all properties of the enemy to create. Its key-value pairs must be:
---    * `name` (string, optional): Name identifying the entity. If the name is already used by another entity, a suffix (of the form `"_2"`, `"_3"`, etc.) will be automatically appended to keep entity names unique. No value means no name.
---    * `layer` (number, optional): The layer, between [map:get_min_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_min_layer) and [map:get_max_layer()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_max_layer). No value means the same layer as the current enemy.
---    * `x` (number, optional): X coordinate on the map, relative to the current enemy. The default value is `0`.
---    * `y` (number, optional): Y coordinate on the map, relative to the current enemy. The default value is `0`.
---    * `direction` (number, optional): Initial direction of the enemy, between `0` (East) and `3` (South). The default value is `3`.
---    * `breed` (string): Model of enemy to create.
---    * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) whether this enemy is dead. No value means that the enemy is not saved. If the enemy is saved and was already killed, then no enemy is created. Instead, its [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) is created if it is a saved one.
---    * `treasure_name` (string, optional): Kind of [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) to drop when the enemy is killed (the name of an [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html)). If this value is not set, or corresponds to a [non obtainable](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_is_obtainable) item, then the enemy won't drop anything.
---    * `treasure_variant` (number, optional): Variant of the treasure (because some [equipment items](https://doxygen.solarus-games.org/latest/lua_api_item.html) may have several variants). The default value is `1` (the first variant).
---    * `treasure_savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) whether the [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) of this enemy was obtained. No value means that the state of the treasure is not saved. If the treasure is saved and the player already has it, then the enemy won't drop anything.
---  * Return value (enemy or [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html)): The enemy created, except when it is a saved enemy that is already dead. In this case, if the enemy dropped a saved treasure that is not obtained yet, this [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) is created and returned. Otherwise, `nil` is returned.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Enemies are particular [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type enemy
---
---The following events are specific to enemies.
---
---@param properties table
---@return enemy|pickable
function m:create_enemy(properties) end

---
---Adds some life to the enemy.
---
---  * `life` (number): Number of health points to add.
---
---
---
---Remarks
---    Equivalent to `enemy:set_life(enemy:get_life() + life)`
---
---@param life number
function m:add_life(life) end

---
---Returns whether the enemy is pushed away when it is hurt.
---
---  * Return value (boolean): `true` if the enemy is pushed away when hurt.
---
---
---
---@return boolean
function m:is_pushed_back_when_hurt() end

---
---Immobilizes this enemy for a while if possible.
---
---After a few seconds, the enemy shakes and then restarts.
---
function m:immobilize() end

---
---Returns whether the enemy is currently immobilized.
---
---  * Return value (boolean): `true` if the enemy is immobilized.
---
---
---
---@return boolean
function m:is_immobilized() end

---
---Sets how this enemy should behave with obstacles. The default value is `"normal"`. `"swimming"` allow the enemy to traverse water. `"flying"` allows the enemy to traverse holes, water and lava.
---
---  * `obstacle_behavior` (string): `"normal"`, `"flying"` or `"swimming"`.
---
---
---
---@param obstacle_behavior string
function m:set_obstacle_behavior(obstacle_behavior) end

---
---Called when this enemy is successfully hurt by the sword of the hero.
---
---You should define this event to customize the damage inflicted by the sword.
---
---This event can only be called if the [reaction](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) to the `"sword"` attack is hurting the enemy.
---
---At this point, the enemy is in the state of being hurt. His hurting animation and sound have just started. This is a good time to remove some life points with [enemy:remove_life()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_remove_life).
---
---By default, if you don't define this event, the enemy loses a number of life points computed as [his reaction to sword attacks](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_attack_consequence) multiplied by the sword [ability level](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) of the hero, and doubled during a spin attack.
---
---  * `hero` ([hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html)): The hero who used the sword.
---  * `enemy_sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): The sprite of this enemy that was hit. You may use this information if your enemy has several sprites with different behaviors.
---
---
---
---@param hero hero
---@param enemy_sprite sprite
function m:on_hurt_by_sword(hero,enemy_sprite) end

---
---Sets the [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) that will drop this enemy when killed.
---
---  * `item_name` (string, optional): Name of an [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html). `nil` or no value means no item.
---  * `variant` (number, optional): Variant of this equipment item (`1` means the first variant). The default value is `1`.
---  * `savegame_variable` (string, optional): Name of the boolean value that stores in the [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) whether the treasure dropped is found. `nil` or no value means that the treasure is not saved.
---
---
---
---@param item_name string|nil
---@param variant number|nil
---@param savegame_variable string|nil
function m:set_treasure(item_name,variant,savegame_variable) end

---
---Sets how this enemy reacts when he receives an attack.
---
---Recall that enemies may have several [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html). This attack consequence applies to all sprites of the enemy, unless you override some of them with [enemy:set_attack_consequence_sprite()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).
---
---  * `attack` (string): Name of an attack against the enemy: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"fire"`.
---  * `consequence` (number, string or function): Indicates what happens when this enemy receives the attack. It may be:
---    * A positive integer: The enemy is hurt and loses this number of life points. In the particular case of a sword attack, this number will by default be increased by the level of the sword (see [enemy:on_hurt_by_sword()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_on_hurt_by_sword)).
---    * `"ignored"`: Nothing happens. The weapon (if any) traverses the enemy.
---    * `"protected"`: The enemy stops the attack. An attack failure sound is played.
---    * `"immobilized"`: The enemy is immobilized for a few seconds.
---    * `"custom"`: Event [enemy:on_custom_attack_received()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_on_custom_attack_received) is called. Note: Since Solarus 1.6, we recommend to use a function parameter instead for more simplicity (see below).
---    * `A` function: A function to be called when this enemy receives the attack.
---
---
---
---@param attack string
---@param consequence number|string|function
function m:set_attack_consequence(attack,consequence) end

---
---Returns the style of sounds and animations to play when this enemy is hurt.
---
---  * Return value (string): `"normal"`, `"monster"` or `"boss"`.
---
---
---
---@return string
function m:get_hurt_style() end

---
---Makes this enemy ignore all attacks.
---
---Equivalent to calling [enemy:set_attack_consequence(attack, "ignored")](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence) for each attack.
---
function m:set_invincible() end

---
---Sets whether this enemy can detect collisions with entities even if they are not on the same layer.
---
---By default, enemies can only have collisions with entities on the same layer. If you set this property to `true`, this enemy will be able to hurt the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) even from a different layer.
---
---  * `independent` (boolean, optional): `true` to make this enemy detect collisions even with entities on other layers. No value means `true`.
---
---
---
---@param independent boolean|nil
function m:set_layer_independent_collisions(independent) end

---
---Returns whether this enemy can detect collisions with entities even if they are not on the same layer.
---
---By default, enemies can only have collisions with entities on the same layer.
---
---  * Return value (boolean): `true` if this enemy can detect collisions even with entities on other layers.
---
---
---
---@return boolean
function m:has_layer_independent_collisions() end

---
---Makes a sprite of this enemy ignore all attacks.
---
---Equivalent to calling [enemy:set_attack_consequence(sprite, attack, "ignored")](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite) for each attack.
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): A sprite of this enemy.
---
---
---
---@param sprite sprite
function m:set_invincible_sprite(sprite) end

---
---Restores the default attack consequences for a particular sprite of this enemy.
---
---  * `sprite` ([sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html)): A sprite of this enemy.
---
---
---
---@param sprite sprite
function m:set_default_attack_consequences_sprite(sprite) end

---
---Sets the id of the sprite to show when this enemy is dying.
---
---See [enemy:get_dying_sprite_id()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_dying_sprite_id) for more details.
---
---  * `dying_sprite_id` (string or nil): Id of the sprite to use for the dying animation, or `nil` to show no dying animation.
---
---
---
---@param dying_sprite_id string|nil
function m:set_dying_sprite_id(dying_sprite_id) end

---
---Sets whether this enemy can hurt the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) even when the hero is running.
---
---The default value is `false`.
---
---  * `can_hurt_hero_running` (boolean, optional): `true` so that the hero can be hurt by this enemy even when running. No value means `true`.
---
---
---
---@param can_hurt_hero_running boolean|nil
function m:set_can_hurt_hero_running(can_hurt_hero_running) end

---
---Returns the kind of collision test performed to detect when the hero should be hurt by this enemy.
---
---  * Return value (string): A collision mode name. See [enemy:set_attacking_collision_mode()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attacking_collision_mode) for the possible values.
---
---
---
---@return string
function m:get_attacking_collision_mode() end

---
---Returns whether this enemy can be traversed by other entities.
---
---  * Return value (boolean): `true` if this enemy is traversable.
---
---
---
---@return boolean
function m:is_traversable() end

---
---Sets the kind of collision test performed to detect when the hero should be hurt by this enemy.
---
---  * collision_mode (string): A collision mode name. This may be one of:
---    * `"overlapping"`: Collision if the [bounding box](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_bounding_box) of the enemy and the hero overlap.
---    * `"containing"`: Collision if the bounding box of the hero is fully inside the bounding box of this enemy.
---    * `"origin"`: Collision if the [origin point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_origin) or the hero is inside the bounding box of this enemy.
---    * `"center"`: Collision if the [center point](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_center_position) of the hero is inside the bounding box of this enemy.
---    * `"facing"`: Collision if the [facing position](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_facing_position) of the hero's bounding box is touching this enemy's bounding box. Bounding boxes don't necessarily overlap, but they are in contact: there is no space between them. When you consider the bounding box of the hero, which is a rectangle with four sides, the facing point is the middle point of the side the hero is oriented to.
---    * `"touching"`: Like `"facing"`, but accepts all four sides of the hero's bounding box, no matter its direction. This `"touching"` collision test is useful when the hero cannot traverse your enemy (see [enemy:set_traversable()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_traversable)).
---    * `"sprite"`: Collision if the tunic sprite of the hero overlaps a sprite of this enemy. The collision test is pixel precise. This is the default value.
---
---
---
---@param collision_mode string
function m:set_attacking_collision_mode(collision_mode) end

---
---Returns how this enemy reacts when he receives an attack.
---
---Recall that enemies may have several [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html). This attack consequence applies to all sprites of the enemy, unless you override some of them with [enemy:set_attack_consequence_sprite()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence_sprite).
---
---  * `attack` (string): Name of an attack against the enemy: `"sword"`, `"thrown_item"`, `"explosion"`, `"arrow"`, `"hookshot"`, `"boomerang"` or `"fire"`.
---  * `consequence` (number, string or function): Indicates what happens when this enemy receives the attack. The possible values are the same as in [enemy:set_attack_consequence()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_set_attack_consequence).
---
---
---
---@param attack string
function m:get_attack_consequence(attack) end

---
---Sets a level of protection that stops attacks from this enemy.
---
---If the player has a protection [ability](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) greater than or equal to this value, he will stop attacks from this enemy if he is facing the direction of the enemy. The special value of `0` means that attacks cannot be stopped with the protection ability. The default value is `0`.
---
---  * `minimum_shield_needed` (number): The level of protection that stops attacks from this enemy. A value of `0` means that the hero cannot stop the attacks.
---
---
---
---@param minimum_shield_needed number
function m:set_minimum_shield_needed(minimum_shield_needed) end

---
---Returns the id of the sprite to show when this enemy is dying.
---
---This sprite is displayed during the usual dying animation. It is not used when the dying animation is a special one, for example if the [hurt style](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_get_hurt_style) is `"boss"` (in which case explosions are displayed instead) or if the enemy was killed by bad ground like water or holes.
---
---The default dying sprite id is `"enemies/enemy_killed"`.
---
---  * Return value (string or nil): Id of the sprite to use for the dying animation, or `nil` to show no dying animation.
---
---
---
---@return string|nil
function m:get_dying_sprite_id() end

---
---Returns whether this enemy can currently attack the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html).
---
---  * Return value (boolean): `true` if the enemy can currently attack the hero.
---
---
---
---@return boolean
function m:get_can_attack() end

---
---Sets the style of sounds and animations to play when this enemy is hurt. The default values is `"normal"`.
---
---  * `hurt_style` (string): `"normal"`, `"monster"` or `"boss"`.
---
---
---
---@param hurt_style string
function m:set_hurt_style(hurt_style) end

---
---Restarts this enemy.
---
---This plays animation `"walking"` on its [sprites](https://doxygen.solarus-games.org/latest/lua_api_sprite.html), destroys any timer of the enemy and calls the event [enemy:on_restarted()](https://doxygen.solarus-games.org/latest/lua_api_enemy.html#lua_api_enemy_on_restarted).
---
---This function has no effect if the enemy is dying.
---
function m:restart() end

_G.enemy = m

return m