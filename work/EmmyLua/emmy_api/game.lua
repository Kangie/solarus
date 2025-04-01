---@class game
---
---This module provides a datatype "game" that represents a savegame.
---
local m = {}

---
---Assigns an equipment item to a slot.
---
---  * `slot` (number): The slot to set (`1` or `2`).
---  * `item` ([item](https://doxygen.solarus-games.org/latest/lua_api_item.html)): The equipment item to associate to this slot, or `nil` to make the slot empty.
---
---
---
---@param slot number
---@param item item
function m:set_item_assigned(slot,item) end

---
---Returns the amount of money of the player.
---
---  * Return value (number): The current amount of money.
---
---
---
---@return number
function m:get_money() end

---
---Finishes the current game-over sequence.
---
---Only possible during a game-over sequence.
---
---The game is suspended during the whole game-over sequence. Call this function to resume it. If the [life](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_life) is still zero at this point, then the engine automatically restores full life.
---
function m:stop_game_over() end

---
---Sets the amount of money of the player.
---
---A negative value will be replaced by zero. A value greater than than the maximum amount of money will be replaced by the maximum amount.
---
---  * `money` (number): The amount of money to set.
---
---
---
---@param money number
function m:set_money(money) end

---
---Returns whether the player can pause or unpause the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html).
---
---  * Return value (boolean): `true` if the player is allowed to pause the game.
---
---
---
---@return boolean
function m:is_pause_allowed() end

---
---Called when the user presses a joypad button while your game is running.
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
---Starts the game-over sequence manually.
---
---Only possible when the game is running.
---
---This function is seldom needed since the game-over sequence automatically starts when the player's life reaches zero. But you can use it if you want to start a game-over sequence even when the player's life is greater than zero.
---
function m:start_game_over() end

---
---Called when the game has just been paused.
---
---The game may have been paused by the player (by pressing the `"pause"` game command) or by you (by calling [game:set_paused(true)](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_paused)).
---
---This function is typically the place where you should start your pause menu.
---
function m:on_paused() end

---
---Adds some magic points to the player.
---
---  * `magic` (number): Number of magic points to add. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_magic(game:get_magic() + magic)`.
---
---@param magic number
function m:add_magic(magic) end

---
---Called when the user releases a joypad button while your game is running.
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
---Returns a value saved.
---
---  * `savegame_variable` (string): Name of the value to get from the savegame.
---  * Return value (string, number or boolean): The corresponding value (`nil` if no value is defined with this key).
---
---
---
---@param savegame_variable string
---@return string|number|boolean
function m:get_value(savegame_variable) end

---
---Suspends or unsuspends the game.
---
---Note that the game is also automatically suspended by the engine in the following situations:
---
---  * when the game is [paused](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_paused),
---  * or when a [dialog](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_dialog_enabled) is active,
---  * or when the [game-over sequence](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_game_over_enabled) is active,
---  * or when a transition between two maps is playing.
---
---
---
---Therefore, if you call `game:set_suspended(false)` during one of these sequences, it will only take effect at the end of it.
---
---  * `suspended` (boolean, optional): `true` to suspend the game, `false` to resume it. No value means `true`.
---
---
---
---Note
---    When the hero goes to another map, the game is automatically unsuspended after the map opening transition.
---
---@param suspended boolean|nil
function m:set_suspended(suspended) end

---
---Returns whether the player has a built-in ability.
---
---  * `ability_name:` Name of the ability to get (see [game:get_ability()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) for the list of valid ability names).
---  * Return value (boolean): `true` if the player has this ability.
---
---
---
---Remarks
---    Equivalent to `game:get_ability(ability_name) > 0`.
---
---@return boolean
function m:has_ability() end

---
---Sets the joypad input that should trigger the specified game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * joypad_string (string): A string describing what joypad input should trigger this game command (`nil` means none). This string must have one of the following forms:
---    * `"button X"` where X is the index of a joypad button (first is `0`),
---    * `"axis X +"` where X is the index of a joypad axis (first is `0`),
---    * `"axis X -"` where X is the index of a joypad axis (first is `0`),
---    * `"hat X Y"` where X is the index of a joypad hat (first is `0`) and Y is a direction (`0` to `7`).
---
---
---
---Note
---    If this joypad input was already mapped to a command, joypad inputs of both commands are switched.
---
---@param command string
---@param joypad_string string
function m:set_command_joypad_binding(command,joypad_string) end

---
---Sets whether the player can pause or unpause the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html).
---
---  * `pause_allowed` (boolean, optional): `true` to allow the player to pause the game. No value means `true`.
---
---
---
---Remarks
---    This function applies to the built-in [pause command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands). Your script can still pause the game explicitly by calling [game:set_paused()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_paused).
---
---@param pause_allowed boolean|nil
function m:set_pause_allowed(pause_allowed) end

---
---Returns the maximum amount of money of the player.
---
---  * Return value (number): The maximum money.
---
---
---
---@return number
function m:get_max_money() end

---
---Returns whether this game is currently showing a dialog.
---
---It does not matter whether the dialog is shown with the built-in, minimal dialog box or with your custom dialog box (see [game:on_dialog_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_started)).
---
---Only possible when the game is running.
---
---  * Return value (boolean): `true` if a dialog is being shown.
---
---
---
---@return boolean
function m:is_dialog_enabled() end

---
---Stops the current dialog.
---
---A dialog must be active when you call this function. The dialog stops being displayed and the game can resume. This function is typically called by your dialog box system when it wants to close the dialog.
---
---The [game:on_dialog_finished()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_finished) event is first called (if it is defined). Then, the callback that was passed to [game:start_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_dialog) is called (if it was defined) with the `status` argument.
---
---  * `status` (any type, optional): Some information to return to the script that started the dialog. For example, you can pass the result of the dialog if it was a question, or whether it was skipped by the user before the end. See the [examples above](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_dialog).
---
---
---
---@param status any|nil
function m:stop_dialog(status) end

---
---Returns whether this game is currently showing a game-over sequence.
---
---Only possible when the game is running.
---
---The game-over sequence automatically starts when the player's life gets to zero, or when you call [game:start_game_over()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_game_over) explicitly. Define the event [game:on_game_over_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_game_over_started) to show your game-over menu. If you don't define this event, by default, there is no game-over sequence and the engine immediately restarts the game (but does not save it).
---
---  * Return value (boolean): `true` if a game-over sequence is running.
---
---
---
---@return boolean
function m:is_game_over_enabled() end

---
---Starts showing a dialog.
---
---A dialog must not be already active. This function returns immediately, but you can provide a callback that will be executed when the dialog finishes. The game is suspended during the dialog, like when it is paused.
---
---If the event [game:on_dialog_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_started) is not defined, then the engine will show a default, minimal dialog system without decoration. The user will be able to close the dialog by pressing the action command (you don't need to call [game:stop_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_stop_dialog)).
---
---On the contrary, if the event [game:on_dialog_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_started) is defined, the engine calls it and does nothing else. This is the recommended way, because you can make your custom dialog box implementation with any feature you need. The game will be suspended until you call [game:stop_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_stop_dialog) explicitly.
---
---  * `dialog_id` (string): Id of the dialog to show. The corresponding dialog must exist in the [dialogs.dat](https://doxygen.solarus-games.org/latest/quest_language_dialogs.html) file of the current [language](https://doxygen.solarus-games.org/latest/lua_api_language.html).
---  * `info` (any type, optional): Any information you want to pass to the [game:on_dialog_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_started) event. You can use this parameter to include in the dialog any information that is only known at runtime, for example the name of the player, the best score of a mini-game or the time spent so far in the game. See the examples below.
---  * `callback` (function, optional): A function to be called when the dialog finishes. A status parameter (possibly `nil`) is passed to your function: its value is the argument of [game:stop_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_stop_dialog) and it represents the result of the dialog. This feature may be used by your dialog box system to return any useful information to the map script, like the answer chosen by the player if the dialog was a question, or whether the dialog was skipped.
---
---
---
---Example of a small map script with an NPC that shows a simple dialog: 
---    
---    
---    local map = ...
---    
---    function some_npc:on_interaction()
---      -- Remember that you specify a dialog id, not directly the text to show.
---      -- The text is defined in the dialogs.dat file of the current language.
---      map:get_game():start_dialog("welcome_to_my_house")
---    end
---    
---
---Here is a more complex example, with an NPC that asks a question. This example assumes that your dialog box system can ask questions to the player, and returns the answer as a boolean value passed to [game:stop_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_stop_dialog). 
---    
---    
---    local map = ...
---    local game = map:get_game()
---    function another_npc:on_interaction()
---      game:start_dialog("give_me_100_rupees_please", function(answer)
---        if answer then
---          if game:get_money() >= 100 then
---            game:remove_money(100)
---            game:start_dialog("thanks")
---          else
---            sol.audio.play_sound("wrong")
---            game:start_dialog("not_enough_money")
---          end
---        else
---          game:start_dialog("not_happy")
---        end
---      end)
---    end
---    
---
---Finally, to illustrate the use of the `info` parameter, let's modify the previous example to make the amount of money only determined at runtime. In other words, we want an NPC that can say "Please give me 100 rupees", but also "Please give me 25 rupees" or any number. Since the number is only known at runtime, it can no longer be hardcoded in the text of the [dialog](https://doxygen.solarus-games.org/latest/quest_language_dialogs.html). So let's assume that the text of the dialog contains instead a special sequence (like `"$v"`) to be substituted by the final value. (Note that [shop treasures](https://doxygen.solarus-games.org/latest/lua_api_shop_treasure.html#lua_api_shop_treasure_dialogs) use a very similar convention for their dialogs.) 
---    
---    
---    local map = ...
---    local game = map:get_game()
---    
---    function another_npc:on_interaction()
---      local how_much = math.random(100)
---      game:start_dialog("give_me_x_rupees_please", how_much, function(answer)
---        if answer then
---          if game:get_money() >= how_much then
---            game:remove_money(how_much)
---            -- ... The rest is unchanged.
---    
---
---To make this example work, you need a dialog box system that performs the substitution when `info` is set. See [game:on_dialog_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_started).
---
---Note
---    The `info` parameter of [game:start_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_dialog) and the status parameter of the callback are a flexible way to make the map script communicate with the dialog box system in both directions. They can been seen as the parameter and the result (respectively) of the dialog being displayed. They can both be any value, like a table with many information.
---
---@param dialog_id string
---@param info any|nil
---@param callback function|nil
function m:start_dialog(dialog_id,info,callback) end

---
---Returns the current map.
---
---  * Return value ([map](https://doxygen.solarus-games.org/latest/lua_api_map.html)): The current map of this game (`nil` if this game is not running).
---
---
---
---@return map
function m:get_map() end

---
---Saves this game into its savegame file.
---
---A valid quest write directory must be set (in your [quest.dat file](https://doxygen.solarus-games.org/latest/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.
---
function m:save() end

---
---Increases the maximum level of life of the player.
---
---  * `life` (number): Maximum number of life points to add to the maximum. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_max_life(game:get_max_life() + life)`.
---
---@param life number
function m:add_max_life(life) end

---
---Returns the style of transition to use by default when changing maps.
---
---This transition style is used when the game starts, when the game ends, and when calling [hero:teleport()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_teleport) without specifying the style of transition.
---
---  * Return value (string): The default transition style. Can be one of:
---    * `"immediate"`: No transition effect.
---    * `"fade"`: Fade-out and fade-in effect (default).
---    * `"scrolling"`: Scrolling between adjacent maps.
---
---
---
---@return string
function m:get_transition_style() end

---
---Returns whether the player has the specified [equipment item](https://doxygen.solarus-games.org/latest/lua_api_item.html) (only for a saved item).
---
---  * `item_name` (string): Name of the item to check.
---  * Return value (boolean): `true` if the player has at least the first variant of this item.
---
---
---
---Remarks
---    Equivalent to `game:get_item(item_name):get_variant() > 0`.
---
---@param item_name string
---@return boolean
function m:has_item(item_name) end

---
---Creates a command pressed input event.
---
---Everything acts like if the player had just pressed an input mapped to this game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---
---
---
---@param command string
function m:simulate_command_pressed(command) end

---
---Called when the game has just been redrawn by the engine.
---
---The engine has already drawn the current map, since the map is always drawn before the game. If the game has [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html), these menu are not drawn yet at this point. Use this event if you want to draw some additional content before the menus.
---
---  * `dst_surface` ([surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html)): The surface where the game is drawn.
---
---
---
---@param dst_surface surface
function m:on_draw(dst_surface) end

---
---Called when a game-over sequence starts.
---
---This event is called when the player's life reaches zero, as soon as the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) is in a state that allows game-over. It is also called if you started a game-over sequence manually with [game:start_game_over()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_game_over).
---
---If this event is not defined, there is no game-over sequence: the game restarts immediately, like if you called [game:start()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start), and the full life of the player is restored.
---
---If this event is defined, the engine does nothing except suspending the game. Your script is then responsible to show a game-over sequence in any way you want, and to call [game:stop_game_over()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_stop_game_over) once you have finished.
---
---For instance, you may create a [dialog](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_dialog) that lets the player [restart the game](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start) or [save](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_save) and [quit](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_reset), or a [menu](https://doxygen.solarus-games.org/latest/lua_api_menu.html) with more options.
---
---Actually, it is not even required to restart or quit the game after your game-over sequence (even if this is the most common case). Indeed, you can also just resume the game. In this case, the game continues normally like if nothing happened.
---
function m:on_game_over_started() end

---
---Returns the level of a built-in ability.
---
---Built-in ability levels indicate whether the hero can perform some built-in actions like attacking, swimming or running. The initial value is `0` unless specified otherwise.
---
---  * `ability_name` (string): Name of the ability to get. Valid ability names are:
---    * `"sword"`: Using the sword when pressing the attack command. Determines the default sword sprite.
---    * `"sword_knowledge"`: Ability to make the super spin-attack.
---    * `"tunic"`: Resistance level that reduces the damage received by the hero. Determines the default sprite used for the hero's body. The initial value is `1`.
---    * `"shield"`: Protection against enemies. Allows to avoid some attacks. Determines the default shield sprite.
---    * `"lift"`: Ability to [lift other entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_get_weight).
---    * `"swim"`: Ability to swim in deep water.
---    * `"jump_over_water"`: Automatically jumping when arriving into water without the `"swim"` ability.
---    * `"run"`: Running when pressing the action command.
---    * `"push"`: Trying to push when walking towards an obstacle. The initial value is `1`.
---    * `"grab"`: Grabbing the faced obstacle when pressing the action command. The initial value is `1`.
---    * `"pull"`: Pulling the faced obstacle the hero is grabbing. The initial value is `1`.
---    * `"detect_weak_walls"`: Notifying the player with a sound when a weak wall is nearby.
---  * Return value (number): Level of this ability (`0` means not having this ability yet).
---
---
---
---@param ability_name string
---@return number
function m:get_ability(ability_name) end

---
---Returns whether this game is currently paused.
---
---  * Return value (boolean): `true` if this game is paused. Only possible when the game is running.
---
---
---
---@return boolean
function m:is_paused() end

---
---Returns the current level of life of the player.
---
---  * Return value (number): The current life.
---
---
---
---@return number
function m:get_life() end

---
---Sets the style of transition to use by default when changing maps.
---
---This transition style is used when the game starts, when the game ends, and when calling [hero:teleport()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_teleport) without specifying the style of transition.
---
---  * Return value (string): The default transition style. See [game:get_transition_style()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_transition_style) for the possible values.
---
---
---
---@return string
function m:set_transition_style() end

---
---Sets the maximum number of magic points.
---
---  * `magic` (number): The maximum number of magic points to set. Must be a positive number or `0`.
---
---
---
---@param magic number
function m:set_max_magic(magic) end

---
---Creates a command released input event.
---
---Everything acts like if the player had just released an input mapped to this game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---
---
---
---#  Events of the type game
---
---Events are callback methods automatically called by the engine if you define them. In the case of a game, they are only called on the game currently running, if any.
---
---@param command string
function m:simulate_command_released(command) end

---
---Returns whether this game is currently running.
---
---Only one game can be running at a time.
---
---  * Return value (boolean): `true` if this game is running.
---
---
---
---@return boolean
function m:is_started() end

---
---Called when the game is being resumed.
---
---The game may have been unpaused by the player (by pressing the `"pause"` game command) or by you (by calling [game:set_paused(false)](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_paused)).
---
---This is probably a good place to stop your pause menu.
---
function m:on_unpaused() end

---
---Returns the current built-in effect of a game command.
---
---This function is useful if you want to show a HUD that indicates to the player the current effect of pressing a game command, especially for command `"action"` whose effect changes a lot depending on the context.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * Return value (string): A string describing the current built-in effect of this game command. `nil` means that this command has currently no built-in effect (for example because the game is paused). Possible values are:
---    * For command `"action"`: `"next"`, `"look"`, `"open"`, `"lift"`, `"throw"`, `"grab"`, `"speak"`, `"swim"`, `"run"` or `nil`.
---    * For command `"attack"`: `"sword"` or `nil`.
---    * For command `"pause"`: `"pause"`, `"return"` or `nil`.
---    * For command `"item_1"`: `"use_item_1"` or `nil`.
---    * For command `"item_2"`: `"use_item_2"` or `nil`.
---    * For command `"right"`: `"move_right"` or `nil`.
---    * For command `"left"`: `"move_left"` or `nil`.
---    * For command `"up"`: `"move_up"` or `nil`.
---    * For command `"down"`: `"move_down"` or `nil`.
---
---
---
---Remarks
---    All these built-in game commands are initially mapped to some default keyboard and joypad inputs. You can use [game:set_command_keyboard_binding()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_command_keyboard_binding), [game:set_command_joypad_binding()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_command_joypad_binding) and [game:capture_command_binding()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_capture_command_binding) to change or even disable these mappings.
---     It is also possible to override the behavior of game commands by intercepting the events [game:on_command_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_command_pressed) [game:on_command_released()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_command_released).
---
---@param command string
---@return string
function m:get_command_effect(command) end

---
---Returns the keyboard key that triggers the specified game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * Return value (string): Name of the keyboard key that triggers this game command, or `nil` if no keyboard key is mapped to this game command.
---
---
---
---@param command string
---@return string
function m:get_command_keyboard_binding(command) end

---
---Called when the player has just entered a map whose [world](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_world) is different from the previous one.
---
---Recall that maps without a world property are considered to be in their own world, different to all other maps. Therefore, if at least one of the previous and the new map has no world property, this event is necessarily called.
---
---This event is called right after [game:on_map_changed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_map_changed).
---
---  * `previous_world` (string): The world of the previous map if any, or `nil` if the previous map had no world set or if there was no previous map.
---  * `new_world` (string): The world of the new map if any, or `nil` if the mew map had no world set.
---
---
---
---Remarks
---    When you [start or restart](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start) the game, this event is always called, even if the new happens to start on a map with the same world (or even on the same map) as where the previous run finished.
---     Since the world is considered to be different from any other
---
---@param previous_world string
---@param new_world string
function m:on_world_changed(previous_world,new_world) end

---
---Returns the maximum level of life of the player.
---
---  * Return value (number): The maximum number of life points.
---
---
---
---@return number
function m:get_max_life() end

---
---Called when the user releases a finger while the game is running.
---
---  * `finger` (integer): ID of the finger that was pressed.
---  * `x` (integer): The x position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
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
---Called when the user moves a finger while the game is running.
---
---  * `finger` (integer): ID of the finger that was pressed.
---  * `x` (integer): The x position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `dx` (integer): The horizontal distance moved by finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `dy` (integer): The vertical distance moved by finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
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
---Sets a value in the savegame.
---
---This function allows to store key-value pairs in the savegame. Values can be strings, integers or booleans.
---
---  * `savegame_variable` (string): Name of the value to save (must contain alphanumeric characters or `'_'` only, and must start with a letter).
---  * `value` (string, number or boolean): The value to set, or `nil` to unset this value.
---
---
---
---Remarks
---    This method changes a value, but remember that the change will be saved in the savegame file only when you call [game:save()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_save).
---
---@param savegame_variable string
---@param value string|number|boolean
function m:set_value(savegame_variable,value) end

---
---Called at each cycle of the main loop while this game is running.
---
---Remarks
---    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) and other events.
---
function m:on_update() end

---
---Returns the maximum number of magic points.
---
---  * Return value (number): The maximum number of magic points.
---
---
---
---@return number
function m:get_max_magic() end

---
---Called when the user presses a finger while the game is running.
---
---  * `finger` (integer): ID of the finger that was pressed.
---  * `x` (integer): The x position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the finger in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
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
---Called when the user releases a mouse button while the game is running.
---
---  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * `x` (integer): The x position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
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
---Sets the maximum level of life of the player.
---
---  * `life` (number): Maximum number of life points to set. Must be a positive number.
---
---
---
---@param life number
function m:set_max_life(life) end

---
---Called when the user presses a mouse button while the game is running.
---
---  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * `x` (integer): The x position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
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
---Called when the player released a game command (a keyboard key or a joypad action mapped to a built-in game behavior). while this game is running. You can use this event to override the normal built-in behavior of the game command.
---
---  * `command` (string): Name of the built-in game command that was released. Possible commands are
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
---Pauses or resumes the game explictly.
---
---Note that by default, a built-in game command already exists to pause and unpause the game.
---
---  * `paused` (boolean, optional): `true` to pause the game, `false` to unpause it. Only possible when the game is running. No value means `true`.
---
---
---
---@param paused boolean|nil
function m:set_paused(paused) end

---
---Sets the maximum amount of money of the player.
---
---  * `money` (number): Maximum money to set. Must be a positive number or `0`.
---
---
---
---@param money number
function m:set_max_money(money) end

---
---Returns the location where the hero is placed when this game is started or restarted.
---
---  * Return value 1 (string): Id of the starting map. `nil` means that it was not set: in this case, the first map declared in [project_db.dat](https://doxygen.solarus-games.org/latest/quest_database_file.html) will be used.
---  * Return value 2 (string): Name of the destination where the hero will be placed on that map. `nil` means that it was not set: in this case, the default destination entity of that map will be used.
---
---
---
---@return string|string
function m:get_starting_location() end

---
---Called when the player has just entered a map.
---
---The new map is already started at this point. For example, you may use this event if some parts of your HUD needs to be changed on particular maps.
---
---  * `map` ([map](https://doxygen.solarus-games.org/latest/lua_api_map.html)): The new active map.
---
---
---
---Remarks
---    When you [start or restart](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start) the game, this event is always called, even if the new run happens to start on the same map as where the previous run finished.
---
---@param map map
function m:on_map_changed(map) end

---
---Adds some money to the player.
---
---  * `money` (number): Amount of money to add. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_money(game:get_money() + money)`.
---
---@param money number
function m:add_money(money) end

---
---Called when this game stops running (including when you restart the same game).
---
function m:on_finished() end

---
---Sets the location where the hero should be placed when this game is started or restarted.
---
---  * `map_id` (string, optional): Id of the starting map. By default, the first map declared in [project_db.dat](https://doxygen.solarus-games.org/latest/quest_database_file.html) is used.
---  * `destination_name` (string, optional): Name of the destination where the hero should be placed on that map. By default, the default destination of the map is used.
---
---
---
---Remarks
---    When the hero moves from a map to another map that belongs to a different world (for example, from a dungeon to the outside world) using a destination entity, by default, the starting location is automatically set to this point. If this behavior is okay for your quest, you never need to call this function except the first time: when initializing a new savegame file. This behavior can be changed by setting the "Save starting location" property of destinations, from the quest editor or from a script (with [destination:set_starting_location_mode()](https://doxygen.solarus-games.org/latest/lua_api_destination.html#lua_api_destination_set_starting_location_mode)).
---
---@param map_id string|nil
---@param destination_name string|nil
function m:set_starting_location(map_id,destination_name) end

---
---Called when the user moves a joypad axis while your game is running.
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
---Called when the user moves a joypad hat while your game is running.
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
---Called when the user releases a keyboard key while your game is running.
---
---  * `key` (string): Name of the raw key that was released.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation in this order: to the game [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html) if any, to the current map (including its own menus if any), and then to the game commands.
---
---
---
---If you handle the event, you should return `true` to make the event stop being propagated. The [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html) of your game (if any) and the current map won't be not notified in this case. On the contrary, if neither your game, its menus nor the current map handle the event, then the engine handles it with a built-in behavior. This built-in behavior is to check whether a game command is mapped to the keyboard key that was released. If yes, the "keyboard released" event will be transformed into a "game command released" event (see [game:on_command_released()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_command_released)).
---
---@param key string
---@return boolean
function m:on_key_released(key) end

---
---Adds some life to the player.
---
---  * `life` (number): Number of life points to add. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_life(game:get_life() + life)`.
---
---@param life number
function m:add_life(life) end

---
---Called when the user presses a keyboard key while your game is running.
---
---  * `key` (string): Name of the raw key that was pressed.
---  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true`.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation in this order: to the game [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html) if any, to the current map (including its own menus if any), and then to the game commands.
---
---
---
---If you handle the event, you should return `true` to make the event stop being propagated. The [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html) of your game (if any) and the current map won't be not notified in this case. On the contrary, if neither your game, its menus nor the current map handle the event, then the engine handles it with a built-in behavior. This built-in behavior is to check whether a game command is mapped to the keyboard key that was pressed. If yes, the keyboard pressed event will be transformed into a game command pressed event (see [game:on_command_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_command_pressed)).
---
---Remarks
---    This event indicates the raw keyboard key pressed. If you want the corresponding character instead (if any), see [game:on_character_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_character_pressed). If you want the corresponding higher-level game command (if any), see [game:on_command_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_command_pressed).
---
---@param key string
---@param modifiers table
---@return boolean
function m:on_key_pressed(key,modifiers) end

---
---Called when the current game-over sequence stops.
---
---This event is also called if you did not define a game-over sequence.
---
function m:on_game_over_finished() end

---
---Returns the direction (in an 8-direction system) formed by the combination of directional game commands currently pressed by the player.
---
---  * Return value (number): The direction wanted by the player (`0` to 7), or `nil` for no direction. No direction means that no directional command is pressed, or that contradictory directional commands are pressed, like left and right at the same time (impossible with most joypads, but easy with a keyboard).
---
---
---
---Remarks
---    This function is provided for convenience. Its result can also be computed by calling [game:is_command_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_command_pressed) four times (with the four directional game commands).
---
---@return number
function m:get_commands_direction() end

---
---Called when the current dialog stops.
---
---  * `dialog` (table): All properties of the dialog that was shown. See [game:on_dialog_started()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_dialog_started) for a description of this table.
---
---
---
---@param dialog table
function m:on_dialog_finished(dialog) end

---
---Called when the player presses a game command (a keyboard key or a joypad action mapped to a built-in game behavior) while this game is running. You can use this event to override the normal built-in behavior of the game command.
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
---Runs this game.
---
---This function is typically called from your savegame menu, when the player chooses its savegame file.
---
---If another game was running, it is stopped automatically because only one game can be running at a time.
---
---You can also call this function to restart the current game itself, even if it was not saved recently (saved data will not be reset). This may be useful to restart the game after the [game-over sequence](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_game_over_started).
---
function m:start() end

---
---Called when a dialog starts.
---
---The dialog may be triggered by a Lua script (by calling [game:start_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_dialog)) or by the engine in various situations (for example when finding a treasure).
---
---If this event is not defined, the engine shows a minimal dialog box without decoration and you have nothing else to do.
---
---If this event is defined, the engine does nothing and your script is responsible to show the dialog in any way you want, and to close it later by calling [game:stop_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_stop_dialog). It is recommended to implement your dialog system as a [menu](https://doxygen.solarus-games.org/latest/lua_api_menu.html): if you do so, you will automatically get called by the engine when a command is pressed, when you need to draw the dialog box on the screen, etc.
---
---  * `dialog` (table): All properties of the dialog to show. This table is identical to the one returned by [sol.language.get_dialog()](https://doxygen.solarus-games.org/latest/lua_api_language.html#lua_api_language_get_dialog). It is a table with at least the following two entries:
---
---    * `dialog_id` (string): Id of the dialog.
---    * `text` (string): Text of the dialog in the current language. It may have several lines. When it is not empty, it always ends with a newline character.
---
---The table also contains all custom entries defined in [text/dialogs.dat](https://doxygen.solarus-games.org/latest/quest_language_dialogs.html) for this dialog. These custom entries always have string keys and string values. Values that were defined as numbers in `"text/dialogs.dat"` are replaced in this table by their string representation, and values that were defined as booleans are replaced by the string `"1"` for `true` and `"0"` for `false`.
---
---  * `info` (any value, optional): Some additional information for this particular dialog. You can get here some data that is only known at runtime. See the examples of [game:start_dialog()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start_dialog).
---
---
---
---@param dialog table
---@param info any|nil
function m:on_dialog_started(dialog,info) end

---
---Called when the user enters text while your game is running.
---
---  * `character` (string): A utf-8 string representing the character that was entered.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects. If you return `false` or nothing, the event will continue its propagation in this order: to the game [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html) if any and then to the current map (including its own menus if any).
---
---
---
---Remarks
---    When a character key is pressed, two events are called: [game:on_key_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_key_pressed) (indicating the raw key) and [game:on_character_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_character_pressed) (indicating the utf-8 character). If your game needs to input text from the user, [game:on_character_pressed()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
---
---@param character string
---@return boolean
function m:on_character_pressed(character) end

---
---Called when this game starts running (including when you restart the same game).
---
function m:on_started() end

---
---Returns whether a built-in game command is currently pressed.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * Return value (boolean): `true` if this game command is currently pressed by the player.
---
---
---
---@param command string
---@return boolean
function m:is_command_pressed(command) end

---
---Makes the next keyboard or joypad input become the new binding for the specified game command.
---
---This function returns immediately. After you call it, the next time the player presses a keyboard key or performs a joypad input, this input is treated differently: instead of being forwarded to your script or handled by the engine as usual, it automatically becomes the new keyboard or joypad binding for a game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * `callback` (function, optional): A function to call when the new input occurs.
---
---
---
---Note
---    If the keyboard (or joypad) input was already mapped to a command, keyboard (or joypad) inputs of both commands are switched.
---
---@param command string
---@param callback function|nil
function m:capture_command_binding(command,callback) end

---
---Sets the amount of magic points of the player.
---
---A negative value will be replaced by zero. A value greater than than the maximum number of magic points will be replaced by that maximum.
---
---  * `magic` (number): The number of magic points to set.
---
---
---
---@param magic number
function m:set_magic(magic) end

---
---Returns whether this game is currently suspended.
---
---The game is suspended when at least one of the following conditions is true:
---
---  * the game is [paused](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_paused),
---  * or a [dialog](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_dialog_enabled) is active,
---  * or the [game-over sequence](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_is_game_over_enabled) is active,
---  * or a transition between two maps is playing,
---  * or you explicitly called [game:set_suspended(true)](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_set_suspended).
---
---
---
---  * Return value (boolean): `true` if this game is currently suspended. Only possible when the game is running.
---
---
---
---@return boolean
function m:is_suspended() end

---
---Removes some magic points from the player.
---
---  * `magic` (number): Number of magic points to remove. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_magic(game:get_magic() - magic)`.
---
---@param magic number
function m:remove_magic(magic) end

---
---Returns the joypad input that triggers the specified game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * Return value (string): A string describing what joypad input triggers this game command, or `nil` if no joypad input is mapped to this game command. This string can have one of the following forms:
---    * `"button X"` where X is the index of a joypad button (first is `0`),
---    * `"axis X +"` where X is the index of a joypad axis (first is `0`),
---    * `"axis X -"` where X is the index of a joypad axis (first is `0`),
---    * `"hat X Y"` where X is the index of a joypad hat (first is `0`) and Y is a direction (`0` to `7`).
---
---
---
---@param command string
---@return string
function m:get_command_joypad_binding(command) end

---
---Sets the keyboard key that triggers a game command.
---
---  * `command` (string): Name of a game command. Valid commands are `"action"`, `"attack"`, `"pause"`, `"item_1"`, `"item_2"`, `"right"`, `"up"`, `"left"` and `"down"`.
---  * key (string): Name of the keyboard key that should trigger this game command (`nil` means none).
---
---
---
---Note
---    If this keyboard key was already mapped to a command, keyboard keys of both commands are switched.
---
---@param command string
---@param key string
function m:set_command_keyboard_binding(command,key) end

---
---Removes some money from the player.
---
---  * `money` (number): Amount of money to remove. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_money(game:get_money() - money)`.
---
---@param money number
function m:remove_money(money) end

---
---Returns an equipment item.
---
---  * `item_name` (string): Name of the item to get.
---  * Return value ([item](https://doxygen.solarus-games.org/latest/lua_api_item.html)): The corresponding equipment item.
---
---
---
---@param item_name string
---@return item
function m:get_item(item_name) end

---
---Sets the level of an ability.
---
---  * `ability_name` (string): Name of the ability to set (see [game:get_ability()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_get_ability) for the list of valid ability names).
---  * `level` (number): Level of this ability to set (`0` removes the ability).
---
---
---
---@param ability_name string
---@param level number
function m:set_ability(ability_name,level) end

---
---Sets the level of life of the player.
---
---A negative value will be replaced by zero. A value greater than than the maximum level of life will be replaced by the maximum value.
---
---  * `life` (number): Number of life points to set.
---
---
---
---@param life number
function m:set_life(life) end

---
---Returns the equipment item assigned to a slot.
---
---  * `slot` (number): The slot to get (`1` or `2`).
---  * Return value ([item](https://doxygen.solarus-games.org/latest/lua_api_item.html)): The equipment item associated to this slot (`nil` means none).
---
---
---
---@param slot number
---@return item
function m:get_item_assigned(slot) end

---
---Returns the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html).
---
---The hero is a [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) that always exists while the game is running, and that persists when the map changes. For this reason, he can be seen as belonging to the game more than to the current map. That's why this function exists.
---
---  * Return value ([hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html)): The hero, or `nil` if the game is not running.
---
---
---
---Remarks
---    Equivalent to `game:get_map():get_entity("hero")`.
---
---@return hero
function m:get_hero() end

---
---Removes some life from the player.
---
---  * `life` (number): Number of life points to remove. Must be a positive number or `0`.
---
---
---
---Remarks
---    Equivalent to `game:set_life(game:get_life() - life)`.
---
---@param life number
function m:remove_life(life) end

---
---Returns the current number of magic points.
---
---  * Return value (number): The current number of magic points.
---
---
---
---@return number
function m:get_magic() end

_G.game = m

return m