local map = ...
local game = map:get_game()

local enemy_spawn_x
local enemy_spawn_y
local max_allowed_distance = 40

function map:on_started()
  if sol.main.had_game_over then
    ---Simulate the hero pressing left during the opening transition.
    game:simulate_command_pressed("left")
  end

  local enemy = map:get_entity("enemy")
  enemy_spawn_x, enemy_spawn_y = enemy:get_position()
end

function map:on_opening_transition_finished()
  if not sol.main.had_game_over then
    game:set_life(0)
    return
  end

  ---Check the enemy didn't teleport after game over (suspension)
  local enemy = map:get_entity("enemy")
  assert(enemy, "Enemy not found on map after restart")

  sol.timer.start(map, 50, function()
    local ex, ey = enemy:get_position()
    local dx = ex - enemy_spawn_x
    local dy = ey - enemy_spawn_y
    local distance = math.sqrt(dx * dx + dy * dy)

    assert(distance < max_allowed_distance,
      string.format(
        "Enemy teleported! Position (%d, %d), distance from spawn: %.1f pixels (max allowed: %d)",
        ex, ey, distance, max_allowed_distance
      )
    )
  end)

  sol.timer.start(map, 1000, function()
    sol.main.exit()
  end)
end

function game:on_game_over_started()
  sol.main.had_game_over = true
  game:start()
end