local COLORS = require "tools/lib/colors"
local GRID_SIZE, LABEL_FONT_SIZE, GRAFX

local function isPtInside(sx, sy, x, y, w, h)
    local px, py = GRAFX:screenToImageCoordinates(sx, sy)
    return px >= x and px <= x + w and py >= y and py <= y + h
end

return {
    init = function(self, gridSize, labelFontSize, graphics)
        GRID_SIZE       = gridSize
        LABEL_FONT_SIZE = labelFontSize
        GRAFX           = graphics
        return self
    end,

    draw = function(self, label, x, y, w, h)
        self:drawComponents(label, x * GRID_SIZE, y * GRID_SIZE, 
                                   w * GRID_SIZE, h * GRID_SIZE)
    end,

    drawComponents = function(self, label, x, y, w, h)
        local mx, my = love.mouse.getPosition()
        if not isPtInside(mx, my, x, y, w, h) then
            self:drawBox(         x, y, w, h)
            self:drawLabel(label, x, y, w, h)
        else
            self:drawHighlightedBox(         x, y, w, h)
            self:drawHighlightedLabel(label, x, y, w, h)
        end
    end,

    drawBox = function(self, x, y, w, h)
        GRAFX:setColor(COLORS.LIGHT_YELLOW)
        GRAFX:rectangle("fill", x, y, w, h)
        GRAFX:setColor(COLORS.JET_BLACK)
        GRAFX:setLineWidth(5)
        GRAFX:rectangle("line", x, y, w, h)
    end,

    drawHighlightedBox = function(self, x, y, w, h)
        GRAFX:setColor(COLORS.LIGHT_YELLOW)
        GRAFX:rectangle("fill", x - 5, y - 5, w + 10, h + 10)
        GRAFX:setColor(COLORS.RED)
        GRAFX:setLineWidth(5)
        GRAFX:rectangle("line", x - 5, y - 5, w + 10, h + 10)
    end,

    drawLabel = function(self, label, x, y, w, h)
        GRAFX:setFontSize(LABEL_FONT_SIZE)
        GRAFX:setColor(COLORS.JET_BLACK)
        GRAFX:printf(label, x, y + (h - GRAFX:getFontHeight()) / 2, w, "center")
    end,

    drawHighlightedLabel = function(self, label, x, y, w, h)
        GRAFX:setFontSize(LABEL_FONT_SIZE + 3) 
        GRAFX:setColor(COLORS.JET_BLACK)
        GRAFX:printf(label, x, y + (h - GRAFX:getFontHeight()) / 2, w, "center")
    end,
}
