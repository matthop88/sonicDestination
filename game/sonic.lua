local STATES

local sonic1Sprite, sonic2Sprite

return {
    --------------------------------------------------------------
    BRAKING_ACCELERATION = 1800,           -- 0.5      pixels/frame      
    MIN_SPEED_TO_BRAKE   = 60,             -- 1        pixel /frame
    RUNNING_ACCELERATION = 168.75,         -- 0.046875 pixels/frame
    ---------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Running#Acceleration
    ---------------------------------------------------------------
    MAX_RUNNING_SPEED    = 360,            -- 6        pixels/frame
    ---------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Running#Constants
    ---------------------------------------------------------------
    JUMP_VELOCITY        = 390,            -- 6.5      pixels/frame
    GRAVITY_FORCE        = 787.5,          -- 0.21875  pixels/frame
    ---------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Jumping#Constants
    ---------------------------------------------------------------
    AIR_ACCELERATION     = 5.625,          -- 0.09375  pixels/frame
    ---------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Air_State#Constants
    ---------------------------------------------------------------
    GROUND_LEVEL         = 556,
    
    position = { x = 0, y = 0 },
    velocity = { x = 0, y = 0 },
        
    init = function(self, params)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS })
        sonic1Sprite = spriteFactory:create("sonic1")
        sonic2Sprite = spriteFactory:create("sonic2")
        
        self.sprite = sonic1Sprite
        
        STATES          = requireRelative("states/sonic/sonic", { SONIC = self })
        self.nextState  = STATES.STAND_RIGHT

        self:moveTo(512, self.GROUND_LEVEL)
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    update = function(self, dt)
        self.sprite:update(dt)
        self:updateState(dt)
        self:updateFrameRate(dt)
        self:applyGravity(dt)
        self:updatePosition(dt)
    end,

    keypressed = function(self, key)
       self.state:keypressed(key)                
    end,

    keyreleased = function(self, key)
        if self.nextState.keyreleased then self.nextState:keyreleased(key) end
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    changeSonicSprite = function(self, sonicSprite)
        local currentAnimationName = self.sprite:getCurrentAnimationName()
        local xFlipped = self.sprite:isXFlipped()
        self.sprite = sonicSprite
        self.sprite:setCurrentAnimation(currentAnimationName)
        self.sprite:setXFlipped(xFlipped)
    end,
    
    getX          = function(self) return self.position.x                               end,
    getY          = function(self) return self.position.y                               end,

    moveTo        = function(self, x, y)  self.position.x, self.position.y = x, y       end,

    isFacingLeft  = function(self) return     self.sprite:isXFlipped()                  end,
    isFacingRight = function(self) return not self.sprite:isXFlipped()                  end,
       
    faceRight     = function(self) if self:isFacingLeft()  then self.sprite:flipX() end end,
    faceLeft      = function(self) if self:isFacingRight() then self.sprite:flipX() end end,

    startJump     = function(self)
        if self:isGrounded() then self.velocity.y = -self.JUMP_VELOCITY end
    end,

    isGrounded    = function(self)
        return self.position.y == self.GROUND_LEVEL and self.velocity.y >= 0
    end,
    
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
        --------------------------------------------------------------------------------------
        -- Source: https://info.sonicretro.org/SPG:Animations#Variable_Speed_Animation_Timings
    end,
    
    updatePosition = function(self, dt)
        self.position.x = self.position.x + (self.velocity.x * dt)
        self.position.y = math.min(self.GROUND_LEVEL, self.position.y + (self.velocity.y * dt))
    end,

    applyGravity = function(self, dt)
        if not self:isGrounded() then
            self.velocity.y = self.velocity.y + (self.GRAVITY_FORCE * dt)
        else
            self.velocity.y = 0
        end
    end,

    onPropertyChange = function(self, propData)
        if     propData.player1 == "sonic2" and self.sprite == sonic1Sprite then
            self:changeSonicSprite(sonic2Sprite)
        elseif propData.player1 ~= "sonic2" and self.sprite == sonic2Sprite then
            self:changeSonicSprite(sonic1Sprite)
        end
    end,
}
