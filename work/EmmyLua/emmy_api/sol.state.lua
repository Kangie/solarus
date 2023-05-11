---@class sol.state
---
---This module provides a datatype `state` that represents a custom state allowing advanced customization of the [hero](http://www.solarus-games.org/doc/1.6/lua_api_hero.html).
---
local m = {}

---
---Creates a custom state but does not start it yet.
---
---  * `description` (string, optional): An optional description of your state. The engine does nothing special with this description, but it may help you distinguish states.
---  * Return value (state): The custom state created.
---
---
---
---#  Methods of the type state
---
---@param description string|nil
---@return state
function m.create(description) end

return m