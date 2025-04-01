---@class sol.game
---
---This module provides a datatype "game" that represents a savegame.
---
local m = {}

---
---Returns whether the specified savegame file exists.
---
---A valid quest write directory must be set (in your [quest.dat file](https://doxygen.solarus-games.org/latest/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.
---
---  * `file_name` (string): Name of the file to test, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir).
---  * Return value (boolean): `true` if there exists a file with this name in the quest write directory.
---
---
---
---@param file_name string
---@return boolean
function m.exists(file_name) end

---
---Deletes a savegame file.
---
---A valid quest write directory must be set (in your [quest.dat](https://doxygen.solarus-games.org/latest/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.
---
---  * `file_name` (string): Name of the file to delete, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir).
---
---
---
---@param file_name string
function m.delete(file_name) end

---
---Loads an existing savegame, or initializes a new one if it does not exist (but does not save it).
---
---A valid quest write directory must be set (in your [quest.dat](https://doxygen.solarus-games.org/latest/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise savegames cannot be used and this function generates a Lua error.
---
---  * `file_name` (string): Name of a savegame file, relative to the to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir).
---  * Return value (game): The loaded (or created) game.
---
---
---
---Remarks
---    This function does not start the game, it just loads the savegame file and initializes all [equipment item scripts](https://doxygen.solarus-games.org/latest/lua_api_item.html). Then you can access the data saved in the savegame file and use the API of equipment items. To actually run the game, call [game:start()](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_start).
---
---#  Methods of the type game
---
---@param file_name string
---@return game
function m.load(file_name) end

return m