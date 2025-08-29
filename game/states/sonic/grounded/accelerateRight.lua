local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:faceRight()
        SONIC.sprite:setCurrentAnimation("running")
    end,
    
    keypressed = function(self, key)
       if     key == "left"  then SONIC:setState(STATES.BRAKE_RIGHT)
       elseif key == "space" then 
            SONIC:startJump()
            SONIC:setState(STATES.AIR_ACCELERATE_RIGHT) 
       end
    end,
    
    keyreleased = function(self, key)
        if     key == "right" then SONIC:setState(STATES.DECELERATE_RIGHT) end
    end,

    update = function(self, dt)
        SONIC.velocity.x = math.min(SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x + (SONIC.RUNNING_ACCELERATION * dt))
    end,
}
