local COLOR_GREEN         = { 0, 0.45, 0 }
                            -- https://htmlcolorcodes.com/colors/shades-of-green/
local COLOR_PURE_WHITE    = { 1, 1,    1 }

return {
    getWidth  = love.graphics.getWidth,
    getHeight = love.graphics.getHeight,
    
    draw = function(self)
        self:drawBackground()
        self:drawHorizontalLine()
        self:drawVerticalLines()
    end,

    drawBackground = function(self)
        love.graphics.setColor(COLOR_GREEN)
        love.graphics.rectangle("fill", 0, 0, self:getWidth(), self:getHeight())
    end,

    drawHorizontalLine = function(self)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.setLineWidth(3)
        love.graphics.line(0, self:getHeight() * 3/4, self:getWidth(), self:getHeight() * 3/4)
    end,

    drawVerticalLines = function(self)
        love.graphics.setLineWidth(1)
        love.graphics.line(self:getWidth() / 2,      0, self:getWidth() / 2,      self:getHeight())
        love.graphics.line(self:getWidth() / 2 - 48, 0, self:getWidth() / 2 - 48, self:getHeight())
        love.graphics.line(self:getWidth() / 2 + 48, 0, self:getWidth() / 2 + 48, self:getHeight())
    end,
}
