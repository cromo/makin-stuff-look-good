local function update_system(self, dt)
  self.system:update(dt)
end

local function draw_system(self, ...)
  love.graphics.draw(self.system, ...)
end

local systems = {
  {
    init = function(self)
      local gradient_disk = love.graphics.newImage('linear-falloff-disk.png')
      self.system = love.graphics.newParticleSystem(gradient_disk, 1000)
      self.system:setParticleLifetime(2)
      self.system:setEmissionRate(10)
      self.system:setSpeed(0, 40)
      self.system:setSizes(0, 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4)
      self.system:setSpread(2 * math.pi)
      self.system:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    end,
    update = update_system,
    draw = draw_system
  },
  {
    -- Spawn time dependent color is not supported in LOVE.
    init = function() end,
    update = function() end,
    draw = function() end
  },
  {
    init = function(self)
      local gradient_disk = love.graphics.newImage('linear-falloff-disk.png')
      self.system = love.graphics.newParticleSystem(gradient_disk, 1000)
      self.system:setParticleLifetime(2)
      self.system:setEmissionRate(10)
      self.system:setSpeed(0, 40)
      self.system:setSizes(0, 2 * 1, 2 * 0.9, 2 * 0.8, 2 * 0.7, 2 * 0.6, 2 * 0.5, 2 * 0.4)
      self.system:setSpread(2 * math.pi)
      self.system:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    end,
    update = update_system,
    draw = function(self, ...)
      local mode, alpha_mode = love.graphics.getBlendMode()
      love.graphics.setBlendMode('add', 'alphamultiply')
      love.graphics.draw(self.system, ...)
      love.graphics.setBlendMode(mode, alpha_mode)
    end
  },
  {
    init = function(self)
      local solid_disk = love.graphics.newImage('solid-disk.png')
      self.system = love.graphics.newParticleSystem(solid_disk, 1000)
      self.system:setParticleLifetime(2)
      self.system:setEmissionRate(10)
      self.system:setSpeed(0, 40)
      self.system:setSizes(0, 2 * 1, 2 * 0.9, 2 * 0.8, 2 * 0.7, 2 * 0.6, 2 * 0.5, 0)
      self.system:setSpread(2 * math.pi)
      -- Change particle color over time so particles can be differentiated
      self.system:setColors(255, 0, 0, 255, 0, 0, 255, 255)
      self.system:setLinearAcceleration(0, 60)
      self.system:setInsertMode('bottom')
    end,
    update = update_system,
    draw = draw_system
  },
  {
    init = function(self)
      local outlined_disk = love.graphics.newImage('outlined-disk.png')
      self.system = love.graphics.newParticleSystem(outlined_disk, 1000)
      self.system:setParticleLifetime(2)
      self.system:setEmissionRate(200)
      self.system:setSpeed(0, 40)
      self.system:setSizes(0, 2 * 1, 2 * 0.9, 2 * 0.8, 2 * 0.7, 2 * 0.6, 2 * 0.5, 0)
      self.system:setSpread(2 * math.pi)
      self.system:setColors(255, 0, 0, 255, 0, 0, 255, 255)
      self.system:setLinearAcceleration(0, 60)
    end,
    update = update_system,
    draw = draw_system
  },
  {
    init = function(self)
      local outlined_square = love.graphics.newImage('outlined-square.png')
      self.system = love.graphics.newParticleSystem(outlined_square, 1000)
      self.system:setParticleLifetime(2)
      self.system:setEmissionRate(20)
      self.system:setSizes(0, 2, 2, 0)
      self.system:setColors(255, 0, 0, 255, 0, 0, 255, 255)
      self.system:setRotation(-math.pi, math.pi)
      self.system:setSpin(-math.pi / 2, math.pi / 2)
    end,
    update = update_system,
    draw = draw_system
  },
  {
    init = function(self)
      local outlined_square = love.graphics.newImage('outlined-square.png')
      self.system = love.graphics.newParticleSystem(outlined_square, 1000)
      self.system:setParticleLifetime(0.5, 1.5)
      self.system:setSizes(0, 1, 1, 0)
      self.system:setColors(255, 0, 0, 255, 0, 0, 255, 255)
      self.system:setRotation(-math.pi, math.pi)
      self.system:setSpin(0, math.pi)
      self.system:setSpread(math.pi / 4)
      self.system:setDirection(-math.pi / 2)
      self.system:setSpeed(100, 200)
      self.system:setLinearAcceleration(0, 300)
      -- It does not appear that damping the rotation over particle lifetime is
      -- supported in LOVE.
      self.dt = 0
    end,
    update = function(self, dt)
      self.dt = self.dt + dt
      if 1 < self.dt then
        self.dt = self.dt % 1
        self.system:emit(30)
      end
      update_system(self, dt)
    end,
    draw = draw_system
  },
  {
    -- Emission by emitter distance traveled does not appear to be supported in
    -- LOVE.
    init = function() end,
    update = function() end,
    draw = function() end
  }
}

function love.load()
  for _, system in ipairs(systems) do
    system:init()
  end
end

function love.update(dt)
  for _, system in ipairs(systems) do
    system:update(dt)
  end
end

function love.draw()
  love.graphics.setBackgroundColor(20, 20, 35)
  for i, system in ipairs(systems) do
    i = i - 1
    system:draw(150 * (i % 4) + 150, 200 * math.floor(i / 4) + 150)
  end
end
