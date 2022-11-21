local map = ...

function map:on_started()
  local sprite = sol.sprite.create"imaginary/bad-id"
  assert_equal(sprite, nil, "Sprite should be nil.")

  sprite = sol.sprite.create"entities/arrow"
  assert_equal(sol.main.get_type(sprite), "sprite",
               "Sprite should be of type 'sprite'.")

  sol.main.exit()
end
