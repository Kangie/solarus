-- Lua script of map multiplayer/controls.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- https://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()
  local controls = sol.controls.create_from_keyboard()
  local cmds = {"1", "2", "3", "4"}
  controls:set_keyboard_bindings("a", cmds)
  controls:set_joypad_bindings("b", cmds)
  
  local joycmds = controls:get_joypad_bindings("b")
  local keycmds = controls:get_keyboard_bindings("a")

  for i,cmd in ipairs(cmds) do
    print(cmd, joycmds[i], keycmds[i])
    assert_equal(cmd, joycmds[i])
    assert_equal(cmd, keycmds[i])
  end
  sol.main.exit()
end
