---@class npc : entity
---
---A non-playing character (NPC) is somebody or something that the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) can interact with by pressing the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands) or by using an [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) just in front of it.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_npc()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_npc).
---
local m = {}

---
---Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) uses any [equipment item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) (the player pressed an [item command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)) with this NPC, if the NPC has the property to notify its own Lua script.
---
---  * `item_used` ([item](http://www.solarus-games.org/doc/1.6/lua_api_item.html)): The item currently used by the player.
---  * Return value (boolean): `true` if an interaction happened. If you return `false` or nothing, then [item_used:on_using()](http://www.solarus-games.org/doc/1.6/lua_api_item.html#lua_api_item_on_using) will be called (just like if there was no NPC in front of the hero).
---
---
---
---@param item_used item
---@return boolean
function m:on_interaction_item(item_used) end

---
---Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) interacts (the player pressed the [action command](http://www.solarus-games.org/doc/1.6/lua_api_game.html#lua_api_game_overview_commands)) in front of this NPC, if the NPC has the property to notify its own Lua script.
---
function m:on_interaction() end

---
---Returns whether this NPC can be traversed by other entities.
---
---By default, NPCs are not traversable. However, be aware that some entities can override this setting. Indeed, other NPCs, [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and projectiles ([thrown objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html), [arrows](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html), [boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html)) can traverse usual NPCs but cannot traverse generalized NPCs. And [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) can have finer customization.
---
---  * Return value (boolean): `true` if this NPC is traversable.
---
---
---
---@return boolean
function m:is_traversable() end

---
---Called when [fire](http://www.solarus-games.org/doc/1.6/lua_api_fire.html) touches this NPC, if the NPC has the property to notify its own Lua script. 
---
function m:on_collision_fire() end

---
---Sets whether this NPC can be traversed by other entities.
---
---By default, NPCs are not traversable. However, be aware that some entities can override this setting. Indeed, other NPCs, [enemies](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) and projectiles ([thrown objects](http://www.solarus-games.org/doc/1.6/lua_api_carried_object.html), [arrows](http://www.solarus-games.org/doc/1.6/lua_api_arrow.html), [boomerang](http://www.solarus-games.org/doc/1.6/lua_api_boomerang.html)) can traverse usual NPCs but cannot traverse generalized NPCs. And [custom entities](http://www.solarus-games.org/doc/1.6/lua_api_custom_entity.html) can have finer customization.
---
---If you want to allow the [hero](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) to be able to traverse this NPC, you can use this function.
---
---  * `traversable` (boolean, optional): `true` to make this NPC traversable. No value means `true`.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Non-playing characters are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type non-playing character
---
---The following events are specific to non-playing characters.
---
---@param traversable boolean|nil
function m:set_traversable(traversable) end

_G.npc = m

return m