return function(params)
    return {
        duration = (params.numSeconds or 1) * 60,
        elapsed  =  0,

        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            actor:setXSpeed(0)
            self.elapsed = self.elapsed + dt
            if self.elapsed > self.duration then
                self:reset()
                return true
            end
        end,
    }
end
