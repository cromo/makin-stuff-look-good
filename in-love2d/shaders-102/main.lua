local background, displacements
local color_buffer, intermediate_buffer
local time_elapsed = 0

local function id(...)
  return ...
end

local function clamp(value, low, high)
  if value < low then
    return low
  elseif high < value then
    return high
  end
  return value
end

local examples = {
  {
    shader_basename = 'uv_red_green',
    init = id,
    prerender = id,
    change_parameter = id
  },
  {
    shader_basename = 'texture_uv_red_green',
    init = id,
    prerender = id,
    change_parameter = id
  },
  {
    shader_basename = 'displacements',
    init = function(self)
      self.displacement_map = love.graphics.newImage('displacements.png')
      self.magnitude = 0
    end,
    prerender = function(self)
      self.shader:send('displacements', self.displacement_map)
      self.shader:send('magnitude', self.magnitude)
    end,
    change_parameter = function(self, direction)
      self.magnitude = clamp(self.magnitude + direction * 0.01, 0, 0.1)
    end
  },
  {
    shader_basename = 'animated_displacements',
    init = function(self)
      self.displacement_map = love.graphics.newImage('displacements.png')
      self.magnitude = 0.01
    end,
    prerender = function(self)
      self.shader:send('displacements', self.displacement_map)
      self.shader:send('magnitude', self.magnitude)
      self.shader:send('time', time_elapsed)
    end,
    change_parameter = function(self, direction)
      self.magnitude = clamp(self.magnitude + direction * 0.01, 0.01, 0.1)
    end
  }
}
local current_example = 1

function love.load()
  -- This is a screengrab from our Ludum Dare 34 game, Tailwind. While this is
  -- a static screen, the same techniques used in this program can be used for
  -- dynamic scenes as well.
  background = love.graphics.newImage('sample-screen.png')

  -- LOVE does not appear to have an equivalent hook for OnRenderImage. To
  -- simulate it, render to a canvas instead and then run a shader on that
  -- before drawing it to the screen.
  color_buffer = love.graphics.newCanvas()
  intermediate_buffer = love.graphics.newCanvas()

  for _, example in ipairs(examples) do
    example.shader = love.graphics.newShader(example.shader_basename .. ".frag")
  end
  examples[current_example]:init()
end

function love.update(dt)
  time_elapsed = time_elapsed + dt
end

-- This is where normal game rendering logic goes. It's a separate function to
-- keep the image effect code isolated and clean.
local function draw()
  love.graphics.draw(background)
end

function love.draw()
  color_buffer:renderTo(draw)

  love.graphics.setShader(examples[current_example].shader)
  examples[current_example]:prerender()
  love.graphics.draw(color_buffer)
  love.graphics.setShader()
end

function love.keypressed(key)
  if key == 'left' then
    current_example = clamp(current_example - 1, 1, #examples)
    examples[current_example]:init()
  elseif key == 'right' then
    current_example = clamp(current_example + 1, 1, #examples)
    examples[current_example]:init()
  elseif key == 'up' then
    examples[current_example]:change_parameter(1)
  elseif key == 'down' then
    examples[current_example]:change_parameter(-1)
  end
end
