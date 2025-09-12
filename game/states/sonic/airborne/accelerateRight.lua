local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:faceRight()
    end,
    
    keypressed = function(self, key)
        if key == "left" then SONIC:setState(STATES.AIR_ACCELERATE_LEFT) end
    end,

    keyreleased = function(self, key)
        if     key == "right" then SONIC:setState(STATES.AIR_DECELERATE_RIGHT)
        elseif key == "space" then SONIC:throttleJump()                    end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then 
            if SONIC.velocity.x < 0 then SONIC:setState(STATES.BRAKE_LEFT)
            else                         SONIC:setState(STATES.ACCELERATE_RIGHT) end
        else
            SONIC.velocity.x = math.min(SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x + (SONIC.AIR_ACCELERATION * dt))
            if SONIC.sprite:getFPS() >= 60 then
                SONIC.sprite:setCurrentAnimation("fastJumping")
            else
                SONIC.sprite:setCurrentAnimation("jumping")
            end
        end
    end,
}
