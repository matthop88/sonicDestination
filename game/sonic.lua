return ({
    x = 0, y = 0,
        
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
            
    init = function(self, params)
        self.currentState = self.states.standRight
        self.sprite       = requireRelative("sprites/spriteFactory", { GRAPHICS = params.GRAPHICS }):create("sonic1"),
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    update = function(self, dt)
        self.sprite:update(dt)
    end,

    keypressed = function(self, key)
        self.currentState.keypressed(self, key)
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

    setState      = function(self, newStateName)
        self.currentState = self.states[newStateName]
        self.currentState.onEnter(self)
    end,

}):init()
