local STATES

return {
    position = { x = 0, y = 0 },
    velocity = { x = 0, y = 0 },
        
    init = function(self, params)
        self.sprite = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS }):create("sonic1")
        STATES      = requireRelative("states/sonic",          { SONIC = self })
        self.state  = STATES.STAND_RIGHT
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    update = function(self, dt)
        self.sprite:update(dt)
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
        self.state = state
        self.state:onEnter()
    end,

    updatePosition = function(self, dt)
        self.position.x = self.position.x + (self.velocity.x * dt)
        self.position.y = self.position.y + (self.velocity.y * dt)
    end,

}
