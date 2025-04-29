local COLORS = require "tools/lib/colors"
local GRID_SIZE, LABEL_FONT

return {
    init = function(self, gridSize, labelFont)
        GRID_SIZE = gridSize
        LABEL_FONT = labelFont
        return self
    end,

    draw = function(self, label, x1, y1, x2, y2)
        self:drawComponents(label, x1 * GRID_SIZE, y1 * GRID_SIZE, 
                                   x2 * GRID_SIZE, y2 * GRID_SIZE)
    end,

    drawComponents = function(self, label, x1, y1, x2, y2)
        self:drawBody(x1, y1, x2, y2)
        self:drawHead(x1, y1, x2, y2)
        self:drawLabel(label, x1, y1, x2, y2)
    end,

    drawBody = function(self, x1, y1, x2, y2)
        love.graphics.setColor(COLORS.MEDIUM_YELLOW)
        love.graphics.setLineWidth(4)
        love.graphics.line(x1, y1, x2, y2)
    end,

    drawHead = function(self, x1, y1, x2, y2)
        if x2 > x1 then
            self:drawHeadRight(x1, y1, x2, y2)
        else
            self:drawHeadLeft( x1, y1, x2, y2)
        end
    end,

    drawHeadRight = function(self, x1, y1, x2, y2)
        love.graphics.setColor(COLORS.MEDIUM_YELLOW)
        love.graphics.setLineWidth(4)
        love.graphics.line(x2, y2, x2 - 24, y2 - 16)
        love.graphics.line(x2, y2, x2 - 24, y2 + 16)
    end,

    drawHeadLeft = function(self, x1, y1, x2, y2)
        love.graphics.setColor(COLORS.MEDIUM_YELLOW)
        love.graphics.setLineWidth(4)
        love.graphics.line(x2, y2, x2 + 24, y2 - 16)
        love.graphics.line(x2, y2, x2 + 24, y2 + 16)
    end,

    drawLabel = function(self, label, x1, y1, x2, y2)
        love.graphics.setFont(LABEL_FONT) 
        love.graphics.setColor(COLORS.PURE_WHITE)
        love.graphics.printf(label, math.min(x1,  x2), y1 - LABEL_FONT:getHeight(), 
                                    math.abs(x2 - x1), "center")
    end,

}
