local SONIC, STATES

STATES = {
    init = function(self, params)
        SONIC = params.SONIC
        return self
    end,
    
    STAND_LEFT = {
        onEnter    = function(self) 
            SONIC:faceLeft() 
            SONIC.sprite:setCurrentAnimation("standing")
        end,
        
        keypressed = function(self, key)
            if     key == "right" then SONIC:setState(STATES.RUN_RIGHT)
            elseif key == "left"  then SONIC:setState(STATES.RUN_LEFT)  end
        end, 
    },

    STAND_RIGHT = {
        onEnter    = function(self) 
            SONIC:faceRight()
            SONIC.sprite:setCurrentAnimation("standing")
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
        end,
        
        keypressed = function(self, key)
            if key == "right" then SONIC:setState(STATES.RUN_RIGHT) end
        end,
        
        keyreleased = function(self, key)
            if key == "left" then SONIC:setState(STATES.STAND_LEFT) end
        end,
    },

    RUN_RIGHT = {
        onEnter    = function(self)
            SONIC:faceRight()
            SONIC.sprite:setCurrentAnimation("running")
        end,
        
        keypressed = function(self, key)
           if key == "left" then SONIC:setState(STATES.RUN_LEFT) end
        end,
        
        keyreleased = function(self, key)
            if key == "right" then SONIC:setState(STATES.STAND_RIGHT) end
        end,
    }
}

return STATES
