return function(params)
    return {
        xSpeed    = params.xSpeed     or 100,
        animation = params.animation,
        
        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            if self.animation then actor:setAnimationByLabel(self.animation) end
            if (actor.scanGround and not actor:scanGround()) or actor.hitSolid then
                self:reset()
                return true
            else
                actor:setXSpeed(self.xSpeed)
            end
        end,
    }
end
