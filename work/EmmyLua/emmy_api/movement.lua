---@class movement
---
---If you need to move an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) of the map, a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) in a menu or simply an arbitrary point, you can create a movement object and set its properties. There are several types of movements. They differ by the kind of trajectory they can make. When you create a movement, you obtain a value of the movement type you chose. Then, to get and set its properties (like the speed, the angle, etc.), a movement object has several methods available. As detailed below, the methods available differ depending on the movement type because all movement types don't have the same properties.
---
---The following movement types are available.
---
---  * [Straight movement](https://doxygen.solarus-games.org/latest/lua_api_straight_movement.html): Rectilinear trajectory in any direction.
---  * [Random movement](https://doxygen.solarus-games.org/latest/lua_api_random_movement.html): A straight movement whose direction changes randomly from time to time.
---  * [Target movement](https://doxygen.solarus-games.org/latest/lua_api_target_movement.html): Straight trajectory towards a possibly moving target.
---  * [Path movement](https://doxygen.solarus-games.org/latest/lua_api_path_movement.html): Predetermined path composed of steps in the 8 main directions.
---  * [Random path movement](https://doxygen.solarus-games.org/latest/lua_api_random_path_movement.html): Like a path movement, but with random steps.
---  * [Path finding movement](https://doxygen.solarus-games.org/latest/lua_api_path_finding_movement.html): Like a path movement, but calculated to reach a possibly moving target.
---  * [Circle movement](https://doxygen.solarus-games.org/latest/lua_api_circle_movement.html): Circular trajectory around a possibly moving center.
---  * [Jump movement](https://doxygen.solarus-games.org/latest/lua_api_jump_movement.html): An illusion of jump above a baseline.
---  * [Pixel movement](https://doxygen.solarus-games.org/latest/lua_api_pixel_movement.html): A trajectory described pixel by pixel.
---
---
---
---This page desribes the methods and callbacks common to all movement types.
---
---Movements can be applied in-game to [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html), but also outside a game, typically in a [menu](https://doxygen.solarus-games.org/latest/lua_api_menu.html) to move a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html), an [image](https://doxygen.solarus-games.org/latest/lua_api_surface.html) or just an `(x,y)` value. However, some properties of movements (like [movement:set_ignore_obstacles()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_set_ignore_obstacles)) only take effect in the case of a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) because they refer to [map-specific](https://doxygen.solarus-games.org/latest/lua_api_map.html) notions like obstacles.
---
local m = {}

---
---Sets whether a map entity controlled by this movement should ignore obstacles of the map.
---
---If the movement is not attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) yet, it is not an error to call this function: your choice will have an effect when the movement gets attached to a map entity.
---
---  * `ignore_obstacles` (boolean, optional): `true` to make this movement ignore obstacles of the map (no value means `true`).
---
---
---
---@param ignore_obstacles boolean|nil
function m:set_ignore_obstacles(ignore_obstacles) end

---
---Sets the coordinates of the object controlled by this movement.
---
---The object controlled by this movement may be a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html), a [drawable object](https://doxygen.solarus-games.org/latest/lua_api_drawable.html) or a point.
---
---  * `x` (number): X coordinate to set.
---  * `y` (number): Y coordinate to set.
---
---
---
---@param x number
---@param y number
function m:set_xy(x,y) end

---
---Returns whether this movement is currently suspended.
---
---  * Return value (boolean): `true` if the movement is suspended.
---
---
---
---@return boolean
function m:is_suspended() end

---
---Returns whether this movement ignores obstacles of the map.
---
---If the movement is not attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) yet, it is not an error to call this function: the result will have an effect when the movement gets attached to a map entity.
---
---  * Return value (boolean): `true` if this movement ignores obstacles.
---
---
---
---@return boolean
function m:get_ignore_obstacles() end

---
---Called when this movement has just finished (if there is an end). 
---
function m:on_finished() end

---
---Called when the characteristics of this movement (like speed or angle) have just changed.
---
function m:on_changed() end

---
---Stops this movement and detaches it from the object that was moved.
---
function m:stop() end

---
---Returns whether the movement should continue even when the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is suspended.
---
---This setting only has an effect for movements attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) during a game. The default value is `false`.
---
---  * Return value (boolean): `true` to continue the movement even when the game is suspended.
---
---
---
---@return boolean
function m:get_ignore_suspend() end

---
---Called when the coordinates controlled by this movement have just changed.
---
function m:on_position_changed() end

---
---Sets whether the movement should continue even when the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is suspended.
---
---  * `ignore` (boolean, optional): `true` to continue the movement even when the game is suspended. No value means `true`.
---
---
---
---@param ignore boolean|nil
function m:set_ignore_suspend(ignore) end

---
---From the four main directions, returns the closest one to the current trajectory.
---
---East is 0, North is 1, West is 2, South is 3. As the real trajectory does not necessarily follows one of the four main directions, it will be converted to the closest one.
---
---If you use this movement to control a [sprite](https://doxygen.solarus-games.org/latest/lua_api_sprite.html) (or a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) that has a sprite), you can use this function to make the sprite face the direction of the movement.
---
---  * Return value (number): The closest direction corresponding to the angle of this movement.
---
---
---
---Example of use: 
---    
---    
---    -- Example of code from an enemy script.
---    
---    -- This function is called when the enemy should start or restart its movement.
---    function enemy:on_restarted()
---    
---      -- Create a movement that makes random straight trajectories.
---      local movement = sol.movement.create("random")
---    
---      -- This function is called when the trajectory has changed.
---      function movement:on_movement_changed()
---        -- The angle of the movement has changed: update the sprite accordingly.
---        local direction = movement:get_direction4()
---        enemy:get_sprite():set_direction(direction)
---      end
---    
---      movement:start(enemy)
---    end
---    
---
---#  Events of all movement types
---
---Events are callback methods automatically called by the engine if you define them.
---
---The following events are common to all movement types.
---
---Remarks
---    All movement events are here (it turns out that no specific movement type define additional events).
---
---@return number
function m:get_direction4() end

---
---Starts this movement on an object.
---
---The movement will be applied until it finishes (if it has an end) or until it is replaced by another one. It does not matter if the movement gets out of scope in your Lua script.
---
---  * `object_to_move` ([map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html), [drawable object](https://doxygen.solarus-games.org/latest/lua_api_drawable.html) or table): The object to move. It may be a map entity, a drawable object or a table with two fields `x` and `y`. In the case of the table, if the fields `x` and `y` don't exist, they are created and initialized to `0`.
---
---An empty table will be initialized with `{x = 0, y = 0}`.
---
---  * `callback` (function, optional): A function to call when the movement finishes.
---
---
---
---Remarks
---    The [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) is a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) just like any other. So you can apply a custom movement to him using this function. The usual way to do this is to call [hero:freeze()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_freeze) first to properly remove control from the player, and then to start the movement. When you have finished, you can restore the control with [hero:unfreeze()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_unfreeze). Indeed, changing the movement while the hero is in a state other than `"frozen"` might give surprising results. Your movement will be applied, replacing any built-in movement of the state, but whatever was happening in the state will still continue. Furthermore, your movement will disappear as soon as the state changes. So don't start a movement on the hero during an arbitrary state unless you know what you are doing.
---
---@param object_to_move entity|drawable|table
---@param callback function|nil
function m:start(object_to_move,callback) end

---
---During a [game](https://doxygen.solarus-games.org/latest/lua_api_game.html), called when the coordinates controlled by this movement have just failed to change because they would lead the [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) controlled into an obstacle of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html).
---
---When an obstacle is reached, this event is called instead of [movement:on_position_changed()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_on_position_changed).
---
---This event can only be called when all of these conditions are met:
---
---  * A [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is currently running.
---  * The movement is attached to a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) (like an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html), an [NPC](https://doxygen.solarus-games.org/latest/lua_api_npc.html), etc.).
---  * The movement does not ignore obstacles (i.e. [movement:get_ignore_obstacles()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_get_ignore_obstacles) returns `false`).
---
---
---
---Remarks
---    When the movement attempts to change the coordinates, one of [movement:on_position_changed()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_on_position_changed) or [movement:on_obstacle_reached()](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_on_obstacle_reached) is guaranteed to be called.
---
function m:on_obstacle_reached() end

---
---Returns the coordinates of the object controlled by this movement.
---
---The object controlled by this movement may be a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html), a [drawable object](https://doxygen.solarus-games.org/latest/lua_api_drawable.html) or a point.
---
---  * Return value 1 (number): X coordinate.
---  * Return value 2 (number): Y coordinate.
---
---
---
---@return number|number
function m:get_xy() end

_G.movement = m

return m