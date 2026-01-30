local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,

    onEnter    = function(self) 
        SONIC.velocity.y = -240
        if SONIC:isFacingRight() then SONIC.velocity.x = -120
        else                          SONIC.velocity.x =  120 end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then 
            SONIC:setStanding()
            SONIC:setFlashing()
        end
    end,
    
    keypressed = function(self, key)
        -- When hurt, no key press works
    end,
}
    
