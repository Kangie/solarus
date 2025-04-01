---@class wall : entity
---
---A wall is an invisible obstacle that stops some specific types of [map entities](https://doxygen.solarus-games.org/latest/lua_api_entity.html).
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_wall()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_wall).
---
local m = {}

_G.wall = m

return m