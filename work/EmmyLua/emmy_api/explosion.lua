---@class explosion : entity
---
---This is an explosion whose sprite hurts the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) and [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html).
---
---You can create this type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) only dynamically with [map:create_explosion()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_explosion). It cannot be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files).
---
---Remarks
---    Explosion entities exist for historical reasons and are not very customizable. In new projects, we recommend to use [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html) instead.
---
local m = {}

_G.explosion = m

return m