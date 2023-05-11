---@class timer
---
---Timers allow you to call a function in the future with a specified delay.
---
---Here is a first example of use:
---    
---    
---    -- Play sound "secret" in one second.
---    local function play_secret_sound()
---      sol.audio.play_sound("secret")
---    end
---    
---    sol.timer.start(1000, play_secret_sound)
---    
---
---Shorter version to do the same thing:
---    
---    
---    -- Equivalent code using an anonymous function.
---    sol.timer.start(1000, function()
---      sol.audio.play_sound("secret")
---    end)
---    
---
---You can repeat a timer by returning `true` from your function:
---    
---    
---    -- Call a function every second.
---    sol.timer.start(1000, function()
---      sol.audio.play_sound("danger")
---      return true  -- To call the timer again (with the same delay).
---    end)
---    
---
---To make a timer that repeats itself 10 times, just return `false` after 10 calls:
---    
---    
---    -- Call a function ten times, with one second between each call.
---    local num_calls = 0
---    sol.timer.start(1000, function()
---      sol.audio.play_sound("danger")
---      num_calls = num_calls + 1
---      return num_calls < 10
---    end)
---    
---
---It is possible to restrict the lifetime of a timer to a context, like the game, the map or an enemy:
---    
---    
---    -- Enemy that shoots a fireball every 5 seconds until it is killed.
---    sol.timer.start(your_enemy, 5000, function()
---      sol.audio.play_sound("attack_fireball")
---      map:create_enemy(...)  -- Code that creates the fireball.
---      return true  -- Repeat the timer.
---    end)
---    
---
---Setting the context to an enemy ensures that when the enemy is killed, the timer is canceled. Otherwise, the callback function would still be called: in this example, you would hear the `"attack_fireball"` sound and the fireball would be created even if the enemy is killed in the meantime.
---
local m = {}

---
---Cancels this timer.
---
---If the timer was already finished or canceled, nothing happens.
---
---Remarks
---    Canceling timers by hand may be tedious and error-prone. In lots of cases, you can simply pass a context parameter to [sol.timer.start()](http://www.solarus-games.org/doc/1.6/lua_api_timer.html#lua_api_timer_start) in order to restrict the lifetime of your timer to some other object.
---
function m:stop() end

---
---Changes the remaining time of this timer.
---
---This function has no effect if the timer is already finished.
---
---  * `remaining_time` (number): The time remaining in milliseconds. `0` makes the timer finish now and immediately executes its callback.
---
---
---
---Remarks
---    When a timer is repeated (that is, if its callback returns `true` or a number), the timer gets rescheduled with its full delay again, no matter if you called this function in the meantime. 
---
---@param remaining_time number
function m:set_remaining_time(remaining_time) end

---
---Returns whether this timer is currently suspended.
---
---  * Return value (boolean): `true` if this timer is currently suspended.
---
---
---
---@return boolean
function m:is_suspended() end

---
---Returns whether this timer is currently suspended.
---
---  * `suspended` (boolean, optional): `true` to suspend the timer, `false` to unsuspend it (no value means `true`).
---
---
---
---@param suspended boolean|nil
function m:set_suspended(suspended) end

---
---Sets whether this timer should automatically be suspended when the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) gets suspended.
---
---The map is suspended by the engine in a few cases, like when the game is paused, when there is a dialog or when the camera is being moved by a script. When this happens, all [map entities](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) stop moving and most [sprites](http://www.solarus-games.org/doc/1.6/lua_api_sprite.html) stop their animation. With this setting, you can choose whether your timer gets suspended automatically as well.
---
---By default, [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) timers, [entity](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) timers, [state](http://www.solarus-games.org/doc/1.6/lua_api_entity.html) timers and [item](http://www.solarus-games.org/doc/1.6/lua_api_item.html) timers are suspended with the map.
---
---  * `suspended_with_map` (boolean, optional): `true` to suspend the timer when the map is suspended, `false` to continue (no value means `true`).
---
---
---
---Remarks
---    When this setting is `true`, entity timers also get automatically suspended when the entity is [disabled](http://www.solarus-games.org/doc/1.6/lua_api_entity.html#lua_api_entity_set_enabled).
---
---@param suspended_with_map boolean|nil
function m:set_suspended_with_map(suspended_with_map) end

---
---Returns whether this timer gets automatically suspended when the [map](http://www.solarus-games.org/doc/1.6/lua_api_map.html) is suspended.
---
---  * Return value (boolean): `true` if this timer gets suspended when the map is suspended.
---
---
---
---@return boolean
function m:is_suspended_with_map() end

---
---Returns whether a clock sound is played repeatedly during this timer.
---
---  * Return value (boolean): `true` if a clock sound is played with this timer.
---
---
---
---@return boolean
function m:is_with_sound() end

---
---Returns the remaining time of this timer.
---
---  * Return value (number): The time remaining in milliseconds. `0` means that the timer is finished (or will finish in the current cycle) or was canceled.
---
---
---
---@return number
function m:get_remaining_time() end

---
---Sets whether a clock sound is played repeatedly during this timer.
---
---  * `with_sound` (boolean, optional): `true` to play a clock sound repeatedly (no value means `true`).
---
---
---
---@param with_sound boolean
function m:set_with_sound(with_sound) end

_G.timer = m

return m