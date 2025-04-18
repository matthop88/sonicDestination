local COLOR_PURE_WHITE = { 1, 1, 1 }

return ({
    image        = love.graphics.newImage(relativePath("resources/images/spriteSheets/sonic1.png")),
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

    draw = function(self, x, y)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.draw(self.image,        self.standingQuad,
                           self:getImageX(x), self:getImageY(y),
                        0, self.scale,        self.scale)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    getImageX = function(self, x) return x - (self.offset.x * self.scale) end,
    getImageY = function(self, y) return y - (self.offset.y * self.scale) end,
        
}):init()
