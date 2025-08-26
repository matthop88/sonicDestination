local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        SONIC:startJump()
    end,
    
    keypressed = function(self, key)
        if     key == "left"  then SONIC:setState(STATES.AIR_ACCELERATE_LEFT)
        elseif key == "right" then SONIC:setState(STATES.AIR_ACCELERATE_RIGHT) end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then SONIC:setState(STATES.DECELERATE_LEFT) end
    end,
}
