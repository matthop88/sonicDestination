return ({
    x = 464,   y = 454,
    image        = love.graphics.newImage("game/resources/images/spriteSheets/sonic1.png"),
    standingRect = { x = 43, y = 257, w = 32, h = 40 },
    standingQuad = nil,

    init = function(self)
        self.standingQuad = love.graphics.newQuad(self.standingRect.x,   self.standingRect.y,
                                                  self.standingRect.w,   self.standingRect.h,
                                                  self.image:getWidth(), self.image:getHeight())
        self.image:setFilter("nearest", "nearest")

        return self
    end,

    draw = function(self)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.draw(self.image, self.standingQuad, self.x, self.y, 0, 3, 3)
    end,
}):init()
