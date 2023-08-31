---@class bomb : entity
---
---A bomb is an entity that explodes after a few seconds.
---
---You can create this type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) only dynamically with [map:create_bomb()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_bomb). It cannot be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files).
---
---Remarks
---    Bomb entities exist for historical reasons and are not very customizable. In new projects, we recommend to use [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html) instead.
---
local m = {}

_G.bomb = m

return m