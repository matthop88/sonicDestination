return function(params)
    return {
        xSpeed    = params.xSpeed     or 100,
        animation = params.animation,
        elapsed   = 0,
        duration  = params.numSeconds or 256,
        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            if self.animation then actor:setAnimationByLabel(self.animation) end
            if (actor.scanGround and not actor:scanGround()) or actor.hitSolid then
                self:reset()
                actor:setXSpeed(0)
                return true
            else
                actor:setXSpeed(self.xSpeed)
            end
            self.elapsed = self.elapsed + dt
            if self.elapsed > self.duration then
                self:reset()
                return true
            end
        end,
    }
end
