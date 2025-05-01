local COLORS = require "tools/lib/colors"
local GRID_SIZE, LABEL_FONT_SIZE, GRAFX

return {
    init = function(self, gridSize, labelFontSize, graphics)
        GRID_SIZE       = gridSize
        LABEL_FONT_SIZE = labelFont
        GRAFX           = graphics
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
        GRAFX:setColor(COLORS.MEDIUM_YELLOW)
        GRAFX:setLineWidth(4)
        GRAFX:line(x1, y1, x2, y2)
    end,

    drawHead = function(self, x1, y1, x2, y2)
        if x2 > x1 then
            self:drawHeadRight(x1, y1, x2, y2)
        else
            self:drawHeadLeft( x1, y1, x2, y2)
        end
    end,

    drawHeadRight = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.MEDIUM_YELLOW)
        GRAFX:setLineWidth(4)
        GRAFX:line(x2, y2, x2 - 24, y2 - 16)
        GRAFX:line(x2, y2, x2 - 24, y2 + 16)
    end,

    drawHeadLeft = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.MEDIUM_YELLOW)
        GRAFX:setLineWidth(4)
        GRAFX:line(x2, y2, x2 + 24, y2 - 16)
        GRAFX:line(x2, y2, x2 + 24, y2 + 16)
    end,

    drawLabel = function(self, label, x1, y1, x2, y2)
        GRAFX:setFontSize(LABEL_FONT_SIZE) 
        GRAFX:setColor(COLORS.PURE_WHITE)
        GRAFX:printf(label, math.min(x1,  x2), y1 - self.graphics:getFontHeight(), 
                            math.abs(x2 - x1), "center")
    end,

}
