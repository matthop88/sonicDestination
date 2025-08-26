local SONIC, STATES

local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        if SONIC.velocity.x >= SONIC.MIN_SPEED_TO_BRAKE then
            SONIC.sprite:setCurrentAnimation("braking")
            SOUND_MANAGER:play("sonicBraking")
        end
    end,
    
    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(STATES.ACCELERATE_RIGHT) 
        elseif key == "space" then SONIC:setState(STATES.AIR_ACCELERATE_LEFT) end
    end,
    
    keyreleased = function(self, key)
        if key == "left" then
            SONIC:setState(STATES.DECELERATE_RIGHT)
        end
    end,

    update = function(self, dt)
        SONIC.velocity.x = math.max(0, SONIC.velocity.x - (SONIC.BRAKING_ACCELERATION * dt))
        if SONIC.velocity.x == 0 then SONIC:setState(STATES.ACCELERATE_LEFT) end
    end,
}
