local STATES

return {
    x = 0, y = 0,
        
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

    getX          = function(self) return self.x                       end,
    getY          = function(self) return self.y                       end,

    moveTo        = function(self, x, y)  self.x, self.y = x, y        end,

    isFacingLeft  = function(self) return     self.sprite:isXFlipped()                  end,
    isFacingRight = function(self) return not self.sprite:isXFlipped()                  end,
       
    faceRight     = function(self) if self:isFacingLeft()  then self.sprite:flipX() end end,
    faceLeft      = function(self) if self:isFacingRight() then self.sprite:flipX() end end,

    setState      = function(self, state)
        self.state = state
        self.state:onEnter()
    end,

}
