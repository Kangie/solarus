---@class menu
---
---To display various information such as a title screen, a dialog box, a HUD (head-up display) or a pause screen, you can use one or several menus.
---
---A menu is an arbitrary Lua table. A menu belongs to a context that may be the current [map](https://doxygen.solarus-games.org/latest/lua_api_map.html), the current [game](https://doxygen.solarus-games.org/latest/lua_api_game.html), the [sol.main](https://doxygen.solarus-games.org/latest/lua_api_main.html) table or even another menu. This context is the lifetime of your menu. As long as your menu is active, the engine will call events that are defined in your table, i.e. callback methods like [menu:on_started()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_started) [menu:on_draw()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_draw), [menu:on_key_pressed()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_key_pressed), etc., to notify your menu of something (the player pressed a key, your menu needs to be redrawn, etc.).
---
---This menu API does not provide anything fundamental: indeed, the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html), [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) and [sol.main](https://doxygen.solarus-games.org/latest/lua_api_main.html) APIs already provide the necessary features, so you could do what you want from there manually. But the API described on this page makes your life easier because menus automatically receive events whenever they need to be notified, and automatically stop being active when their context no longer exists.
---
local m = {}

---
---Called when the user moves a joypad hat while your menu is active. Menus on top are notified first.
---
---  * `hat` (number): Index of the hat that was moved.
---  * `direction8` (number): The new direction of the hat. `-1` means that the hat is centered. `0` to `7` indicates that the hat is in one of the eight main directions.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)).
---
---
---
---@param hat number
---@param direction8 number
---@return boolean
function m:on_joypad_hat_moved(hat,direction8) end

---
---Called when the user releases a keyboard key while your menu is active. Menus on top are notified first.
---
---  * `key` (string): Name of the raw key that was released.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)).
---
---
---
---@param key string
---@return boolean
function m:on_key_released(key) end

---
---Called during a game when the player presses a [game command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) (a keyboard key or a joypad action mapped to a built-in game behavior). You can use this event to override the normal built-in behavior of the game command. Menus on top are notified first.
---
---  * `command` (string): Name of the built-in game command that was pressed (see the [game API](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) for the list of existing game commands).
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of pressing this game command).
---
---
---
---Remarks
---    As the notion of game commands only exist during a game, this event is only called for game menus and map menus.
---     This event is not triggered if you already handled the underlying low-level keyboard or joypad event.
---
---@param command string
---@return boolean
function m:on_command_pressed(command) end

---
---Called when the user presses a keyboard key while your menu is active.
---
---  * `key` (string): Name of the raw key that was pressed.
---  * `modifiers` (table): A table whose keys indicate what modifiers were down during the event. Possible table keys are `"shift"`, `"control"` and `"alt"`. Table values are `true`.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)).
---
---
---
---For all keyboard, joypad and mouse events, menus are notified from the front one to the back one. For example, if some dialog box is shown during the pause menu and appears above that pause menu, it will naturally receive keyboard and joypad events first.
---
---When a menu handles the event, it should return `true` to make the event stop being propagated. Menus (and other objects) below it won't be notified then. On the contrary, if no script has handled the event, then the engine can handle it with a built-in behavior.
---
---Remarks
---    This event indicates the raw key pressed. If you want the corresponding character instead (if any), see [menu:on_character_pressed()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_character_pressed).
---
---@param key string
---@param modifiers table
---@return boolean
function m:on_key_pressed(key,modifiers) end

---
---Called when the user enters text while your menu is active. Menus on top are notified first.
---
---  * `character` (string): A utf-8 string representing the character that was pressed.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus).
---
---
---
---Remarks
---    When a character key is pressed, two events are called: [menu:on_key_pressed()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_key_pressed) (indicating the raw key) and [menu:on_character_pressed()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_character_pressed) (indicating the utf-8 character). If your menu needs to input text from the user, [menu:on_character_pressed()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_on_character_pressed) is what you want because it considers the keyboard's layout and gives you international utf-8 strings.
---
---@param character string
---@return boolean
function m:on_character_pressed(character) end

---
---Called during a game when the player released a game command (a keyboard key or a joypad action mapped to a built-in game behavior). You can use this event to override the normal built-in behavior of the game command. Menus on top are notified first.
---
---  * `command` (string): Name of the built-in game command that was released (see the [game API](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) for the list of existing game commands).
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (you are overriding the built-in behavior of releasing this game command).
---
---
---
---Remarks
---    As the notion of game commands only exist during a game, this event is only called for game menus and map menus.
---     This event is not triggered if you already handled the underlying low-level keyboard or joypad event.
---
---@param command string
---@return boolean
function m:on_command_released(command) end

