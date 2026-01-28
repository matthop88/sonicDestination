return function(params)
    return {
        xSpeed   =  params.xSpeed     or 100,
        
        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            if actor.scanGround and not actor:scanGround() then
                self:reset()
                return true
            else
                actor:setXSpeed(self.xSpeed)
            end
        end,
    }
end
