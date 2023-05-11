---@class carried_object : entity
---
---A carried object is a [map entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) is lifting, carrying or throwing.
---
local m = {}

---
---Returns the [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) that carried this object.
---
---  * Return value ([entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html)): The carrier entity.
---
---
---
---@return entity
function m:get_carrier() end

---
---Returns the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.
---
---  * Return value (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.
---
---
---
---@return number
function m:get_damage_on_enemies() end

---
---Sets the sound to be played when this object is cut or broken.
---
---  * `destruction_sound_id` (string): Id of the destruction sound. `nil` means that no sound will be played.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---Carried objects are particular [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html). Therefore, they inherit all events from the type map entity.
---
---See [Events of all entity types](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type carried object
---
---The following events are specific to carried objects.
---
---@param destruction_sound_id string
function m:set_destruction_sound(destruction_sound_id) end

---
---Called when this object falls on the ground and starts breaking. 
---
function m:on_breaking() end

---
---Called when this object starts being thrown.
---
function m:on_thrown() end

---
---Sets the number of life points that an [enemy](http://www.solarus-games.org/doc/1.6/lua_api_enemy.html) loses when the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html) throws this object at it.
---
---  * `damage_on_enemies` (number): The number of life points to remove to an enemy hit by this object. `0` means that enemies will ignore this object.
---
---
---
---@param damage_on_enemies number
function m:set_damage_on_enemies(damage_on_enemies) end

---
---Returns the sound to be played when this object is cut or broken.
---
---  * Return value (string): Id of the destruction sound. `nil` means that no sound will be played.
---
---
---
---@return string
function m:get_destruction_sound() end

---
---Called when this object has finished being lifted and is now actually carried.
---
function m:on_lifted() end

_G.carried_object = m

return m