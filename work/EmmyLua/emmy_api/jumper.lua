---@class jumper : entity
---
---A jumper is an invisible detector that makes the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) jump into one of the 8 main directions when touching it.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_jumper()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_jumper).
---
local m = {}

_G.jumper = m

return m