return function(params)
    return {
        xSpeed   =  params.xSpeed     or 100,
        
        reset = function(self)
            self.elapsed = 0
        end,

        execute = function(self, dt, actor)
            actor:setXSpeed(self.xSpeed)
            if actor.scanGround and not actor:scanGround() then
                self:reset()
                return true
            end
        end,
    }
end
