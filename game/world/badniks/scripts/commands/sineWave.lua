return function(params)
    return {
        speed      = params.speed      or 1,
        wavelength = params.wavelength or 100,
        duration   = params.numSeconds or 1,
        amplitude  = params.amplitude  or 100,
        elapsed    = 0,
        radians    = 0,

        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            self.radians = self.radians + (self.speed * dt)
            actor:setXSpeed(self.wavelength * self.speed)
            actor:setYSpeed(math.sin(self.radians) * self.amplitude * self.speed)
            
            self.elapsed = self.elapsed + dt
            if self.elapsed > self.duration then
                self:reset()
                return true
            end
        end,
    }
end
