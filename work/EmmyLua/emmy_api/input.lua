---@class input
---
---You can get information about the low-level keyboard and joypad inputs through `sol.input`.
---
---But remember that when a low-level keyboard or joypad input event occurs, all useful objects ([sol.main](https://doxygen.solarus-games.org/latest/lua_api_main.html), the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html), [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) and [menus](https://doxygen.solarus-games.org/latest/lua_api_menu.html)) are already notified. For example, when the user presses a keyboard key, the engine automatically calls [sol.main:on_key_pressed()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_on_key_pressed).
---
---Also note that during the game, there exists the higher-level notion of [game commands](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) to ease your life.
---
local m = {}

_G.input = m

return m