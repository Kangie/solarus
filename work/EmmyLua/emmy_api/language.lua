---@class language
---
---`sol.language` lets you get and set the current language and manage language-specific data.
---
---Like all resources (maps, sounds, etc.), each language is identified by an id (like `"en"`, `"fr"`) and has a human-readable description (like `"English"`, `"Fran�ais"`). The language id corresponds to the name of a directory with files translated in this language: dialogs, strings and images. That directory is located in the `languages` directory of your quest.
---
---The list of languages available in your quest is specified in the [quest database file](https://doxygen.solarus-games.org/latest/quest_database_file.html).
---
---If there is only one language in your quest, then it is automatically set as the current language. Otherwise, if you have several languages, no current language is automatically set for you, and you need to call [sol.language.set_language()](https://doxygen.solarus-games.org/latest/lua_api_language.html#lua_api_language_set_language) to be able to use dialogs.
---
local m = {}

_G.language = m

return m