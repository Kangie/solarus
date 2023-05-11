---@class shop_treasure : entity
---
---A shop treasure is a treasure that can be purchased by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) for money.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_shop_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_shop_treasure).
---
local m = {}

---
---Called when the player has just bought this treasure.
---
---  * Return value (boolean): `true` if the player is allowed to buy the treasure.
---
---
---
---Remarks
---    This event is called right after the more general events [item:on_obtaining()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_obtaining) and [map:on_obtaining_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_on_obtaining_treasure). Those two events are called no matter how the treasure is being obtained: from a [chest](http://www.solarus-games.org/doc/1.6/lua_api_chest.html), from a [pickable treasure](http://www.solarus-games.org/doc/1.6/lua_api_pickable.html), from a shop treasure or explicitly with [hero:start_treasure()](http://www.solarus-games.org/doc/1.6/lua_api_hero.html#lua_api_hero_start_treasure). 
---
---@return boolean
function m:on_bought() end

---
---Called when the player is about to buy this treasure.
---
---He already accepted to buy it and validated the dialog. At this point, you may cancel the deal for some reason by returning `false` (for example if you realize that the player has no bottle and therefore cannot buy the potion he wanted).
---
---  * Return value (boolean): `true` if the player is allowed to buy the treasure.
---
---
---
---@return boolean
function m:on_buying() end

_G.shop_treasure = m

return m