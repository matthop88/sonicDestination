local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:faceLeft()
        SONIC.sprite:setCurrentAnimation("running")
        SONIC.velocity.x = 0
    end,
    
    keypressed = function(self, key)
        if key == "right" then SONIC:setState(STATES.ACCELERATE_RIGHT) end
    end,
    
    keyreleased = function(self, key)
        if key == "left" then SONIC:setState(STATES.STAND_LEFT) end
    end,

    update = function(self, dt)
        SONIC.velocity.x = math.max(-SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x - (SONIC.RUNNING_ACCELERATION * dt))
    end,
}
