local COLORS = require "tools/lib/colors"
local GRID_SIZE, LABEL_FONT, GRAFX

return {
    init = function(self, gridSize, labelFont, graphics)
        GRID_SIZE  = gridSize
        LABEL_FONT = labelFont
        GRAFX      = graphics
        return self
    end,

    draw = function(self, label, x, y, w, h)
        self:drawComponents(label, x * GRID_SIZE, y * GRID_SIZE, 
                                   w * GRID_SIZE, h * GRID_SIZE)
    end,

    drawComponents = function(self, label, x, y, w, h)
        self:drawShape(       x, y, w, h)
        self:drawLabel(label, x, y, w, h)
    end,

    drawShape = function(self, x, y, w, h)
        GRAFX:setColor(COLORS.LIGHT_YELLOW)
        GRAFX:rectangle("fill", x, y, w, h)
        GRAFX:setColor(COLORS.JET_BLACK)
        love.graphics.setLineWidth(5)
        GRAFX:rectangle("line", x, y, w, h)
    end,

    drawLabel = function(self, label, x, y, w, h)
        love.graphics.setFont(LABEL_FONT) 
        GRAFX:setColor(COLORS.JET_BLACK)
        love.graphics.printf(label, x, y + (h - LABEL_FONT:getHeight()) / 2, w, "center")
    end,
}
