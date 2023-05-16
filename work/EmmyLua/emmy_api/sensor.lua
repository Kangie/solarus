---@class sensor : entity
---
---A sensor is an invisible detector that triggers something when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) overlaps it.
---
---This type of [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html) can be declared in the [map data file](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_sensor()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_create_sensor).
---
local m = {}

---
---Called when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) stops overlapping this sensor.
---
function m:on_left() end

---
---Called continuously while the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) overlaps this sensor.
---
function m:on_activated_repeat() end

---
---Called when the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) overlaps this sensor.
---
---The bounding box of the hero (of size 16x16 pixels) must fit entirely the sensor. This means that if the sensor has a size of 16x16, the hero and the sensor must overlap perfectly.
---
---This event is the right place to define the action that you want your sensor to perform.
---
function m:on_activated() end

---
---Called when an [explosion](https://doxygen.solarus-games.org/latest/lua_api_explosion.html) touches this sensor. 
---
function m:on_collision_explosion() end

_G.sensor = m

return m