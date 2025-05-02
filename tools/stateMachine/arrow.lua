local COLORS = require "tools/lib/colors"
local GRID_SIZE, LABEL_FONT_SIZE, GRAFX

local function calculateXAndWidth(x1, x2)
    local x = math.min(x1,  x2)
    local w = math.abs(x1 - x2)
    
    if w < 30 then
        x = ((x1 + x2) / 2) - 15
        w = 30
    end

    return x, w
end

local function calculateYAndHeight(y1, y2)
    local y = math.min(y1,  y2)
    local h = math.abs(y1 - y2)

    if h < 30 then
        y = ((y1 + y2) / 2) - 15
        h = 30
    end

    return y, h
end
        
local function lineToRect(x1, y1, x2, y2)
    local x, w = calculateXAndWidth( x1, x2)
    local y, h = calculateYAndHeight(y1, y2)

    return x, y, w, h
end

local function isPtInRect(sx, sy, x, y, w, h))
    local px, py = GRAFX:screenToImageCoordinates(sx, sy)
    return px >= x and px <= x + w and py >= y and py <= y + h
end

local function isMouseInsideRect(x, y, w, h)
    local mx, my = love.mouse.getPosition()
    
    return isPtInRect(mx, my, x, y, w, h)
end

return {
    init = function(self, gridSize, labelFontSize, graphics)
        GRID_SIZE       = gridSize
        LABEL_FONT_SIZE = labelFontSize
        GRAFX           = graphics
        return self
    end,

    draw = function(self, label, x1, y1, x2, y2)
        self:drawComponents(label, x1 * GRID_SIZE, y1 * GRID_SIZE, 
                                   x2 * GRID_SIZE, y2 * GRID_SIZE)
    end,

    drawComponents = function(self, label, x1, y1, x2, y2)
        if not isMouseInsideRect(lineToRect(x1, y1, x2, y2)) then
            self:drawBody(        x1, y1, x2, y2)
            self:drawHead(        x1, y1, x2, y2)
            self:drawLabel(label, x1, y1, x2, y2)
        else
            self:drawHighlightedBody(        x1, y1, x2, y2)
            self:drawHighlightedHead(        x1, y1, x2, y2)
            self:drawHighlightedLabel(label, x1, y1, x2, y2)
        end
    end,

    drawBody = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.MEDIUM_YELLOW)
        GRAFX:setLineWidth(4)
        GRAFX:line(x1, y1, x2, y2)
    end,

    drawHighlightedBody = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.RED)
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

    drawHighlightedHead = function(self, x1, y1, x2, y2)
        if x2 > x1 then
            self:drawHighlightedHeadRight(x1, y1, x2, y2)
        else
            self:drawHighlightedHeadLeft( x1, y1, x2, y2)
        end
    end,

    drawHeadRight = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.MEDIUM_YELLOW)
        GRAFX:setLineWidth(4)
        GRAFX:line(x2, y2, x2 - 24, y2 - 16)
        GRAFX:line(x2, y2, x2 - 24, y2 + 16)
    end,

    drawHighlightedHeadRight = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.RED)
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

    drawHighlightedHeadLeft = function(self, x1, y1, x2, y2)
        GRAFX:setColor(COLORS.RED)
        GRAFX:setLineWidth(4)
        GRAFX:line(x2, y2, x2 + 24, y2 - 16)
        GRAFX:line(x2, y2, x2 + 24, y2 + 16)
    end,

    drawLabel = function(self, label, x1, y1, x2, y2)
        GRAFX:setFontSize(LABEL_FONT_SIZE) 
        GRAFX:setColor(COLORS.PURE_WHITE)
        GRAFX:printf(label, math.min(x1,  x2), y1 - GRAFX:getFontHeight(), 
                            math.abs(x2 - x1), "center")
    end,

    drawHighlightedLabel = function(self, label, x1, y1, x2, y2)
        GRAFX:setFontSize(LABEL_FONT_SIZE + 2) 
        GRAFX:setColor(COLORS.PURE_WHITE)
        GRAFX:printf(label, math.min(x1,  x2), y1 - GRAFX:getFontHeight(), 
                            math.abs(x2 - x1), "center")
    end,

}
