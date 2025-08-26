local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        -- Do nothing
    end,
    
    keypressed = function(self, key)
        -- Do nothing
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then SONIC:setState(STATES.STAND_LEFT) end
    end,
}
