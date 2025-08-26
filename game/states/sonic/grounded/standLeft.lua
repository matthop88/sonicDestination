local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self) 
        SONIC:faceLeft()
        SONIC.sprite:setCurrentAnimation("standing")
        SONIC.velocity.x = 0
    end,

    keypressed = function(self, key)
        if     key == "right" then SONIC:setState(STATES.ACCELERATE_RIGHT)
        elseif key == "left"  then SONIC:setState(STATES.ACCELERATE_LEFT) 
        elseif key == "space" then SONIC:setState(STATES.AIR_STATIONARY_LEFT)
        end
    end,
}
