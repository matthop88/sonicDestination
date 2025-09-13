local STATES

local sonic1Sprite, sonic2Sprite

local SOUND_MANAGER = requireRelative("sound/soundManager")

local JUMP_SOUND = "sonicJumping"

return {
    ------------------------------------------------------------------
    BRAKING_ACCELERATION    = 1800,           -- 0.5      pixels/frame      
    MIN_SPEED_TO_BRAKE      = 60,             -- 1        pixel /frame
    RUNNING_ACCELERATION    = 168.75,         -- 0.046875 pixels/frame
    ------------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Running#Acceleration
    ------------------------------------------------------------------
    MAX_RUNNING_SPEED       = 360,            -- 6        pixels/frame
    ------------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Running#Constants
    ------------------------------------------------------------------
    JUMP_VELOCITY           = 390,            -- 6.5      pixels/frame
    THROTTLED_JUMP_VELOCITY = 240,            -- 4        pixels/frame
    GRAVITY_FORCE           = 787.5,          -- 0.21875  pixels/frame
    ------------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Jumping#Constants
    ------------------------------------------------------------------
    AIR_ACCELERATION        = 337.5,          -- 0.09375  pixels/frame
    ------------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Air_State#Constants
    ------------------------------------------------------------------
    AIR_DRAG_VALUE          =   1.875         -- 0.03125 per     frame
    ------------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Air_State#Air_Drag
    ------------------------------------------------------------------
    GROUND_LEVEL            = 556,
    
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

    getImageX     = function(self) return self.sprite:getImageX(self:getX())            end,
    getImageY     = function(self) return self.sprite:getImageY(self:getY())            end,
    getImageW     = function(self) return self.sprite:getImageW()                       end,
    getImageH     = function(self) return self.sprite:getImageH()                       end,

    getGeneralX   = function(self) return self.sprite:getGeneralX(self:getX())          end,
    getGeneralY   = function(self) return self.sprite:getGeneralY(self:getY())          end,
    
    moveTo        = function(self, x, y)  self.position.x, self.position.y = x, y       end,

    isFacingLeft  = function(self) return     self.sprite:isXFlipped()                  end,
    isFacingRight = function(self) return not self.sprite:isXFlipped()                  end,
       
    faceRight     = function(self) if self:isFacingLeft()  then self.sprite:flipX() end end,
    faceLeft      = function(self) if self:isFacingRight() then self.sprite:flipX() end end,

    startJump     = function(self)
        if self:isGrounded() then 
            self.velocity.y = -self.JUMP_VELOCITY
            SOUND_MANAGER:play(JUMP_SOUND)
            self.sprite:setCurrentAnimation("jumping")
        end
    end,

    throttleJump  = function(self)
        self.velocity.y = math.max(self.velocity.y, -self.THROTTLED_JUMP_VELOCITY)
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
        if self:isGrounded() then self.sprite:setFPS(60 / ((math.max(0, 8 - math.abs(self.velocity.x / 60))) + 1))
        else                      self.sprite:setFPS(60 / ((math.max(0, 4 - math.abs(self.velocity.x / 60))) + 1))  end
        ---------------------------------------------------------------------------------------------------------------
        --           Source: https://info.sonicretro.org/SPG:Animations#Variable_Speed_Animation_Timings             --
        ---------------------------------------------------------------------------------------------------------------
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
        if propData.jumpSound then
            JUMP_SOUND = propData.jumpSound
        end
    end,
}
