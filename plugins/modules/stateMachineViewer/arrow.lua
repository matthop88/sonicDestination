local COLORS = require "tools/lib/colors"

local function ternary(params)
    return params.IF and params.THEN or params.ELSE
end

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

return {
    init = function(self, gridSize, labelFontSize, graphics)
        self.GRID_SIZE       = gridSize
        self.LABEL_FONT_SIZE = labelFontSize
        self.GRAFX           = graphics
        return self
    end,

    create = function(self, label, x1, y1, x2, y2)
        return ({
            LABEL_FONT_SIZE   = self.LABEL_FONT_SIZE,
            graphics          = self.GRAFX,
            
            isMouseInsideRect = self.isMouseInsideRect,
            isPtInRect        = self.isPtInRect,

            label             = label,
            x1                = x1 * self.GRID_SIZE,
            y1                = y1 * self.GRID_SIZE,
            x2                = x2 * self.GRID_SIZE,
            y2                = y2 * self.GRID_SIZE,

            highlighted       = false,
            selected          = false,

            init = function(self)
                self.x, self.y, self.w, self.h = lineToRect(self.x1, self.y1, self.x2, self.y2)
                return self
            end,

            getType = function(self)
                return "ARROW"
            end,
            
            draw = function(self)
                self.highlighted = self:isMouseInside()
                
                self:drawBody()
                self:drawHead()
                self:drawLabel()
            end,

            isMouseInside = function(self)
                return self:isMouseInsideRect(self.x, self.y, self.w, self.h)
            end,
            
            drawBody = function(self)
                self:setArrowColor() 
                self.graphics:setLineWidth(4)
                self.graphics:line(self.x1, self.y1, self.x2, self.y2)
            end,
            
            setArrowColor = function(self)
                if     self.selected    then self.graphics:setColor(COLORS.RED)
                elseif self.highlighted then self.graphics:setColor(COLORS.RED)
                else                         self.graphics:setColor(COLORS.MEDIUM_YELLOW) end
            end,
        
            drawHead = function(self)
                if self.y1 == self.y2 then self:drawHorizontalHead()
                else                       self:drawVerticalHead()  end
            end,
                
            drawHorizontalHead = function(self)
                local arrowBackPt = ternary { IF = self.x2 > self.x1, THEN = -24, ELSE = 24 }
                
                self:setArrowColor()
                self.graphics:setLineWidth(4)
                self.graphics:line(self.x2, self.y2, self.x2 + arrowBackPt, self.y2 - 16)
                self.graphics:line(self.x2, self.y2, self.x2 + arrowBackPt, self.y2 + 16)
            end,

            drawVerticalHead = function(self)
                local arrowBackPt = ternary { IF = self.y2 > self.y1, THEN = -24, ELSE = 24 }
                
                self:setArrowColor()
                self.graphics:setLineWidth(4)
                self.graphics:line(self.x2, self.y2, self.x2 - 16, self.y2 + arrowBackPt)
                self.graphics:line(self.x2, self.y2, self.x2 + 16, self.y2 + arrowBackPt)
            end,
        
            drawLabel = function(self)
                if self.y1 == self.y2 then self:drawHorizontalLabel()
                else                       self:drawVerticalLabel()   end
            end,

            drawHorizontalLabel = function(self)
                self:setLabelFont()
                self:setFontColor()
                self.graphics:printf(self.label, math.min(self.x1,  self.x2), self.y1 - self.graphics:getFontHeight(), 
                                                 math.abs(self.x2 - self.x1), "center")
            end,

            drawVerticalLabel = function(self)
                self:setLabelFont()
                self:setFontColor()
                local width = self.graphics:getFontWidth(self.label)
                local xOffset

                if self.y1 < self.y2 then xOffset = -width - 15
                else                      xOffset =          15  end

                self.graphics:printf(self.label,  self.x1 + xOffset, math.min(self.y1, self.y2) + (math.abs(self.y1 - self.y2) - self.graphics:getFontHeight()) / 2, 
                                     width * 1.1, "center")
            end,

            setLabelFont = function(self)
                if     self.selected    then self.graphics:setFontSize(self.LABEL_FONT_SIZE + 4)
                elseif self.highlighted then self.graphics:setFontSize(self.LABEL_FONT_SIZE + 4)
                else                         self.graphics:setFontSize(self.LABEL_FONT_SIZE)   end
            end,

            setFontColor = function(self)
                if     self.selected    then self.graphics:setColor(COLORS.RED)
                elseif self.highlighted then self.graphics:setColor(COLORS.MEDIUM_YELLOW)
                else                         self.graphics:setColor(COLORS.PURE_WHITE) end
            end,

            select     = function(self) self.selected = true  end,
            deselect   = function(self) self.selected = false end,
            isSelected = function(self) return self.selected  end,
                
        }):init()
    end,
            
    isMouseInsideRect = function(self, x, y, w, h)
        local mx, my = love.mouse.getPosition()
        return self:isPtInRect(mx, my, x, y, w, h)
    end,

    isPtInRect = function(self, sx, sy, x, y, w, h)
        local px, py = self.graphics:screenToImageCoordinates(sx, sy)
        return px >= x and px <= x + w and py >= y and py <= y + h
    end,
}
