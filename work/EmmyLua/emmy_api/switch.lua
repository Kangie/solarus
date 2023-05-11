---@class switch : entity
---
---A switch is a button that can be activated to trigger a mechanism.
---
---This type of [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) can be declared in the [map data file](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_overview_files). It can also be created dynamically with [map:create_switch()](http://www.solarus-games.org/doc/1.6/lua_api_map.html#lua_api_map_create_switch).
---
local m = {}

---
---Returns whether this switch is current locked.
---
---When a switch is locked, its state cannot change anymore: it can no longer be activated or inactivated by other entities. However, it can still changed programmatically by calling [switch:set_activated()](http://www.solarus-games.org/doc/1.6/lua_api_switch.html#lua_api_switch_set_activated).
---
---  * Return value (boolean): `true` if this switch is currently activated.
---
---
---
---@return boolean
function m:is_locked() end

---
---Locks this switch in its current state or unlocks it.
---
---When a switch is locked, its state cannot change anymore: it can no longer be activated or inactivated by other entities. However, it can still changed programmatically by calling [switch:set_activated()](http://www.solarus-games.org/doc/1.6/lua_api_switch.html#lua_api_switch_set_activated).
---
---  * `locked` (boolean, optional): `true` to lock the switch, `false` to unlock it. No value means `true`.
---
---
---
---Remarks
---    The method [switch:set_activated()](http://www.solarus-games.org/doc/1.6/lua_api_switch.html#lua_api_switch_set_activated) works even on a locked switch.
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Switches are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type switch
---
---The following events are specific to switches.
---
---@param locked boolean|nil
function m:set_locked(locked) end

---
---Returns whether this switch is activated.
---
---  * Return value (boolean): `true` if this switch is currently activated.
---
---
---
---@return boolean
function m:is_activated() end

---
---Returns whether this is a walkable switch.
---
---  * Return value (boolean): `true` if this switch is a walkable one.
---
---
---
---@return boolean
function m:is_walkable() end

---
---Called when a switch has just been turned off.
---
function m:on_inactivated() end

---
---Called when an entity placed on a switch (like the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) or a [block](http://www.solarus-games.org/doc/1.6/lua_api_block.html)) has just left the switch, regardless of whether the switch was activated or not. 
---
function m:on_left() end

---
---Called when this switch has just been turned on.
---
---This is the right place to define the action that you want your switch to perform.
---
function m:on_activated() end

---
---Sets whether this switch is activated or not.
---
---The change is quiet and immediate: no sound is played and no event is triggered.
---
---  * `activated` (boolean, optional): `true` to make the switch activated, `false` to make is inactivated. No value means `true`.
---
---
---
---@param activated boolean|nil
function m:set_activated(activated) end

_G.switch = m

return m