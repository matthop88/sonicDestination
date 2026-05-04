local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,

    onEnter    = function(self) 
        SONIC:faceLeft()
        SONIC.velocity.x = 0
        self.prevX = SONIC:getX()
        SONIC.sprite:setCurrentAnimation("pushing")
    end,
    
    keypressed = function(self, key)
        if     key == "right" then
            SONIC.velocity.x = 0
            SONIC:setState(STATES.ACCELERATE_RIGHT)  
        elseif key == "space" then
            SONIC:startJump()
            SONIC:setState(STATES.AIR_ACCELERATE_LEFT)
        end
    end,

    keyreleased = function(self, key)
        if key == "left" then 
            SONIC:setState(STATES.STAND_LEFT) 
        end
    end,

    update = function(self, dt)
        if not love.keyboard.isDown("left") then SONIC:setState(STATES.STAND_LEFT)
        else
            local apparentXVelocity = (SONIC:getX() - self.prevX) / dt
            if apparentXVelocity == 0 then 
                SONIC.sprite:setCurrentAnimation("pushing")
            else
                SONIC.sprite:setCurrentAnimation("deepPushing")
            end
            SONIC.sprite:setFPS(60 / ((math.max(10, 30 - math.abs(apparentXVelocity / 10))) + 1))
            SONIC.velocity.x = math.max(-SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x - (SONIC.RUNNING_ACCELERATION * dt))
            self.prevX = SONIC:getX()
        end
    end,
}
    
