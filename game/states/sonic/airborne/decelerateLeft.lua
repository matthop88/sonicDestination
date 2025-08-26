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
        -- Do nothing
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then SONIC:setState(STATES.DECELERATE_LEFT) end
    end,
}
