local WORLD
local STATES
local GRAPHICS

local sonic1Sprite, sonic2Sprite

local SOUND_MANAGER  = requireRelative("sound/soundManager")

local JUMP_SOUND     = "sonicJumping"
local ringPanRight   = true

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
    AIR_DRAG_VALUE          =   1.875,        -- 0.03125 per     frame
    ------------------------------------------------------------------
    -- Source: https://info.sonicretro.org/SPG:Air_State#Air_Drag
    ------------------------------------------------------------------
    GROUND_LEVEL            = 940,

    HITBOX                  = nil,
    ringCount               = 0,

    frozen                  = false,
    active                  = true,
    airDrag                 = true,

    position = { x = 0, y = 0 },
    velocity = { x = 0, y = 0 },
        
    init = function(self, params)
        WORLD    = params.WORLD
        GRAPHICS = params.GRAPHICS
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS })
        sonic1Sprite = spriteFactory:create("sonic1")
        sonic2Sprite = spriteFactory:create("sonic2")
        
        self.sprite = sonic1Sprite
        self:initSensors(params.GRAPHICS)
        
        STATES          = requireRelative("states/sonic/sonic", { SONIC = self })
        self.nextState  = STATES.STAND_RIGHT

        return self
    end,

    initSensors = function(self, graphics)
        self.sensors = {
            requireRelative("collision/sensors/groundFront", { OWNER = self, WORLD = WORLD, GRAPHICS = graphics })
        }
    end,

    initPosition = function(self, x, y, standing)
        self:moveTo(x, y)
        self:activate()
        if standing then
            self.GROUND_LEVEL = y
            self.nextState  = STATES.STAND_RIGHT
            self.velocity.x = 0
            self.velocity.y = 0
        end
    end,

    draw = function(self)
        if self.active then
            self.sprite:draw(self:getX(), self:getY())
            self:drawSensors()
        end
    end,

    drawHitBox = function(self)
        local hitBox = self:getHitBox()
        if hitBox then hitBox:draw(GRAPHICS, { 1, 0, 1, 0.7 }, 3) end
    end,

    getHitBox = function(self)
        if self.HITBOX == nil then
            self.HITBOX = requireRelative("collision/hitBoxes/hitBox"):create(self.sprite:getHitBox())
        end
        return self.HITBOX
    end,

    drawSensors = function(self)
        for _, sensor in ipairs(self.sensors) do sensor:draw() end
    end,

    update = function(self, dt)
        if self.active then
            self.sprite:update(dt)
            if not self.frozen then
                self:updateState(dt)
                self:updateFrameRate(dt)
                self:applyGravity(dt)
                self:applyAirDrag(dt)
                self:updatePosition(dt)
            end
            self:updateSensors(dt)
            self:updateHitBox(dt)
            self:checkCollisions()
        end
    end,

    updateHitBox = function(self, dt)
        local hitBox = self:getHitBox()
        if hitBox then hitBox:update(self:getX(), self:getY()) end
    end,

    checkCollisions = function(self)
        self.HITBOX:setLastIntersectionWith(WORLD:checkCollisions(self))
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

    setScale      = function(self, scale)                       
        self.sprite.scale.x = scale
        self.sprite.scale.y = scale
    end,

    startJump     = function(self)
        if self:isGrounded() then 
            self.velocity.y = -self.JUMP_VELOCITY
            SOUND_MANAGER:play(JUMP_SOUND)
            self.sprite:setCurrentAnimation("jumping")
            self.airDrag = true
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
        local oldYPosition = self.position.y
        self.position.y = self.position.y + (self.velocity.y * dt)
        if self.velocity.y > 0 and oldYPosition - 10 < self.GROUND_LEVEL and self.position.y + 10 >= self.GROUND_LEVEL then
            self.position.y = self.GROUND_LEVEL
        end
    end,

    updateSensors = function(self, dt)
        for _, sensor in ipairs(self.sensors) do sensor:update(dt) end
    end,

    applyGravity = function(self, dt)
        if not self:isGrounded() then
            self.velocity.y = self.velocity.y + (self.GRAVITY_FORCE * dt)
        else
            self.velocity.y = 0
        end
    end,

    applyAirDrag = function(self, dt)
        if self.airDrag and self.velocity.y < 0 and self.velocity.y > -240 then
            self.velocity.x = self.velocity.x - (self.velocity.x * self.AIR_DRAG_VALUE * dt)
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

    toggleShowSensors = function(self)
        for _, sensor in ipairs(self.sensors) do sensor:toggleShow() end
    end,

    getWorld = function(self) return WORLD end,
    
    collectRings = function(self, ringCount)
        if ringPanRight then SOUND_MANAGER:play("ringCollectR")
        else                 SOUND_MANAGER:play("ringCollectL") end
        ringPanRight = not ringPanRight
        self.ringCount = self.ringCount + ringCount
        print("Total Number of Rings:", self.ringCount)
    end,

    isPlayer     = function(self) return true            end,
    getRingCount = function(self) return self.ringCount  end,
    freeze       = function(self) self.frozen  = true    end,
    unfreeze     = function(self) self.frozen  = false   end,
    deactivate   = function(self) self.active  = false   end,
    activate     = function(self) self.active  = true    end,
    airDragOff   = function(self) self.airDrag = false   end,

    setStanding  = function(self)
        if self:isFacingRight() then self:setState(STATES.STAND_RIGHT)
        else                         self:setState(STATES.STAND_LEFT)  end
    end,

    setBraking   = function(self)
        if self:isFacingRight() then self:setState(STATES.BRAKE_RIGHT)
        else                         self:setState(STATES.BRAKE_LEFT)  end
    end,
}
