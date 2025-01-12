/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/audio/ItDecoder.h"
#include "solarus/audio/Music.h"
#include "solarus/audio/MusicSystem.h"
#include "solarus/audio/OggDecoder.h"
#include "solarus/audio/SpcDecoder.h"
#include "solarus/core/Debug.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/String.h"
#include "solarus/lua/LuaContext.h"
#include <lua.hpp>
#include <algorithm>
#include <sstream>
#include <iostream>

namespace Solarus {

constexpr int Music::nb_buffers;
constexpr int Music::buffer_size;

const std::string Music::none = "none";
const std::string Music::unchanged = "same";

/**
 * \brief Lua name of each music format.
 */
const std::vector<std::string> Music::format_names = {
  "",
  "spc",
  "it",
  "ogg"
};

/**
 * \brief Creates an empty music.
 */
Music::Music():
  id(none),
  format(FORMAT_NONE),
  loop(false),
  callback_ref(),
  source(AL_NONE),
  spc_decoder(std::unique_ptr<SpcDecoder>(new SpcDecoder())),
  it_decoder(std::unique_ptr<ItDecoder>(new ItDecoder())),
  ogg_decoder(std::unique_ptr<OggDecoder>(new OggDecoder())),
  volume(1.0) {

  for (int i = 0; i < nb_buffers; i++) {
    buffers[i] = AL_NONE;
  }
}

/**
 * \brief Creates a new music.
 * \param music_id Id of the music (file name without extension).
 * \param loop Whether the music should loop when reaching its end.
 * \param callback_ref Lua function to call when the music ends
 * or an empty ref.
 * There cannot be both a loop and a callback at the same time.
 */
Music::Music(
    const std::string& music_id,
    bool loop,
    const ScopedLuaRef& callback_ref):
  id(music_id),
  format(FORMAT_OGG),
  loop(loop),
  callback_ref(callback_ref),
  source(AL_NONE),
  spc_decoder(std::unique_ptr<SpcDecoder>(new SpcDecoder())),
  it_decoder(std::unique_ptr<ItDecoder>(new ItDecoder())),
  ogg_decoder(std::unique_ptr<OggDecoder>(new OggDecoder())),
  volume(1.0) {

  load(music_id);

  SOLARUS_REQUIRE(!loop || callback_ref.is_empty(),
      "Attempt to set both a loop and a callback to music");

  for (int i = 0; i < nb_buffers; i++) {
    buffers[i] = AL_NONE;
  }
}

/**
 * \brief Creates a new music.
 */
MusicPtr Music::create(const std::string& music_id) {
  Music* music = new Music(music_id, true, ScopedLuaRef());
  return MusicPtr(music);
}

/**
 * \brief Performs the loading of music into memory
 */
void Music::load(const std::string& music_id) {
  // Detect format from file_name
  std::string file_name;
  MusicSystem::find_music_file(music_id, file_name, format);

  // Load music into
  std::string sound_buffer;
  switch (format) {
    case FORMAT_SPC:
      sound_buffer = QuestFiles::data_file_read(file_name);
      spc_decoder->load((int16_t*) sound_buffer.data(), sound_buffer.size());
      break;
    case FORMAT_IT:
      sound_buffer = QuestFiles::data_file_read(file_name);
      it_decoder->load(sound_buffer);
      break;
    case FORMAT_OGG:
      sound_buffer = QuestFiles::data_file_read(file_name);
      load_successful = ogg_decoder->load(std::move(sound_buffer), loop);
      break;
    case FORMAT_NONE:
      Debug::die("start: Invalid music format");
      break;
  }
}

const std::string& Music::get_id() const {
  return id;
}

/**
 * \brief Returns the format of the current music.
 * \return The format of the current music.
 */
Music::Format Music::get_format() {
  return format;
}

/**
 * \brief Returns the current volume of music.
 * \return the volume (0 to 100)
 */
int Music::get_volume() const {
  return (int) (volume * 100.0 + 0.5);
}

/**
 * \brief Sets the volume of musics.
 * \param volume the new volume (0 to 100)
 */
void Music::set_volume(int volume) {
  this->volume = std::min(100, std::max(0, volume)) / 100.0;
  float global_volume = MusicSystem::get_global_volume() / 100.0;

  if (source != AL_NONE) {
    alSourcef(source, AL_GAIN, this->volume * global_volume);
  }
}

/**
 * \brief Returns the number of channels of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \return The number of channels.
 */
int Music::get_num_channels() {

  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  return it_decoder->get_num_channels();
}

/**
 * \brief Returns the volume of a channel of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \param channel Index of a channel.
 * \return The volume of this channel.
 */
int Music::get_channel_volume(int channel) {

  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  return it_decoder->get_channel_volume(channel);
}

/**
 * \brief Sets the volume of a channel of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \param channel Index of a channel.
 * \param volume The volume to set.
 */
void Music::set_channel_volume(int channel, int volume) {

  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  it_decoder->set_channel_volume(channel, volume);
}

/**
 * \brief Returns the pan of a channel of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \param channel Index of a channel.
 * \return The pan of this channel.
 */
int Music::get_channel_pan(int channel) {
  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  return it_decoder->get_channel_pan(channel);
}

/**
 * \brief Sets the pan of a channel of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \param channel Index of a channel.
 * \param pan The pan to set.
 */
void Music::set_channel_pan(int channel, int pan) {

  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  it_decoder->set_channel_pan(channel, pan);
}

/**
 * \brief Returns the tempo of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \return The tempo of the current music.
 */
int Music::get_tempo() {

  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  return it_decoder->get_tempo();
}

/**
 * \brief Sets the tempo of the current music.
 *
 * This function is only supported for .it musics.
 *
 * \param tempo The tempo to set.
 */
void Music::set_tempo(int tempo) {

  SOLARUS_REQUIRE(get_format() == FORMAT_IT,
      "This function is only supported for .it musics");

  it_decoder->set_tempo(tempo);
}

/**
 * \brief Updates this music when it is playing.
 *
 * This function handles the double buffering.
 *
 * \return \c true if the music keeps playing, \c false if the end is reached.
 */
bool Music::update_playing() {

  if (alcGetCurrentContext() == nullptr) {
    // Device disconnected.
    return true;
  }

  // Get the empty buffers.
  ALint nb_empty;
  alGetSourcei(source, AL_BUFFERS_PROCESSED, &nb_empty);

  // Refill them.
  for (int i = 0; i < nb_empty; i++) {
    ALuint buffer;
    alSourceUnqueueBuffers(source, 1, &buffer);  // Unqueue the buffer.

    // Fill it by decoding more data.
    switch (format) {
      case FORMAT_SPC:
        decode_spc(buffer, buffer_size);
        break;
      case FORMAT_IT:
        decode_it(buffer, buffer_size);
        break;
      case FORMAT_OGG:
        decode_ogg(buffer, buffer_size);
        break;
      case FORMAT_NONE:
        Debug::die("update_playing: Invalid music format");
        break;
    }

    alSourceQueueBuffers(source, 1, &buffer);  // Queue it again.
  }

  // Check whether there is still something playing.
  ALint status;
  alGetSourcei(source, AL_SOURCE_STATE, &status);
  if (status != AL_PLAYING) {
    // The end of the file is reached, or we need to decode more data.
    alSourcePlay(source);
  }

  alGetSourcei(source, AL_SOURCE_STATE, &status);
  return status == AL_PLAYING;
}



/**
 * \brief Notifies this music that the audio device was disconnected.
 */
void Music::notify_device_disconnected() {

  // All sources and buffers are already destroyed by OpenAL at this point.
  source = AL_NONE;
  for (int i = 0; i < nb_buffers; ++i) {
    buffers[i] = AL_NONE;
  }
}

/**
 * \brief Notifies this music that the audio device was reconnected.
 */
void Music::notify_device_reconnected() {

  if (buffers[0] == AL_NONE) {
    // Recreate a source and buffers.
    alGenBuffers(nb_buffers, buffers);
    alGenSources(1, &source);
    alSourcef(source, AL_GAIN, volume);

    // Continue playing music.
    // Buffer data that was already decoded to buffers before the
    // disconnection is lost, so we actually skipped a short period of time.
    for (int i = 0; i < nb_buffers; i++) {
      ALuint buffer = buffers[i];
      switch (format) {
        case FORMAT_SPC:
          decode_spc(buffer, buffer_size);
          break;
        case FORMAT_IT:
          decode_it(buffer, buffer_size);
          break;
        case FORMAT_OGG:
          decode_ogg(buffer, buffer_size);
          break;
        case FORMAT_NONE:
          Debug::die("notify_device_reconnected: Invalid music format");
          break;
      }
      alSourceQueueBuffers(source, 1, &buffer);
    }
    alSourcePlay(source);
  }
}

/**
 * \brief Notifies this music that the MusicSystem global volume has changed.
 */
void Music::notify_global_volume_changed() {
  set_volume(get_volume());
}

/**
 * \brief Decodes a chunk of SPC data into PCM data for the current music.
 * \param destination_buffer the destination buffer to write
 * \param nb_samples number of samples to write
 */
void Music::decode_spc(ALuint destination_buffer, ALsizei nb_samples) {

  // decode the SPC data
  std::vector<ALushort> raw_data(nb_samples);
  spc_decoder->decode((int16_t*) raw_data.data(), nb_samples);

  // put this decoded data into the buffer
  alBufferData(destination_buffer, AL_FORMAT_STEREO16, raw_data.data(), nb_samples * 2, 32000);

  ALenum error = alGetError();
  if (error != AL_NO_ERROR) {
    std::ostringstream oss;
    oss << "Failed to fill the audio buffer with decoded SPC data for music file '"
      << file_name << ": error " << error;
    Debug::error(oss.str());
  }
}

/**
 * \brief Decodes a chunk of IT data into PCM data for the current music.
 * \param destination_buffer the destination buffer to write
 * \param nb_samples number of samples to write
 */
void Music::decode_it(ALuint destination_buffer, ALsizei nb_samples) {

  // Decode the IT data.
  std::vector<ALushort> raw_data(nb_samples);
  int bytes_read = it_decoder->decode(raw_data.data(), nb_samples);

  if (bytes_read == 0) {
    // End of file.
    alBufferData(destination_buffer, AL_FORMAT_STEREO16, raw_data.data(), 0, 44100);
  }
  else {
    // Put this decoded data into the buffer.
    alBufferData(destination_buffer, AL_FORMAT_STEREO16, raw_data.data(), nb_samples, 44100);
  }
  ALenum error = alGetError();
  if (error != AL_NO_ERROR) {
    std::ostringstream oss;
    oss << "Failed to fill the audio buffer with decoded IT data for music file '"
        << file_name << ": error " << std::hex << error;
    Debug::error(oss.str());
  }
}

/**
 * \brief Decodes a chunk of OGG data into PCM data for the current music.
 * \param destination_buffer The destination buffer to write.
 * \param nb_samples Number of samples to write.
 */
void Music::decode_ogg(ALuint destination_buffer, ALsizei nb_samples) {

  ogg_decoder->decode(destination_buffer, nb_samples);
}

/**
 * \brief Loads the file and starts playing this music.
 *
 * No other music should be playing.
 *
 * \return true if the music was loaded successfully
 */
bool Music::start() {
  if (!MusicSystem::is_initialized()) {
    return false;
  }

  // First time: find the file.
  if (file_name.empty()) {
    MusicSystem::find_music_file(id, file_name, format);

    if (file_name.empty()) {
      Debug::error(std::string("Cannot find music file 'musics/")
          + id + "' (tried with extensions .ogg, .it and .spc)"
      );
      return false;
    }
  }

  // create the buffers and the source
  alGenBuffers(nb_buffers, buffers);
  alGenSources(1, &source);
  alSourcef(source, AL_GAIN, volume);

  // decode music from memory
  switch (format) {
    case FORMAT_SPC:
      for (int i = 0; i < nb_buffers; i++) {
        decode_spc(buffers[i], buffer_size);
      }
      break;
    case FORMAT_IT:
      for (int i = 0; i < nb_buffers; i++) {
        decode_it(buffers[i], buffer_size);
      }
      break;
    case FORMAT_OGG:
      if (load_successful) {
        for (int i = 0; i < nb_buffers; i++) {
          decode_ogg(buffers[i], buffer_size);
        }
      }
      break;
    case FORMAT_NONE:
      Debug::die("start: Invalid music format");
      break;
  }

  if (!load_successful) {
    Debug::error("Cannot load music file '" + file_name + "'");
  }

  // start the streaming
  bool start_successful = true;
  alSourceQueueBuffers(source, nb_buffers, buffers);
  ALenum error = alGetError();
  if (error != AL_NO_ERROR) {
    std::ostringstream oss;
    oss << "Cannot initialize buffers for music '"
        << file_name << "': error " << error;
    Debug::error(oss.str());
    start_successful = false;
  }

  MusicPtr shared_this = shared_from_this_cast<Music>();
  MusicSystem::remove_music(shared_this); // To avoid duplicates.
  MusicSystem::add_music(shared_this);

  // The update() function will then take care of filling the buffers

  return start_successful;
}

/**
 * \brief Stops playing the music.
 *
 * The callback if any is not called.
 */
void Music::stop() {

  if (!MusicSystem::is_initialized()) {
    return;
  }

  // Release the callback if any.
  callback_ref.clear();

  // empty the source
  alSourceStop(source);

  ALint nb_queued;
  ALuint buffer;
  alGetSourcei(source, AL_BUFFERS_QUEUED, &nb_queued);
  for (int i = 0; i < nb_queued; i++) {
    alSourceUnqueueBuffers(source, 1, &buffer);
  }

  // delete the source
  alDeleteSources(1, &source);

  // delete the buffers
  alDeleteBuffers(nb_buffers, buffers);

  switch (format) {
    case FORMAT_SPC:
      break;
    case FORMAT_IT:
      it_decoder->unload();
      break;
    case FORMAT_OGG:
      ogg_decoder->unload();
      break;
    case FORMAT_NONE:
      Debug::die("stop: Invalid music format");
      break;
  }
}

/**
 * \brief Returns whether the music is paused.
 * \return true if the music is paused, false otherwise
 */
bool Music::is_paused() const {

  if (!MusicSystem::is_initialized()) {
    return false;
  }

  ALint status;
  alGetSourcei(source, AL_SOURCE_STATE, &status);
  return status == AL_PAUSED;
}

/**
 * \brief Pauses or resumes the music.
 * \param pause true to pause the music, false to resume it
 */
void Music::set_paused(bool pause) {

  if (!MusicSystem::is_initialized()) {
    return;
  }

  if (pause) {
    alSourcePause(source);
  }
  else {
    alSourcePlay(source);
  }
}

const ScopedLuaRef& Music::get_callback() const {
  return callback_ref;
}

/**
 * \brief Sets a Lua function to call when the music ends.
 *
 * The previous callback if any is discarded.
 *
 * \param callback_ref Lua ref to a function to call when the music ends
 * or an empty ref.
 */
void Music::set_callback(const ScopedLuaRef& callback_ref) {
  this->callback_ref = callback_ref;
}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return The name identifying this type in Lua.
 */
const std::string& Music::get_lua_type_name() const {
  return LuaContext::music_module_name;
}

}
