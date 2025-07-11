local STATES

local sonic1Sprite, sonic2Sprite

return {
    -----------------------------------------------------------
    RUNNING_ACCELERATION = 168.75,
    -----------------------------------------------------------
    -- 12 subpixels per frame

    -- From Sonic Physics Guide
    -- https://info.sonicretro.org/SPG:Running#Acceleration

    -- Multiply by 60 to calculate acceleration per second
    -- Multiply by 60 again because velocity is 60x higher
    -----------------------------------------------------------
    MAX_RUNNING_SPEED = 360,
    -----------------------------------------------------------
    -- 6 pixels per frame

    -- From Sonic Physics Guide
    -- https://info.sonicretro.org/SPG:Running#Constants

    -- Multiply by 60 to calculate pixels per second (@ 60 fps)
    -----------------------------------------------------------
    
    position = { x = 0, y = 0 },
    velocity = { x = 0, y = 0 },
        
    init = function(self, params)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS })
        sonic1Sprite = spriteFactory:create("sonic1")
        sonic2Sprite = spriteFactory:create("sonic2")
        
        self.sprite     = sonic1Sprite
        STATES          = requireRelative("states/sonic", { SONIC = self })
        self.nextState  = STATES.STAND_RIGHT
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    update = function(self, dt)
        self.sprite:update(dt)
        self:updateState(dt)
        self:updateFrameRate(dt)
        self:updatePosition(dt)
    end,

    keypressed = function(self, key)
        if     key == "1" then
            local currentAnimationName = self.sprite:getCurrentAnimationName()
            self.sprite = sonic1Sprite
            self.sprite:setCurrentAnimation(currentAnimationName)
        elseif key == "2" then 
            local currentAnimationName = self.sprite:getCurrentAnimationName()
            self.sprite = sonic2Sprite
            self.sprite:setCurrentAnimation(currentAnimationName)
        else                   self.state:keypressed(key)  end
    end,

    keyreleased = function(self, key)
        if self.nextState.keyreleased then self.nextState:keyreleased(key) end
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    getX          = function(self) return self.position.x                               end,
    getY          = function(self) return self.position.y                               end,

    moveTo        = function(self, x, y)  self.position.x, self.position.y = x, y       end,

    isFacingLeft  = function(self) return     self.sprite:isXFlipped()                  end,
    isFacingRight = function(self) return not self.sprite:isXFlipped()                  end,
       
    faceRight     = function(self) if self:isFacingLeft()  then self.sprite:flipX() end end,
    faceLeft      = function(self) if self:isFacingRight() then self.sprite:flipX() end end,

    setState      = function(self, state)
        self.nextState = state
    end,

    updateState = function(self, dt)
        if self.nextState ~= self.state then
            self.state = self.nextState
            self.state:onEnter()
        elseif self.state.update then
            self.state:update(dt)
        end
    end,

    updateFrameRate = function(self, dt)
        self.sprite:setFPS(60 / ((math.max(0, 8 - math.abs(self.velocity.x / 60))) + 1))

        --[[
        Source:
        https://info.sonicretro.org/SPG:Animations#Variable_Speed_Animation_Timings
        --]]
    end,
    
    updatePosition = function(self, dt)
        self.position.x = self.position.x + (self.velocity.x * dt)
        self.position.y = self.position.y + (self.velocity.y * dt)
    end,

}
