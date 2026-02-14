local map = ...
local hero = map:get_hero()
local game = map:get_game()

function map:on_opening_transition_finished()
  game:simulate_command_pressed("action")
end

function hero:on_state_changed(state)
  ---Hero should not be able to grab when overlapping the traversable dynamic tile.
  ---This bug is not happening with static tiles.
  if state == "grabbing" then
    assert(false)
  end
  sol.main.exit()
end