---
---Called when your menu is started.
---
---This event is triggered when you call [sol.menu.start()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_start).
---
function m:on_started() end

---
---Called when the user releases a mouse button while this menu is active.
---
---  * `button` (string): Name of the mouse button that was released. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * `x` (integer): The x position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus).
---
---
---
---@param button string
---@param x integer
---@param y integer
---@return boolean
function m:on_mouse_released(button,x,y) end

---
---Called when the user presses a mouse button while this menu is active. Menus on top are notified first.
---
---  * `button` (string): Name of the mouse button that was pressed. Possible values are `"left"`, `"middle"`, `"right"`, `"x1"` and `"x2"`.
---  * `x` (integer): The x position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * `y` (integer): The y position of the mouse in [quest size](https://doxygen.solarus-games.org/latest/lua_api_video.html#lua_api_video_get_quest_size) coordinates.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus).
---
---
---
---@param button string
---@param x integer
---@param y integer
---@return boolean
function m:on_mouse_pressed(button,x,y) end

---
---Called at each cycle of the main loop while your menu is active.
---
---Menus of are updated in the following order:
---
---  1. [Map](https://doxygen.solarus-games.org/latest/lua_api_map.html) menus (only during a game).
---  2. [Game](https://doxygen.solarus-games.org/latest/lua_api_game.html) menus (only during a game).
---  3. [Main](https://doxygen.solarus-games.org/latest/lua_api_main.html) menus (the more general ones).
---
---
---
---When several menus exist in the same context, they are updated from the back one to the front one. You can control this order thanks to the `on_top` parameter of [menu:start()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_start) when you start a menu.
---
---Remarks
---    As this function is called at each cycle, it is recommended to use other solutions when possible, like [timers](https://doxygen.solarus-games.org/latest/lua_api_timer.html) and other events.
---
function m:on_update() end

---
---Called when the user presses a joypad button while your menu is active. Menus on top are notified first.
---
---  * `button` (number): Index of the button that was pressed.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)).
---
---
---
---@param button number
---@return boolean
function m:on_joypad_button_pressed(button) end

---
---Called when your menu is stopped.
---
---This event is triggered when you call [sol.menu.stop()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_stop) or when the context of your menu finishes.
---
function m:on_finished() end

---
---Called when your menu has to be redrawn.
---
---Use this event to draw your menu.
---
---  * `dst_surface` ([surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html)): The surface where you should draw your menu.
---
---
---
---Menus of are drawn in the following order:
---
---  1. [Map](https://doxygen.solarus-games.org/latest/lua_api_map.html) menus (only during a game).
---  2. [Game](https://doxygen.solarus-games.org/latest/lua_api_game.html) menus (only during a game).
---  3. [Main](https://doxygen.solarus-games.org/latest/lua_api_main.html) menus (the more general ones).
---
---
---
---When several menus exist in the same context, they are drawn from the back one to the front one. You can control this order thanks to the `on_top` parameter of [sol.menu.start()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_start) when you start a menu, or with [sol.menu.bring_to_front()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_bring_to_front) and [sol.menu.bring_to_back()](https://doxygen.solarus-games.org/latest/lua_api_menu.html#lua_api_menu_bring_to_back)
---
---@param dst_surface surface
function m:on_draw(dst_surface) end

---
---Called when the user presses a finger while the menu is running.
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
---Called when the user moves a joypad axis while your menu is active. Menus on top are notified first.
---
---  * `axis` (number): Index of the axis that was moved. Usually, `0` is an horizontal axis and `1` is a vertical axis.
---  * `state` (number): The new state of the axis that was moved. `-1` means left or up, `0` means centered and `1` means right or down.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)).
---
---
---
---@param axis number
---@param state number
---@return boolean
function m:on_joypad_axis_moved(axis,state) end

---
---Called when the user releases a joypad button while your menu is active. Menus on top are notified first.
---
---  * `button` (number): Index of the button that was released.
---  * Return value (boolean): Indicates whether the event was handled. If you return `true`, the event won't be propagated to other objects (like other menus or the built-in [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)).
---
---
---
---@param button number
---@return boolean
function m:on_joypad_button_released(button) end

---
---Called when the user releases a finger while the menu is running.
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
---Called when the user moves a finger while the menu is running.
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

_G.menu = m

return m