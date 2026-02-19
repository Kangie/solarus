local map = ...
local game = map:get_game()

local hero_is_pushing = false
local push_phase = nil ---Can be: "enemy_push"|"enemy_squeeze"
local test_phase = nil ---Can be: "enemy_push"|"enemy_squeeze"|"enemy_release"

function map:on_opening_transition_finished()
  push_phase = "enemy_push"
  game:simulate_command_pressed("up")

  sol.timer.start(map, 16.66, function()
    if test_phase == "enemy_push" then
      ---Block should be pushed of one step
      assert_equal_position(block, 160, 141)
      ---Enemy has to be pushed by the block
      assert_equal_position(enemy, 160, 125)
      test_phase = nil
      push_phase = "enemy_squeeze"
      game:simulate_command_pressed("up")
    end

    if test_phase == "enemy_squeeze" then
      ---Block should be pushed of one step
      assert_equal_position(block, 160, 125)
      ---Enemy should not moved because against an obstacle (squeeze), it should overlaps the block
      assert_equal_position(enemy, 160, 125)
      test_phase = "enemy_release"
    end

    if test_phase == "enemy_release" then
      ---Move the enemy to the right to get off the block
      local mov = sol.movement.create("straight")
      mov:set_angle(0)
      mov:set_max_distance(16)
      mov.on_finished = function ()
        assert_equal_position(enemy, 176, 125)
        test_phase = nil
        sol.main.exit()
      end
      mov:start(enemy)
      test_phase = nil
      return false
    end

    return true
  end)
end

function block:on_moving()
  hero_is_pushing = true
  game:simulate_command_released("up")
end

function block:on_moved()
  hero_is_pushing = false
  if push_phase == "enemy_push" then
    test_phase = "enemy_push"
  elseif push_phase == "enemy_squeeze" then
    test_phase = "enemy_squeeze"
  end
end
