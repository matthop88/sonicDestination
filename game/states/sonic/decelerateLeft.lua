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
        if     key == "left"  then SONIC:setState(STATES.ACCELERATE_LEFT) 
        elseif key == "right" then SONIC:setState(STATES.BRAKE_LEFT)  end
    end,
    
    keyreleased = function(self, key)
        -- do nothing
    end,

    update = function(self, dt)
        SONIC.velocity.x = math.min(0, SONIC.velocity.x + (SONIC.RUNNING_ACCELERATION * dt))
        if SONIC.velocity.x == 0 then SONIC:setState(STATES.STAND_LEFT) end
    end,
}
