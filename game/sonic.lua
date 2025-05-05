return ({
    x = 0, y = 0,
        
    sprite = requireRelative("sprite"),
    
    init = function(self)
        -- Initialization code goes here
        -- ...
            
        return self
    end,

    draw = function(self)
        self.sprite:draw(self:getX(), self:getY())
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    getX      = function(self) return self.x end,
    getY      = function(self) return self.y end,
         
    moveTo    = function(self, x, y)
        self.x, self.y = x, y
    end,

    isFacingRight = function(self)
        return not self.sprite:isXFlipped()
    end,

    isFacingLeft  = function(self)
        return self.sprite:isXFlipped()
    end,

}):init()
