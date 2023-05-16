---@class crystal_block : entity
---
---A crystal block is a colored low wall that may be raised or lowered in the ground.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_crystal_block()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_crystal_block).
---
---Remarks
---    Crystal blocks provide very specific behavior for historical reasons and are not very customizable. If you need more flexibility, we recommend to use [custom entities](https://doxygen.solarus-games.org/latest/lua_api_custom_entity.html) instead and to script the behavior you want.
---
local m = {}

_G.crystal_block = m

return m