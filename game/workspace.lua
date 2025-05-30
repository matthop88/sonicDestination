local COLOR_GREEN         = { 0, 0.45, 0 }
                            -- https://htmlcolorcodes.com/colors/shades-of-green/
local COLOR_PURE_WHITE    = { 1, 1,    1 }

return {
    getWidth  = love.graphics.getWidth,
    getHeight = love.graphics.getHeight,

    init = function(self, params)
        self.graphics = params.GRAPHICS
        return self
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawHorizontalLine()
    end,

    drawBackground = function(self)
        self.graphics:setColor(COLOR_GREEN)
        self.graphics:rectangle("fill", 0, 0, self:getWidth(), self:getHeight())
    end,

    drawHorizontalLine = function(self)
        self.graphics:setColor(COLOR_PURE_WHITE)
        self.graphics:setLineWidth(3)
        self.graphics:line(0, self:getHeight() * 3/4, self:getWidth(), self:getHeight() * 3/4)
    end,
}
