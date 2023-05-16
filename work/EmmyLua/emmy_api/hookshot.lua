---@class hookshot : entity
---
---A hookshot [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) is used to implement the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html)'s hookshot state.
---
---Remarks
---    Hookshot entities exist for historical reasons and are not very customizable. In new projects, we recommend to use [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html) instead.
---
local m = {}

_G.hookshot = m

return m