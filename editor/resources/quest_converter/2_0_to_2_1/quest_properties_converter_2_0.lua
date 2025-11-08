-- This module reads a quest properties file with the format of Solarus 2.0
-- (quest.dat) and converts it into the format of Solarus 2.1.

-- Differences:
-- - The value of solarus_version changes.

local converter = {}

local function serialize_string_array(strings)
    local quoted_strings = {}

    -- 1. Quote each string
    for i, str in ipairs(strings) do
        quoted_strings[i] = string.format('"%s"', str)
    end
    return "{" .. table.concat(quoted_strings, ", ") .. "}"
end

local function serialize_boolean(value)
    return value and "true" or "false"
end

function converter.convert(quest_path)

  local properties

  -- Read the old file.
  function quest(p)

    if not p.solarus_version:match("^2.0%.?") then
      error("This is not a Solarus 2.0 quest: the detected version is " .. p.solarus_version)
    end

    properties = p
  end

  dofile(quest_path .. "/data/quest.dat")

  -- Write the new file.
  local output_file = io.open(quest_path .. "/data/quest.dat", "w")

  output_file:write("quest{\n")
  output_file:write("  solarus_version = \"2.1\",\n")

  if properties.write_dir ~= nil then
    output_file:write("  write_dir = \"" .. properties.write_dir .. "\",\n")
  end
  output_file:write("  title = \"" .. properties.title .. "\",\n")
  if properties.short_description ~= nil then
    output_file:write("  short_description = \"" .. properties.short_description .. "\",\n")
  end
  if properties.long_description ~= nil then
    output_file:write("  long_description = [[\n" .. properties.long_description .. "]],\n")
  end
  if properties.author ~= nil then
    output_file:write("  author = \"" .. properties.author .. "\",\n")
  end
  if properties.quest_version ~= nil then
    output_file:write("  quest_version = \"" .. properties.quest_version .. "\",\n")
  end
  if properties.initial_release_date ~= nil then
    output_file:write("  initial_release_date = \"" .. properties.initial_release_date .. "\",\n")
  end
  if properties.release_date ~= nil then
    output_file:write("  release_date = \"" .. properties.release_date .. "\",\n")
  end
  if properties.website ~= nil then
    output_file:write("  website = \"" .. properties.website .. "\",\n")
  end
  if properties.normal_quest_size ~= nil then
    output_file:write("  normal_quest_size = \"" .. properties.normal_quest_size .. "\",\n")
  end
  if properties.min_quest_size ~= nil then
    output_file:write("  min_quest_size = \"" .. properties.min_quest_size .. "\",\n")
  end
  if properties.max_quest_size ~= nil then
    output_file:write("  max_quest_size = \"" .. properties.max_quest_size .. "\",\n")
  end
  if properties.license ~= nil then
    output_file:write("  license = \"" .. properties.license .. "\",\n")
  end
  if properties.languages ~= nil then
    output_file:write("  languages = " .. serialize_string_array(properties.languages) .. ",\n")
  end
  if properties.min_players ~= nil then
    output_file:write("  min_players = " .. properties.min_players .. ",\n")
  end
  if properties.max_players ~= nil then
    output_file:write("  max_players = " .. properties.max_players .. ",\n")
  end
  if properties.genres ~= nil then
    output_file:write("  genres = " .. serialize_string_array(properties.genres) .. ",\n")
  end
  if properties.age ~= nil then
    output_file:write("  age = \"" .. properties.age .. "\",\n")
  end
  if properties.controls ~= nil then
    output_file:write("  controls = " .. properties.controls .. ",\n")
  end
  if properties.dynamic_timestep ~= nil then
    output_file:write("  dynamic_timestep = " .. serialize_boolean(properties.dynamic_timestep) .. ",\n")
  end
  if properties.subpixel_camera ~= nil then
    output_file:write("  subpixel_camera = " .. serialize_boolean(properties.subpixel_camera) .. ",\n")
  end

  output_file:write("}\n\n");
  output_file:close()

end

return converter
