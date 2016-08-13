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
    on_render_image = function(self, source, destination)
      love.graphics.setShader(self.shader)
      destination:renderTo(function()
          love.graphics.draw(source)
      end)
    end,
    change_parameter = id
  },
  {
    shader_basename = 'texture_uv_red_green',
    init = id,
    on_render_image = function(self, source, destination)
      love.graphics.setShader(self.shader)
      destination:renderTo(function()
          love.graphics.draw(source)
      end)
    end,
    change_parameter = id
  },
  {
    shader_basename = 'displacements',
    init = function(self)
      self.displacement_map = love.graphics.newImage('displacements.png')
      self.magnitude = 0
    end,
    on_render_image = function(self, source, destination)
      love.graphics.setShader(self.shader)
      self.shader:send('displacements', self.displacement_map)
      self.shader:send('magnitude', self.magnitude)
      destination:renderTo(function()
          love.graphics.draw(source)
      end)
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
    on_render_image = function(self, source, destination)
      love.graphics.setShader(self.shader)
      self.shader:send('displacements', self.displacement_map)
      self.shader:send('magnitude', self.magnitude)
      self.shader:send('time', time_elapsed)
      destination:renderTo(function()
          love.graphics.draw(source)
      end)
    end,
    change_parameter = function(self, direction)
      self.magnitude = clamp(self.magnitude + direction * 0.01, 0.01, 0.1)
    end
  },
  {
    shader_basename = 'box_blur',
    init = id,
    on_render_image = function(self, source, destination)
      love.graphics.setShader(self.shader)
      self.shader:send('pixel_size', {1 / love.graphics.getWidth(), 1 / love.graphics.getHeight()})
      destination:renderTo(function()
          love.graphics.draw(source)
      end)
    end,
    change_parameter = id
  },
  {
    shader_basename = 'box_blur',
    init = function(self)
      local width, height = love.graphics.getDimensions()
      self.render_textures = {
        love.graphics.newCanvas(),
        love.graphics.newCanvas()
      }
      self.iterations = 1
    end,
    on_render_image = function(self, source, destination)
      love.graphics.setShader()
      self.render_textures[1]:renderTo(function()
          love.graphics.draw(source)
      end)
      love.graphics.setShader(self.shader)
      self.shader:send('pixel_size', {1 / love.graphics.getWidth(), 1 / love.graphics.getHeight()})
      local downres_source_index = 1
      for i = 1, self.iterations do
        local downres_destination_index = 1
        if downres_source_index == 1 then
          downres_destination_index = 2
        end

        self.render_textures[downres_destination_index]:renderTo(function()
            love.graphics.draw(self.render_textures[downres_source_index])
        end)
        downres_source_index = math.fmod(downres_source_index, 2) + 1
      end
      love.graphics.setShader()
      destination:renderTo(function()
          love.graphics.draw(self.render_textures[downres_source_index])
      end)
    end,
    change_parameter = function(self, direction)
      self.iterations = clamp(self.iterations + direction, 1, 10)
    end
  },
  {
    shader_basename = 'box_blur',
    init = function(self)
      local width, height = love.graphics.getDimensions()
      self.scale_factor = 1 / 2
      self.intermediate_width = math.floor(width * self.scale_factor)
      self.intermediate_height = math.floor(height * self.scale_factor)
      self.render_textures = {
        love.graphics.newCanvas(self.intermediate_width, self.intermediate_height),
        love.graphics.newCanvas(self.intermediate_width, self.intermediate_height)
      }
      self.iterations = 1
    end,
    on_render_image = function(self, source, destination)
      love.graphics.setShader()
      self.render_textures[1]:renderTo(function()
          love.graphics.draw(source, 0, 0, 0, self.scale_factor)
      end)
      love.graphics.setShader(self.shader)
      self.shader:send('pixel_size', {1 / self.intermediate_width, 1 / self.intermediate_height})
      local downres_source_index = 1
      for i = 1, self.iterations do
        local downres_destination_index = 1
        if downres_source_index == 1 then
          downres_destination_index = 2
        end

        self.render_textures[downres_destination_index]:renderTo(function()
            love.graphics.draw(self.render_textures[downres_source_index])
        end)
        downres_source_index = math.fmod(downres_source_index, 2) + 1
      end
      love.graphics.setShader()
      destination:renderTo(function()
          love.graphics.draw(self.render_textures[downres_source_index], 0, 0, 0, 1 / self.scale_factor)
      end)
    end,
    change_parameter = function(self, direction)
      self.iterations = clamp(self.iterations + direction, 1, 10)
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
  source_buffer = love.graphics.newCanvas()
  destination_buffer = love.graphics.newCanvas()

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
  source_buffer:renderTo(draw)
  examples[current_example]:on_render_image(source_buffer, destination_buffer)

  love.graphics.setShader()
  love.graphics.draw(destination_buffer)
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
