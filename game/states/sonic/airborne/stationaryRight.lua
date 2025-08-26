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
}
