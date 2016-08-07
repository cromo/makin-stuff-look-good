local examples = {
  "white", "orange", "uv_red_green", "uv_cyan_magenta",
  --[["texture_no_alpha",]] "texture", "tint", "texture_uv_red_green",
  --[["texture_tween",]] "tile", "andy_warhol_looking_painting", "grayscale",
  "grayscale_tint", --[["additive_blending"]]
}

local shaders = {}
local image

function love.load()
  for _, shader in ipairs(examples) do
    shaders[shader] = love.graphics.newShader(shader .. ".frag")
  end

  image = love.graphics.newImage('kirby.png')
end

function love.draw()
  love.graphics.setBackgroundColor(20, 20, 35)

  local padding = 20
  local delta_x = image:getWidth() + padding
  local delta_y = image:getHeight() + padding
  local screen_width = love.graphics.getWidth()
  local columns_per_screen = math.floor(screen_width / delta_x)
  for i, shader in ipairs(examples) do
    i = i - 1
    local column = i % columns_per_screen
    local row = math.floor(i / columns_per_screen)

    love.graphics.setShader(shaders[shader])
    love.graphics.draw(image, delta_x * column, delta_y * row)
  end

  -- texture_no_alpha requires changing some settings outside the shader.
  love.graphics.setBlendMode('replace', 'premultiplied')
  love.graphics.setShader(shaders['texture'])
  love.graphics.draw(image, delta_x * 0, delta_y * 2)

  -- I'm not sure how to do texture tweening since LOVE doesn't appear to have a
  -- way to send multiple textures (a.k.a. sampler2D) to a shader.

  -- additive_blending is done by setting the blend mode to 'add'.
  love.graphics.setBlendMode('add', 'alphamultiply')
  love.graphics.setShader(shaders['texture'])
  love.graphics.draw(image, delta_x * 2, delta_y * 2)

  -- Clear all shader effects.
  love.graphics.setBlendMode('alpha', 'alphamultiply')
  love.graphics.setShader()
end
