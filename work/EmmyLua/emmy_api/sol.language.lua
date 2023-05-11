---@class sol.language
---
---`sol.language` lets you get and set the current language and manage language-specific data.
---
---Like all resources (maps, sounds, etc.), each language is identified by an id (like `"en"`, `"fr"`) and has a human-readable description (like `"English"`, `"Français"`). The language id corresponds to the name of a directory with files translated in this language: dialogs, strings and images. That directory is located in the `languages` directory of your quest.
---
---The list of languages available in your quest is specified in the [quest database file](http://www.solarus-games.org/doc/1.6/quest_database_file.html).
---
---If there is only one language in your quest, then it is automatically set as the current language. Otherwise, if you have several languages, no current language is automatically set for you, and you need to call [sol.language.set_language()](http://www.solarus-games.org/doc/1.6/lua_api_language.html#lua_api_language_set_language) to be able to use dialogs.
---
local m = {}

---
---Returns the id of the current language.
---
---  * Return value (string): The code that identifies the current language, or `nil` if no language was set.
---
---
---
---@return string
function m.get_language() end

---
---Returns the human-readable description of a language.
---
---  * `language_id` (string, optional): A language id (no value means the current language).
---  * Return value (string): The human-readable name of this language.
---
---
---
---Remarks
---    Equivalent to [sol.main.get_resource_description("language", language_id)](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_description)
---
---@param language_id string|nil
---@return string
function m.get_language_name(language_id) end

---
---Returns a dialog translated in the current language.
---
---There must be a current language when you call this function.
---
---Translated dialogs are defined in the file [text/dialogs.dat](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html) of the language-specific directory (e.g. `languages/en/text/dialogs.dat`).
---
---  * `dialog_id` (string): Id of the dialog to get.
---  * Return value (table): The corresponding dialog in the current language, or `nil` if it does not exist. The dialog is a table with at least the following two entries:
---    * `dialog_id` (string): Id of the dialog.
---    * `text` (string): Text of the dialog. The table also contains all custom entries defined in [text/dialogs.dat](http://www.solarus-games.org/doc/1.6/quest_language_dialogs.html) for this dialog. These custom entries always have string keys and string values. 
---
---
---
---@param dialog_id string
---@return table
function m.get_dialog(dialog_id) end

---
---Returns a string translated in the current language.
---
---There must be a current language when you call this function.
---
---Translated strings are defined in the file [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html) of the language-specific directory (e.g. `languages/en/text/strings.dat`).
---
---  * `key` (string): Key of the string to get. The corresponding key-value pair must be defined in [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html).
---  * Return value (string): The value associated to this key in [text/strings.dat](http://www.solarus-games.org/doc/1.6/quest_language_strings.html), or `nil` if it does not exist.
---
---
---
---@param key string
---@return string
function m.get_string(key) end

---
---Changes the current language.
---
---  * `language_id` (string): The code that identifies the new language to set. It must be a valid id as defined in your [quest database file](http://www.solarus-games.org/doc/1.6/quest_database_file.html).
---
---
---
---@param language_id string
function m.set_language(language_id) end

---
---Returns the list of available languages.
---
---  * Return value (table): An array of all language ids declared in the quest.
---
---
---
---Remarks
---    Equivalent to [sol.main.get_resource_ids("language")](http://www.solarus-games.org/doc/1.6/lua_api_main.html#lua_api_main_get_resource_ids)
---
---@return table
function m.get_languages() end

return m