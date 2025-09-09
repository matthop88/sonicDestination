local SONIC, STATES

return {
    init = function(self, params)
        SONIC  = params.SONIC
        STATES = params.STATES
        return self
    end,
    
    onEnter    = function(self)
        -- do nothing
    end,
    
    keypressed = function(self, key)
        if     key == "left"  then SONIC:setState(STATES.AIR_ACCELERATE_LEFT)
        elseif key == "right" then SONIC:setState(STATES.AIR_ACCELERATE_RIGHT) end
    end,

    keyreleased = function(self, key)
        if key == "space" then SONIC:throttleJump() end
    end,

    update     = function(self, dt)
        if SONIC:isGrounded() then 
            SONIC:setState(STATES.DECELERATE_LEFT) 
        else
            SONIC.velocity.x = math.min(0, SONIC.velocity.x + (SONIC.AIR_ACCELERATION * dt))
            if SONIC.velocity.x == 0 then SONIC:setState(STATES.AIR_STATIONARY_LEFT) end
            if SONIC.sprite:getFPS() >= 60 then
                SONIC.sprite:setCurrentAnimation("fastJumping")
            else
                SONIC.sprite:setCurrentAnimation("jumping")
            end
        end
    end,
}
