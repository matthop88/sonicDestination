local COLOR_PURE_WHITE    = { 1, 1,    1 }

return ({
    x = 464,   y = 454,
    image        = love.graphics.newImage("game/resources/images/spriteSheets/sonic1.png"),
    offset       = { x = 16, y = 20 },
    standingRect = { x = 43, y = 257, w = 32, h = 40 },
    standingQuad = nil,

    scale        = 3,

    init = function(self)
        self.standingQuad = love.graphics.newQuad(self.standingRect.x,   self.standingRect.y,
                                                  self.standingRect.w,   self.standingRect.h,
                                                  self.image:getWidth(), self.image:getHeight())
        self.image:setFilter("nearest", "nearest")

        return self
    end,

    draw = function(self)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.draw(self.image,       self.standingQuad,
                           self:getImageX(), self:getImageY(),
                        0, self.scale,       self.scale)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    getX      = function(self) return self.x                                     end,
    getY      = function(self) return self.y                                     end,
    getImageX = function(self) return self:getX() - (self.offset.x * self.scale) end,
    getImageY = function(self) return self:getY() - (self.offset.y * self.scale) end,
        
    moveTo    = function(self, x, y)
        self.x, self.y = x, y
    end,

}):init()
