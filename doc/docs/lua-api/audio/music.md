# Music

You can create, play, or pause musics through `sol.music`.

An object of type `music` represents a music with its current playing state. Multiple musics effects can be played, paused, resumed or stopped independently.

## Functions of `sol.music`

### `sol.music.create(music_id)`

Creates a new music but does not play it. Generates a Lua error if the music file does not exist.

`music_id` (string)
: Name of the music file to read, relative to the `musics` directory and without extension.

Return value (music)
: The music object.

## Methods of `sol.music`

### `music:play()`

Starts playing the music.

### `music:stop()`

Stops playing the music.

### `music:get_volume()`

Returns the volume for this music.

Return value (integer)
: The volume between 0 and 100.

### `music:set_volume(volume)`

Sets the volume for this music relative to the global volume (see [`sol.audio.set_music_volume`](./overview.md#solaudioset_music_volumevolume)).

`volume` (integer)
: The volume between 0 and 100.

### `music:get_channel_volume(channel)`

Returns the volume for a specified channel.

Return value (integer)
: The volume between 0 and 64 (like in your tracker software).

### `music:set_channel_volume(channel, volume)`

Sets the volume for a specified channel.

`volume` (integer)
: The volume between 0 and 64 (like in your tracker software).

### `music:get_channel_pan(channel)`

Returns the pan for a specified channel.

Return value (integer)
: The pan between 0 (left) and 256 (right).

### `music:set_channel_pan(channel, pan)`

Sets the pan for a specified channel.

`volume` (integer)
: The pan between 0 (left) and 256 (right).
