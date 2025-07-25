local SONIC, STATES

STATES = {
    init = function(self, params)
        SONIC = params.SONIC
        return self
    end,
    
    STAND_LEFT = requireRelative("game/states/sonic/standLeft", { SONIC = SONIC }),
    
    STAND_RIGHT = {
        onEnter    = function(self) 
            SONIC:faceRight()
            SONIC.sprite:setCurrentAnimation("standing")
            SONIC.velocity.x = 0
        end,
        
        keypressed = function(self, key)
            if     key == "right" then SONIC:setState(STATES.RUN_RIGHT)
            elseif key == "left"  then SONIC:setState(STATES.RUN_LEFT)  end
        end,
    },

    RUN_LEFT = {
        onEnter    = function(self)
            SONIC:faceLeft()
            SONIC.sprite:setCurrentAnimation("running")
            SONIC.velocity.x = 0
        end,
        
        keypressed = function(self, key)
            if key == "right" then SONIC:setState(STATES.RUN_RIGHT) end
        end,
        
        keyreleased = function(self, key)
            if key == "left" then SONIC:setState(STATES.STAND_LEFT) end
        end,

        update = function(self, dt)
            SONIC.velocity.x = math.max(-SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x - (SONIC.RUNNING_ACCELERATION * dt))
        end,
    },

    RUN_RIGHT = {
        onEnter    = function(self)
            SONIC:faceRight()
            SONIC.sprite:setCurrentAnimation("running")
            SONIC.velocity.x = 0
        end,
        
        keypressed = function(self, key)
           if key == "left" then SONIC:setState(STATES.RUN_LEFT) end
        end,
        
        keyreleased = function(self, key)
            if key == "right" then SONIC:setState(STATES.STAND_RIGHT) end
        end,

        update = function(self, dt)
            SONIC.velocity.x = math.min(SONIC.MAX_RUNNING_SPEED, SONIC.velocity.x + (SONIC.RUNNING_ACCELERATION * dt))
        end,
    }
}

return STATES
