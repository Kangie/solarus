---@class camera : entity
---
---The camera is a rectangular shape that determines the visible part of the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html). There is always exactly one camera on the current map. The camera is automatically created by the engine when loading a map. You cannot create or remove it. To access the camera of the map from one of your scripts, you can use [map:get_camera()](https://doxygen.solarus-games.org/latest/lua_api_map.html#lua_api_map_get_camera).
---
local m = {}

---
---Returns where the camera is displayed on the quest screen.
---
---The default position is `0, 0`, meaning that the upper left corner of the camera is displayed on the upper left corner of the screen.
---
---  * Return value 1 (number): X coordinate of the camera on the screen, in quest screen coordinates.
---  * Return value 2 (number): Y coordinate of the camera on the screen, in quest screen coordinates.
---
---
---
---@return number|number
function m:get_position_on_screen() end

---
---Returns the name of the current state of the camera.
---
---  * Return value (string): The current camera state: `"tracking"` or `"manual"`.
---
---
---
---@return string
function m:get_state() end

---
---Returns the entity currently tracked by this camera, if any.
---
---  * Return value (entity): The tracked entity if the camera is in tracking state, or `nil` if the camera is not in tracking state.
---
---
---
---@return entity
function m:get_tracked_entity() end

---
---Called when the state of the camera has just changed.
---
---  * `new_state_name` (string): Name of the new state. See [camera:get_state()](https://doxygen.solarus-games.org/latest/lua_api_camera.html#lua_api_camera_get_state) for the list of possible state names.
---
---
---
---Remarks
---    When the map starts, the initial state of the camera always `"tracking"`, because the camera initially tracks the hero. 
---
---@param new_state_name string
function m:on_state_changed(new_state_name) end

---
---Switches the camera to tracking state.
---
---The camera will be focused on an entity to track, and follow it when it moves.
---
---When the tracked entity crosses a separator, the engine automatically starts a scrolling movement on the camera. The game is automatically suspended during the scrolling. After the scrolling, the camera continues to normally track the entity on the other side of the separator.
---
---  * `entity` (entity): The entity to track.
---
---
---
---@param entity entity
function m:start_tracking(entity) end

---
---Called when the state of the camera is about to change.
---
---  * `state_name` (string): Name of the current state. See [camera:get_state()](https://doxygen.solarus-games.org/latest/lua_api_camera.html#lua_api_camera_get_state) for the list of possible state names.
---  * `next_state_name` (string): Name of the state about to start. See [camera:get_state()](https://doxygen.solarus-games.org/latest/lua_api_camera.html#lua_api_camera_get_state) for the list of possible state names.
---
---
---
---@param state_name string
---@param next_state_name string
function m:on_state_changing(state_name,next_state_name) end

---
---Returns the [surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html) this camera draws its content to.
---
---The size of this surface is the size of the camera.
---
---  * Return value ([surface](https://doxygen.solarus-games.org/latest/lua_api_surface.html)): The camera's surface.
---
---
---
---#  Events inherited from map entity
---
---Events are callback methods automatically called by the engine if you define them.
---
---A camera is a particular [map entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html). Therefore, it inherits all events from the type map entity.
---
---See [Events of all entity types](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_events) to know these events.
---
---#  Events of the type camera
---
---The following events are specific to cameras.
---
---@return surface
function m:get_surface() end

---
---Sets where the camera is displayed on the quest screen.
---
---You can use this function in conjunction with [camera:set_size()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_set_size) to display the camera only on a subpart of the screen and for example keep the rest of the space for the HUD.
---
---The default position is `0,0`, meaning that the upper left corner of the camera is displayed on the upper left corner of the screen.
---
---  * `x` (number): X coordinate of the camera on the screen, in quest screen coordinates.
---  * `y` (number): Y coordinate of the camera on the screen, in quest screen coordinates.
---
---
---
---@param x number
---@param y number
function m:set_position_on_screen(x,y) end

---
---Switches the camera to manual state.
---
---Remarks
---    The camera automatically switches to manual state if you start a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_start) on it.
---
function m:start_manual() end

---
---Returns the coordinates this camera should have in order to track the given entity or point, respecting constraints of map limits and separators.
---
---The returned coordinates make their best to have the entity or point centered in the camera, but make sure that the camera does not cross [separators](https://doxygen.solarus-games.org/latest/lua_api_separator.html) or map limits. This function can be used to compute legal coordinates for the camera, and for example pass them to [camera:set_position()](https://doxygen.solarus-games.org/latest/lua_api_entity.html#lua_api_entity_set_position) or start a [movement](https://doxygen.solarus-games.org/latest/lua_api_movement.html#lua_api_movement_start).
---
---To get coordinates that center the camera on a map entity:
---
---  * `entity` ([entity](https://doxygen.solarus-games.org/latest/lua_api_entity.html)) The entity to center the camera on.
---
---
---
---To get coordinates that center the camera on a point:
---
---  * `x` (number): X coordinate of the point to center the camera on.
---  * `y` (number): Y coordinate of the point to center the camera on.
---
---
---
---@param entity number
function m:get_position_to_track(entity) end

_G.camera = m

return m