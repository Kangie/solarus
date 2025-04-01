---@class sol.audio
---
---You can play musics and sound effects through `sol.audio`.
---
local m = {}

---
---Sets the tempo of the current .it music.
---
---This function is only supported for .it musics.
---
---  * `tempo` (number): Tempo to set. 
---
---
---
---@param tempo number
function m.set_tempo(tempo) end

---
---Returns the current volume of musics.
---
---This volume applies to all musics played by [sol.audio.play_music(music_id, [action])](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_music). "sol.audio.play_music()"
---
---  * Return value (number): The current volume of musics, as an integer between `0` (no sound effects) and `100` (full volume).
---
---
---
---Remarks
---    When the quest is run from the Solarus GUI, the user can also change the volume from the menus of the GUI.
---
---@return number
function m.get_music_volume() end

---
---Plays a music.
---
---If the music does not exist, a Lua error is generated.
---
---Only one music can be played at a time. If the same music was already playing, it continues normally and does not restart. If a different music was already playing, it is stopped and replaced by the new one.
---
---When the music reaches the end, the `action` parameter indicates what to do next. The default behavior is to loop from the beginning.
---
---However, some music files already have their own loop internal loop information. Such musics are able to loop to a specific point rather than to the beginning. Since they already loop forever internally, they don't have an end and the `action` parameter has no effect on them. See [Music loop settings](https://doxygen.solarus-games.org/latest/quest_musics.html#quest_musics_loop) to know how Solarus supports internal loop information for each format.
---
---  * `music_id` (string): Name of the music file to play, relative to the `musics` directory and without extension. The following extensions will be tried in this order: ```.ogg`, ```.it` and ```.spc`. `nil` stops playing any music (the second parameter has no effect in this case). If you set the music name to the same music that is already playing, or to the special value `"same"`, then this function does nothing: the music keeps playing (it does not restart) and the second parameter is ignored.
---  * `action` (function or boolean, optional): What to do when the music finishes (reaches its end). A boolean value indicates whether or not the music should loop. The default is `true`. A function value indicates a custom action (and implies no loop). It will be called when the music finishes. This allows you to perform an action of your choice, like playing another music.
---
---
---
---@param music_id string
---@param action function|boolean|nil
function m.play_music(music_id,action) end

---
---Plays a sound effect.
---
---Generates a Lua error if the sound does not exist.
---
---Several sounds can be played in parallel. In the current version, a sound cannot be interrupted after you start playing it.
---
---Unlike musics, sounds files are entirely read before being played. A file access is made only the first time you play each sound. You can use [sol.audio.preload_sounds()](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_preload_sounds) if you want to also avoid this initial file access.
---
---  * `sound_id` (string): Name of the sound file to play, relative to the `sounds` directory and without extension. Currently, `.ogg` is the only extension supported.
---
---
---
---@param sound_id string
function m.play_sound(sound_id) end

---
---Returns the tempo of the current .it music.
---
---This function is only supported for .it musics.
---
---  * Return value (number): Tempo of the music. Returns `nil` if the current music format is not .it.
---
---
---
---@return number
function m.get_tempo() end

---
---Loads all sounds effects into memory for faster future access.
---
---If you don't call this function, you can still play sound effects, but the first access to each sound effect will require a file access that might be perceptible on slow machines. It is recommended to call this function at the beginning of the program (typically from [sol.main:on_started()](https://doxygen.solarus-games.org/latest/lua_api_main.html#lua_api_main_on_started)).
---
---The list of sound files to load is read from the [quest database](https://doxygen.solarus-games.org/latest/quest_database_file.html) file.
---
---This function does nothing if you already called it before.
---
function m.preload_sounds() end

---
---Sets the volume of all notes of a channel for the current .it music.
---
---This function has no effect for musics other than .it.
---
---  * `channel` (number): Index of a channel (the first one is zero).
---  * `volume` (number): The volume to set.
---
---
---
---@param channel number
---@param volume number
function m.set_music_channel_volume(channel,volume) end

---
---Stops playing music.
---
---This function has no effect if no music was playing.
---
---Remarks
---    This is equivalent to `sol.audio.play_music("none")`.
---
function m.stop_music() end

---
---Returns the volume of notes of a channel for the current .it music.
---
---This function is only supported for .it musics.
---
---  * `channel` (number): Index of a channel (the first one is zero).
---  * Return value (number): Volume of the channel. Returns `nil` if the current music format is not .it.
---
---
---
---Remarks
---    The channel should have the same volume for all its notes. Otherwise, calling this function does not make much sense.
---
---@param channel number
---@return number
function m.get_music_channel_volume(channel) end

---
---Returns the current volume of sound effects.
---
---This volume applies to all sounds played by [sol.audio.play_sound()](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_sound) and by the engine.
---
---  * Return value (number): The current volume of sound effects, as an integer between `0` (mute) and `100` (full volume).
---
---
---
---@return number
function m.get_sound_volume() end

---
---Returns the number of channels of the current .it music.
---
---This function is only supported for .it musics.
---
---  * Return value (number): Number of channels of the music. Returns `nil` if the current music format is not .it.
---
---
---
---@return number
function m.get_music_num_channels() end

---
---Returns the format of the music currently playing.
---
---  * Return value (string): Format of the music: `"ogg"`, `"it"` or `"spc"`. Returns `nil` if no music is playing.
---
---
---
---@return string
function m.get_music_format() end

---
---Returns the name of the music currently playing.
---
---  * Return value (string): Name of the music file currently playing, relative to the `musics` directory and without extension. Returns `nil` if no music is playing.
---
---
---
---@return string
function m.get_music() end

---
---Sets the volume of sound effects.
---
---This volume applies to all sounds played by [sol.audio.play_sound()](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_sound) and by the engine.
---
---  * `volume` (number): The new volume of sound effects, as an integer between `0` (mute) and `100` (full volume).
---
---
---
---Remarks
---    When the quest is run from the Solarus GUI, the user can also change the volume from the menus of the GUI.
---
---@param volume number
function m.set_sound_volume(volume) end

---
---Sets the volume of musics.
---
---This volume applies to all musics played by [sol.audio.play_music(music_id, [action])](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_music). "sol.audio.play_music()"
---
---  * `volume` (number): The new volume of musics, as an integer between `0` (no music) and `100` (full volume).
---
---
---
---@param volume number
function m.set_music_volume(volume) end

return m