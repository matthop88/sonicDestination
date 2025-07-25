local SONIC

return {
    init = function(self, params)
        SONIC = params.SONIC
        return self
    end,
    
    onEnter    = function(self) 
        SONIC:faceLeft()
        SONIC.sprite:setCurrentAnimation("standing")
        SONIC.velocity.x = 0
    end,

    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(STATES.RUN_RIGHT)
        elseif key == "left"  then SONIC:setState(STATES.RUN_LEFT)  end
        end, 
}
