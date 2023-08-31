---@class crystal : entity
---
---A crystal is a switch that lowers or raises alternatively some special colored blocks in the ground called [crystal blocks](https://doxygen.solarus-games.org/latest/lua_api_crystal_block.html).
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_crystal()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_crystal).
---
---Remarks
---    Crystals provide very specific behavior for historical reasons and are not very customizable. If you need more flexibility, we recommend to use [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html) instead and to script the behavior you want.
---
local m = {}

_G.crystal = m

return m