local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:faceLeft()
    end,
    
    keypressed = function(self, key)
        if key == "right" then SONIC:setState(STATES.AIR_ACCELERATE_RIGHT) end
    end,

    keyreleased = function(self, key)
        if     key == "left"  then SONIC:setState(STATES.AIR_DECELERATE_LEFT)
        elseif key == "space" then SONIC:throttleJump()                   end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then
            if SONIC.velocity.x > 0 then SONIC:setState(STATES.BRAKE_RIGHT)
            else                         SONIC:setState(STATES.ACCELERATE_LEFT) end
        else
            SONIC.velocity.x = math.max(-SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x - (SONIC.AIR_ACCELERATION * dt))
            if SONIC.sprite:getFPS() >= 60 then
                SONIC.sprite:setCurrentAnimation("fastJumping")
            else
                SONIC.sprite:setCurrentAnimation("jumping")
            end
        end
    end,
}
