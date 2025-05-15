return ({
    x = 0, y = 0,
        
    sprite = requireRelative("sprite"),

    states = {
        standLeft  = { 
            onEnter    = function(self) self:faceLeft() end, 
            keypressed = function(self, key)
                if key == "right" then self:setState("standRight") end
             end,
        },
        standRight = { 
            onEnter = function(self) self:faceRight() end, 
            keypressed = function(self, key)
                if key == "left" then self:setState("standLeft") end
            end,
        },
    },
            
    init = function(self)
        self.currentState = self.states.standRight
            
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    keypressed = function(self, key)
        self.currentState.keypressed(self, key)
        if     key == "k" then
            self.sprite.animations:advanceFrame()
        elseif key == "j" then
            self.sprite.animations:regressFrame()
        elseif key == "w" then
            self.sprite.animations:setCurrentAnimation("running")
        elseif key == "s" then
            self.sprite.animations:setCurrentAnimation("standing")
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

    setState      = function(self, newStateName)
        self.currentState = self.states[newStateName]
        self.currentState.onEnter(self)
    end,

}):init()
