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
            return self.elapsed > self.duration
        end,
    }
end
