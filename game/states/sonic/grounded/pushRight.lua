local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,

    onEnter    = function(self) 
        SONIC:faceRight()
        SONIC.velocity.x = 0
        self.prevX = SONIC:getX()
        SONIC.sprite:setCurrentAnimation("pushing")
    end,
    
    keypressed = function(self, key)
        if     key == "left"  then 
            SONIC.velocity.x = 0
            SONIC:setState(STATES.ACCELERATE_LEFT)  
        elseif key == "space" then
            SONIC:startJump()
            SONIC:setState(STATES.AIR_ACCELERATE_RIGHT)
        end
    end,

    keyreleased = function(self, key)
        if key == "right" then
            SONIC:setState(STATES.STAND_RIGHT) 
        end
    end,

    update = function(self, dt)
        if not love.keyboard.isDown("right") then SONIC:setState(STATES.STAND_RIGHT)
        else
            local apparentXVelocity = (SONIC:getX() - self.prevX) / dt
            SONIC.sprite:setFPS(60 / ((math.max(0, 30 - math.abs(apparentXVelocity / 10))) + 1))
            SONIC.velocity.x = math.min(SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x + (SONIC.RUNNING_ACCELERATION * dt))
            self.prevX = SONIC:getX()
        end
    end,
}
    
