---@class sol.file
---
---This module provides functions to manually read and write files from the quest data directory and from quest write directory.
---
local m = {}

---
---Returns whether the specified file or directory exists in the quest write directory or in the data directory.
---
---If a valid quest write directory is set (in your [quest.dat file](https://doxygen.solarus-games.org/latest/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), that directory is tried first. Then, the `data` directory of your quest is tried.
---
---  * `file_name` (string): Name of the file to test, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir) or to the data directory.
---  * Return value (boolean): `true` if there exists a file or directory with this name.
---
---
---
---@param file_name string
---@return boolean
function m.exists(file_name) end

---
---Returns the list of files in a directory.
---
---  * `dir_name` (string): Name of the directory to explore, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir) or to the data directory.
---  * Return value (table): An array with the name of files and directories inside the directory. Names are ordered alphabetically. Returns `nil` if the given name is not a directory or does not exist. 
---
---
---
---@param dir_name string
---@return table
function m.list_dir(dir_name) end

---
---Deletes a file or a directory from the quest write directory.
---
---A valid quest write directory must be set (in your [quest.dat](https://doxygen.solarus-games.org/latest/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.
---
---  * `file_name` (string): Name of the file to delete, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir). If it is a directory, it must be empty before you delete it.
---  * Return value (boolean and string): `true` in case of success, `nil` plus an error message in case of failure.
---
---
---
---@param file_name string
---@return boolean,string
function m.remove(file_name) end

---
---Same as [io.open()](http://www.lua.org/manual/5.1/manual.html#pdf-io.open), but relative to the quest write directory or to the data directory.
---
---If a valid quest write directory is set (in your [quest.dat file](https://doxygen.solarus-games.org/latest/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), that directory is tried first. Then, the `data` directory of your quest is tried if the mode is `"r"` (read mode).
---
---This function just calls `io.open()` with the actual path and the mode as parameters, and returns its results.
---
---  * `file_name` (string): Name of the file to open, relative to the quest write directory or to the data directory.
---  * `mode` (string, optional): Opening mode (see the Lua documentation of [io.open()](http://www.lua.org/manual/5.1/manual.html#pdf-io.open) ).
---  * Return value (file or nil+string): The file object created, or `nil` plus an error message in case of failure. The file value is the standard Lua file object as returned by `io.open()`, and you can then use all Lua file functions (file:read(), file:write(), file:lines(), file:close(), etc.).
---
---
---
---@param file_name string
---@param mode string|nil
---@return file|nil,string
function m.open(file_name,mode) end

---
---Renames a file or a directory in the quest write directory.
---
---A valid quest write directory must be set (in your [quest.dat](https://doxygen.solarus-games.org/latest/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.
---
---  * `old_file_name` (string): Name of the file to rename, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir).
---  * `new_file_name` (string): New name to set, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir).
---  * Return value (boolean and string): `true` in case of success, `nil` plus an error message in case of failure.
---
---
---
---@param old_file_name string
---@param new_file_name string
---@return boolean,string
function m.rename(old_file_name,new_file_name) end

---
---Creates a directory in the quest write directory.
---
---A valid quest write directory must be set (in your [quest.dat](https://doxygen.solarus-games.org/latest/quest_properties_file.html) file or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), otherwise this function generates a Lua error.
---
---  * `dir_name` (string): Name of the directory to delete, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir).
---  * Return value (boolean or nil+string): `true` in case of success, `nil` plus an error message in case of failure.
---
---
---
---@param dir_name string
---@return boolean|nil,string
function m.mkdir(dir_name) end

---
---Returns whether the specified file exists and is a directory.
---
---If a valid quest write directory is set (in your [quest.dat file](https://doxygen.solarus-games.org/latest/quest_properties_file.html) or by calling [sol.main.set_quest_write_dir()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_set_quest_write_dir)), that directory is tried first. Then, the `data` directory of your quest is tried.
---
---  * `file_name` (string): Name of the file to test, relative to the [quest write directory](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_get_quest_write_dir) or to the data directory.
---  * Return value (boolean): `true` if there exists a directory with this name.
---
---
---
---@param file_name string
---@return boolean
function m.is_dir(file_name) end

return m