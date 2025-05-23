local COLORS = require "tools/lib/colors"

return {
    init = function(self, gridSize, labelFontSize, graphics)
        self.GRID_SIZE       = gridSize
        self.LABEL_FONT_SIZE = labelFontSize
        self.graphics        = graphics
        return self
    end,

    create = function(self, label, x, y, w, h)
        return {
            GRID_SIZE       = self.GRID_SIZE,
            LABEL_FONT_SIZE = self.LABEL_FONT_SIZE,
            graphics        = self.graphics,

            label           = label,
            x               = x * self.GRID_SIZE,
            y               = y * self.GRID_SIZE,
            w               = w * self.GRID_SIZE,
            h               = h * self.GRID_SIZE,

            draw = function(self)
                if self:isMouseInside() then
                    self:drawHighlightedBox()
                    self:drawHighlightedLabel()
                else
                    self:drawBox()
                    self:drawLabel()
                end
            end,
            
            drawBox = function(self)
                self.graphics:setColor(COLORS.LIGHT_YELLOW)
                self.graphics:rectangle("fill", self.x, self.y, self.w, self.h)
                self.graphics:setColor(COLORS.JET_BLACK)
                self.graphics:setLineWidth(5)
                self.graphics:rectangle("line", self.x, self.y, self.w, self.h)
            end,

            drawHighlightedBox = function(self)
                self.graphics:setColor(COLORS.LIGHT_YELLOW)
                self.graphics:rectangle("fill", self.x - 5, self.y - 5, self.w + 10, self.h + 10)
                self.graphics:setColor(COLORS.RED)
                self.graphics:setLineWidth(5)
                self.graphics:rectangle("line", self.x - 5, self.y - 5, self.w + 10, self.h + 10)
            end,
        
            drawLabel = function(self)
                self.graphics:setFontSize(self.LABEL_FONT_SIZE)
                self.graphics:setColor(COLORS.JET_BLACK)
                self.graphics:printf(self.label, self.x, self.y + (self.h - self.graphics:getFontHeight()) / 2, self.w, "center")
            end,
        
            drawHighlightedLabel = function(self)
                self.graphics:setFontSize(self.LABEL_FONT_SIZE + 3) 
                self.graphics:setColor(COLORS.JET_BLACK)
                self.graphics:printf(self.label, self.x, self.y + (self.h - self.graphics:getFontHeight()) / 2, self.w, "center")
            end,

            isMouseInside = function(self)
                local px, py = self.graphics:screenToImageCoordinates(love.mouse.getPosition())
                return px >= self.x and px <= self.x + self.w and py >= self.y and py <= self.y + self.h
            end,
        }
    end,

    
}
