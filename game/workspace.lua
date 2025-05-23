local COLOR_GREEN         = { 0, 0.45, 0 }
                            -- https://htmlcolorcodes.com/colors/shades-of-green/
local COLOR_PURE_WHITE    = { 1, 1,    1 }

return {
    getWidth  = love.graphics.getWidth,
    getHeight = love.graphics.getHeight,
    
    draw = function(self)
        self:drawBackground()
        self:drawHorizontalLine()
    end,

    drawBackground = function(self)
        graphics:setColor(COLOR_GREEN)
        graphics:rectangle("fill", 0, 0, self:getWidth(), self:getHeight())
    end,

    drawHorizontalLine = function(self)
        graphics:setColor(COLOR_PURE_WHITE)
        graphics:setLineWidth(3)
        graphics:line(0, self:getHeight() * 3/4, self:getWidth(), self:getHeight() * 3/4)
    end,
}
