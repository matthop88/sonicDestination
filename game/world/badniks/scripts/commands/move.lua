return function(params)
    return {
        xSpeed    = params.xSpeed     or 100,
        duration  = params.numSeconds or 1,
        elapsed   = 0,
        animation = params.animation,

        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            if self.animation then actor:setAnimationByLabel(self.animation) end
            actor:setXSpeed(self.xSpeed)
            self.elapsed = self.elapsed + dt
            if self.elapsed > self.duration then
                self:reset()
                return true
            end
        end,
    }
end
