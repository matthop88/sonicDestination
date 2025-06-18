local SONIC

local STAND_LEFT, STAND_RIGHT, RUN_LEFT, RUN_RIGHT

STAND_LEFT = {
    onEnter    = function(self) 
        SONIC:faceLeft() 
        SONIC.sprite:setCurrentAnimation("standing")
    end,
    
    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(RUN_RIGHT)
        elseif key == "left"  then SONIC:setState(RUN_LEFT)  end
    end, 
}

STAND_RIGHT = {
    onEnter    = function(self) 
        SONIC:faceRight()
        SONIC.sprite:setCurrentAnimation("standing")
    end,
    
    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(RUN_RIGHT)
        elseif key == "left"  then SONIC:setState(RUN_LEFT)  end
    end,
}

RUN_LEFT = {
    onEnter    = function(self)
        SONIC:faceLeft()
        SONIC.sprite:setCurrentAnimation("running")
    end,
    
    keypressed = function(self, key)
        if key == "right" then SONIC:setState(RUN_RIGHT) end
    end,
    
    keyreleased = function(self, key)
        if key == "left" then SONIC:setState(STAND_LEFT) end
    end,
}

RUN_RIGHT = {
    onEnter    = function(self)
        SONIC:faceRight()
        SONIC.sprite:setCurrentAnimation("running")
    end,
    
    keypressed = function(self, key)
       if key == "left" then SONIC:setState(RUN_LEFT) end
    end,
    
    keyreleased = function(self, key)
        if key == "right" then SONIC:setState(STAND_RIGHT) end
    end,
}
