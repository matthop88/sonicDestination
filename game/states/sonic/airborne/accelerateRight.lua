local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:faceRight()
        SONIC:startJump()
    end,
    
    keypressed = function(self, key)
        if key == "left" then SONIC:setState(STATES.AIR_ACCELERATE_LEFT) end
    end,

    keyreleased = function(self, key)
        if key == "right" then SONIC:setState(STATES.AIR_DECELERATE_RIGHT) end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then 
            SONIC:setState(STATES.ACCELERATE_RIGHT) 
        else
            SONIC.velocity.x = math.min(SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x + (SONIC.AIR_ACCELERATION * dt))
        end
    end,
}
