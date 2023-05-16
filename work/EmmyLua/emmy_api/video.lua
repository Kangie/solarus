---@class video
---
---`sol.video` allows you to manage the window and the display.
---
---The area where the game takes place has a fixed size called the quest size. The quest size is in a range specified in the [quest properties file](https://doxygen.solarus-games.org/latest/quest_properties_file.html). This quest size is the logical size: it determines how much content the player can see on the map.
---
---The quest size is typically 320x240 pixels, but some systems may prefer other sizes, like 400x240 on Android. You can set a range of supported quest sizes in the quest properties files for portability. However, it requires more work on your part: in particular, you have to implement menus and a HUD that can adapt to any size in this range. And be aware that some players will be able to see more game content than others.
---
---The quest can be played in windowed mode or in fullscreen. In windowed mode, the window can be resized by the user or by your scripts. The quest size is independent from the actual window size: when you resize the window, the quest image is scaled to fit the window. The pixel ratio is always preserved, possibly by adding black borders.
---
---Solarus supports OpenGL shaders to modify the rendering, for example to apply a smoothing filter. See the [shader](https://doxygen.solarus-games.org/latest/lua_api_shader.html) documentation for more details.
---
local m = {}

_G.video = m

return m