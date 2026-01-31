local SONIC, STATES

local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,

    onEnter    = function(self) 
        SONIC.sprite:setCurrentAnimation("hurt")
        SONIC.velocity.y = -240
        if SONIC:isFacingRight() then SONIC.velocity.x = -240
        else                          SONIC.velocity.x =  240 end
        --SOUND_MANAGER:play("sonicHit")
        SOUND_MANAGER:play("klank")
        SOUND_MANAGER:play("delayedOuch")
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
