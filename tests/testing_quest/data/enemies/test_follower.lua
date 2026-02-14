local enemy = ...
local map = enemy:get_map()
local hero = map:get_hero()

function enemy:on_created()
  enemy:create_sprite("enemies/test_enemy")
  enemy:set_damage(100)
end

function enemy:on_restarted()
  local mov = sol.movement.create("target")
  mov:set_speed(128)
  mov:set_target(hero)
  mov:start(self)
end
