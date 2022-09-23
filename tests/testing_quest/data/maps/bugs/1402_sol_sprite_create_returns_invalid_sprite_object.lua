local map = ...

function map:on_started()
  local sprite = sol.sprite.create"imaginary/bad-id"
  assert_equal(nil, sprite, "Sprite should be nil.")

  sol.main.exit()
end
