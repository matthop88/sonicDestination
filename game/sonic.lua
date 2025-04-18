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
        love.graphics.draw(self.image, self.standingQuad, self.x - (self.offset.x * self.scale), 
                                                          self.y - (self.offset.y * self.scale), 
                                                          0, self.scale, self.scale)
    end,
}):init()
