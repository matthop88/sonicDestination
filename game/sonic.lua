local SONIC

local STAND_LEFT, STAND_RIGHT

STAND_LEFT = {
    onEnter    = function(self) SONIC:faceLeft() end,
    keypressed = function(self, key)
        if key == "right" then SONIC:setState(STAND_RIGHT) end
    end,
}

STAND_RIGHT = {
    onEnter    = function(self) SONIC:faceRight() end,
    keypressed = function(self, key)
        if key == "left" then SONIC:setState(STAND_LEFT) end
    end,
}

RUN_LEFT = {
    onEnter    = function(self)
        SONIC:faceLeft()
        SONIC.sprite:setCurrentAnimation("running")
    end,
    keypressed = function(self, key)
        -- ...
    end,
}

RUN_RIGHT = {
    onEnter    = function(self)
        SONIC:faceRight()
        SONIC.sprite:setCurrentAnimation("running")
    end,
    keypressed = function(self, key)
        -- ...
    end,
}

return {
    x = 0, y = 0,
        
    state = STAND_RIGHT,
            
    init = function(self, params)
        self.sprite       = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS }):create("sonic1")
        SONIC = self
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
        if     key == "up"   then
            self.sprite:setCurrentAnimation("running")
        elseif key == "down" then
            self.sprite:setCurrentAnimation("standing")
        end
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
