local COLOR_GREEN         = { 0, 0.45, 0 }
                            -- https://htmlcolorcodes.com/colors/shades-of-green/
local COLOR_PURE_WHITE    = { 1, 1,    1 }

local leftX, topY, rightX, bottomY

return {
    getWidth    = love.graphics.getWidth,
    getHeight   = love.graphics.getHeight,
    groundLevel = 1282,

    init = function(self, params)
        self.graphics = params.GRAPHICS
        
        return self
    end,

    draw = function(self)
        self:updateImageCoordinates()
        self:drawHorizontalLine()
    end,

    updateImageCoordinates = function(self)
        leftX,  topY    = self.graphics:screenToImageCoordinates(0, 0)
        rightX, bottomY = self.graphics:screenToImageCoordinates(self:getWidth(), self:getHeight())
    end,

    drawHorizontalLine = function(self)
        self.graphics:setColor(COLOR_PURE_WHITE)
        self.graphics:setLineWidth(1.5)
        self.graphics:line(leftX, self.groundLevel, rightX, self.groundLevel)
    end,

    drawVerticalLine = function(self)
        self.graphics:setColor(COLOR_PURE_WHITE)
        self.graphics:setLineWidth(1.5)
        self.graphics:line(leftX + (rightX - leftX) / 2, topY, leftX + (rightX - leftX) / 2, bottomY)
    end,

    setGroundLevel = function(self, groundLevel)
        self.groundLevel = groundLevel
    end,
}
