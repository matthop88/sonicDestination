local SONIC, STATES

STATES = {
    STAND_LEFT  = "standLeft",
    STAND_RIGHT = "standRight",
    
    init = function(self, params)
        SONIC = params.SONIC
        for k, v in pairs(self) do
            if type(v) == "string" then
                self[k] = requireRelative("states/sonic/" .. v, { SONIC = SONIC, STATES = STATES })
            end
        end
        return self
    end,

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
