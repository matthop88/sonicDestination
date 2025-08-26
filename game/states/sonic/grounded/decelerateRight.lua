local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        -- do nothing
    end,
    
    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(STATES.ACCELERATE_RIGHT) 
        elseif key == "left"  then SONIC:setState(STATES.BRAKE_RIGHT)  
        elseif key == "space" then SONIC:setState(STATES.AIR_DECELERATE_RIGHT) end
    end,
    
    keyreleased = function(self, key)
        -- do nothing
    end,

    update = function(self, dt)
        SONIC.velocity.x = math.max(0, SONIC.velocity.x - (SONIC.RUNNING_ACCELERATION * dt))
        if SONIC.velocity.x == 0 then SONIC:setState(STATES.STAND_RIGHT) end
    end,
}
