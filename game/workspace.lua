local COLOR_GREEN         = { 0, 0.45, 0 }
                            -- https://htmlcolorcodes.com/colors/shades-of-green/
local COLOR_PURE_WHITE    = { 1, 1,    1 }

return {
    draw = function(self)
        self:drawBackground()
        self:drawHorizontalLine()
    end,

    drawBackground = function(self)
        love.graphics.setColor(COLOR_GREEN)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end,

    drawHorizontalLine = function(self)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.setLineWidth(3)
        love.graphics.line(0, love.graphics.getHeight() * 3 / 4, love.graphics.getWidth(), love.graphics.getHeight() * 3 / 4)
    end,
}
