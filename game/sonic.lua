local STATES

return {
    RUNNING_SPEED = 360,
    
    position = { x = 0, y = 0 },
    velocity = { x = 0, y = 0 },
        
    init = function(self, params)
        self.sprite     = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS }):create("sonic1")
        STATES          = requireRelative("states/sonic",          { SONIC = self })
        self.nextState  = STATES.STAND_RIGHT
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    update = function(self, dt)
        self.sprite:update(dt)
        self:updateState()
        self:updateVelocity(dt)
        self:updatePosition(dt)
    end,

    keypressed = function(self, key)
        self.state:keypressed(key)
    end,

    keyreleased = function(self, key)
        if self.state.keyreleased then self.state:keyreleased(key) end
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

    updateState = function(self)
        if self.nextState ~= self.state then
            self.state = self.nextState
            self.state:onEnter()
        end
    end,

    updateVelocity = function(self, dt)
        if     self.velocity.x > 0 then self.velocity.x =  self.RUNNING_SPEED
        elseif self.velocity.x < 0 then self.velocity.x = -self.RUNNING_SPEED end
        self:updateFrameRate(dt)
    end,

    updateFrameRate = function(self, dt)
        --[[
        For walking and running:

        duration = floor(max(0, 8-abs(GroundSpeed)))

        FPS is the reciprocal of duration.

        DURATION            FPS
        --------            ---
        0                   60
        1                   30
        2                   20
        3                   15
        4                   12
        5                   10
        6                    8.5
        7                    7.5
        8                    6.75

        GROUND SPEED        FPS
        ------------        ---
        480                 60
        420                 30
        360                 20
        300                 15
        240                 12
        180                 10
        120                  8.5
         60                  7.5
          0                  6.75

        Q: Is this accurate?
           Shouldn't FPS be proportional to ground speed?

        --]]

        self.sprite:setFps(self.velocity.x / 36)
    end,
    
    updatePosition = function(self, dt)
        self.position.x = self.position.x + (self.velocity.x * dt)
        self.position.y = self.position.y + (self.velocity.y * dt)
    end,

}
