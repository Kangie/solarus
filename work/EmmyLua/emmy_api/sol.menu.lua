---@class sol.menu
---
---To display various information such as a title screen, a dialog box, a HUD (head-up display) or a pause screen, you can use one or several menus.
---
---A menu is an arbitrary Lua table. A menu belongs to a context that may be the current [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), the current [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), the [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) table or even another menu. This context is the lifetime of your menu. As long as your menu is active, the engine will call events that are defined in your table, i.e. callback methods like [menu:on_started()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_started) [menu:on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_draw), [menu:on_key_pressed()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_key_pressed), etc., to notify your menu of something (the player pressed a key, your menu needs to be redrawn, etc.).
---
---This menu API does not provide anything fundamental: indeed, the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) and [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) APIs already provide the necessary features, so you could do what you want from there manually. But the API described on this page makes your life easier because menus automatically receive events whenever they need to be notified, and automatically stop being active when their context no longer exists.
---
local m = {}

---
---Stops a menu previously activated with [sol.menu.start()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_start).
---
---After this call, the Solarus engine will no longer call events on your menu. But you can restart it later if you want.
---
---Nothing happens is the menu was already stopped or never started.
---
---  * `menu` (table): The menu to stop.
---
---
---
---@param menu table
function m.stop(menu) end

---
---Starts a menu in a context.
---
---The Solarus engine will then call the appropriate events on your menu until it is stopped.
---
---  * `context` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) or table): The context your menu will belong to. Similarly to the case of [timers](http://www.solarus-games.org/doc/1.6/lua_api_timer.html), the context determines the lifetime of your menu. The context must be one of the following four objects:
---    * If you make a [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) menu, your menu will be drawn above the map surface. It will be stopped when the player goes to another map. This may be useful to show head-up information local to a precise map.  
---Example: a counter or a mini-game that only exists on a specific map.  
---
---    * If you make a [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html) menu, your menu will be global to all maps. As long as the game is running, it will persist accross map changes.  
---Example: the player's life counter.  
---
---    * If you make a [main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) menu, your menu will be global to the whole program. It can exist outside a game (and it even persists during the game if you don't stop it).  
---Example: the title screen.
---    * If you set the context to another menu, then its lifetime will be limited to this other menu. This allows to make nested menus. Example: a popup that shows some information above another menu.
---    * `menu` (table): The menu to activate. It can be any table. The only thing that makes it special is the presence of callback functions (events) as described in section [Events of a menu](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_events).
---  * `on_top` (boolean, optional): Whether this menu should be drawn on top of other existing menus of the same context or behind them. If `true`, the [on_draw()](http://www.solarus-games.org/doc/1.6/lua_api_menu.html#lua_api_menu_on_draw) event of your menu will be the last to be called if there are several menus in the context. If `false`, it will be the first one. No value means `true`.
---
---
---
---@param context map|game|table
---@param menu table
---@param on_top boolean|nil
function m.start(context,menu,on_top) end

---
---Places this menu behind other menus of the same context.
---
---Your menu will then be the last one to receive input events (keyboard, joypad and mouse events) and the first one to be drawn.
---
---  * `menu` (table): The menu to bring to the back.
---
---
---
---#  Events of a menu
---
---Events are callback methods automatically called by the engine if you define them.
---
---@param menu table
function m.bring_to_back(menu) end

---
---Places this menu in front of other menus of the same context.
---
---Your menu will then be the first one to receive input events (keyboard, joypad and mouse events) and the last one to be drawn.
---
---  * `menu` (table): The menu to bring to the front.
---
---
---
---@param menu table
function m.bring_to_front(menu) end

---
---Returns whether a table is a currently active menu.
---
---  * `menu` (table): The menu to test.
---  * Return value (boolean): `true` if this is an active menu.
---
---
---
---@param menu table
---@return boolean
function m.is_started(menu) end

---
---Stops all menus that are currently running in a context.
---
---  * `context` ([map](http://www.solarus-games.org/doc/1.6/lua_api_map.html), [game](http://www.solarus-games.org/doc/1.6/lua_api_game.html), [sol.main](http://www.solarus-games.org/doc/1.6/lua_api_main.html) or table): The context where you want to stop menus.
---
---
---
---This function is not often needed since menus are already automatically stopped when their context is closed.
---
---@param context map|game|sol.main|table
function m.stop_all(context) end

return m