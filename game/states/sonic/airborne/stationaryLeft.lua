local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:startJump()
        SONIC.velocity.x = 0
    end,
    
    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(STATES.AIR_ACCELERATE_RIGHT)
        elseif key == "left"  then SONIC:setState(STATES.AIR_ACCELERATE_LEFT) end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then SONIC:setState(STATES.STAND_LEFT) end
    end,
}
