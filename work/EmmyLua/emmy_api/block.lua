---@class block : entity
---
---Blocks are solid [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that may be pushed or pulled by the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_block()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_block).
---
local m = {}

---
---Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) has just moved this block of a step.
---
---#  Deprecated methods of the type block
---
---The following methods are deprecated and may be removed it future releases.
---
function m:on_moved() end

---
---Returns whether this block can be pulled.
---
---This property is independent of whether or not the block was already moved its maximum number of times.
---
---  * Return value (boolean): `true` if this block can be pulled.
---
---
---
---@return boolean
function m:is_pullable() end

---
---Sets whether this block can be pulled.
---
---This property is independent of whether or not the block was already moved its maximum number of times.
---
---  * `pullable` (boolean): `true` to make this block pullable. No value means `true`.
---
---
---
---@param pullable boolean|nil
function m:set_pullable(pullable) end

---
---Sets the maximum number of times the block can be moved.
---
---This resets the remaining allowed moves.
---
---  * `maximum_moves` (number or nil): How many times the block can be moved. `nil` means unlimited.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Blocks are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type block
---
---The following events are specific to blocks.
---
function m:set_max_moves() end

---
---Sets whether this block can be pushed.
---
---This property is independent of whether or not the block was already moved its maximum number of times.
---
---  * `pushable` (boolean): `true` to make this block pushable. No value means `true`.
---
---
---
---@param pushable boolean|nil
function m:set_pushable(pushable) end

---
---Restores the block at its initial position and resets its counter of moves.
---
---It means that the hero will be able to move again a block that could only be moved a limited number of times even if the limit was reached.
---
function m:reset() end

---
---Returns whether this block can be pushed.
---
---This property is independent of whether or not the block was already moved its maximum number of times.
---
---  * Return value (boolean): `true` if this block can be pushed.
---
---
---
---@return boolean
function m:is_pushable() end

---
---Called when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) starts moving the block of a step.
---
function m:on_moving() end

---
---Returns the maximum number of times the block can be moved.
---
---This function returns the maximum moves value that was set at creation time or by [block:set_max_moves()](http://www.solarus-games.org/doc/1.6/lua_api_block.html#lua_api_block_set_max_moves), no matter if the block was moved then.
---
---  * Return value (number or nil): How many times the block can be moved. `nil` means unlimited.
---
---
---
---@return number|nil
function m:get_max_moves() end

_G.block = m

return m