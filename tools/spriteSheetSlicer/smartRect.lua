local rectToString = function(self)
    return "{ x = " .. self.x .. ", y = " .. self.y .. ", w = " .. self.w .. ", h = " .. self.h .. " }"
end

return {
    create = function(self)
        return {
            rect     = nil,
            selected = false,
            visible  = true,
            
            initFromRect = function(self, rect)
                if not self.selected then
                    if rect == nil then self.rect = nil
                    else                self.rect = { x = rect.x, y = rect.y, w = rect.w, h = rect.h, toString = rectToString }
                    end
                end
                return self
            end,
        
            toString = function(self)
                if self:isValid() then return self.rect:toString()
                else                   return nil
                end
            end,
            
            draw = function(self)
                if self:isValid() and self:isVisible() then
                    if self.selected then self:drawSelected()
                    else                  self:drawUnselected()
                    end
                end
            end,
        
            isValid = function(self)
                return self.rect ~= nil
            end,
        
            isSelected = function(self)
                return self.selected
            end,
        
            select = function(self, value)
                self.selected = value
            end,
        
            drawSelected = function(self)
                love.graphics.setColor(1, 1, 0.8, 0.5)
                love.graphics.rectangle("fill", self:toScreenRect())
            end,
        
            drawUnselected = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(3 * getImageViewer():getScale())
                love.graphics.rectangle("line", self:toScreenRect())
            end,
        
            toScreenRect = function(self)
                return getImageViewer():pageToScreenRect(self.rect.x - 2, self.rect.y - 2, self.rect.w + 4, self.rect.h + 4)
            end,
        
            containsPt = function(self, x, y)
                return self:isValid()
                   and x >= self.rect.x and x <= self.rect.x + self.rect.w - 1
                   and y >= self.rect.y and y <= self.rect.y + self.rect.h - 1
            end,

            isVisible = function(self)
                return self.visible
            end,
            
            setVisible = function(self, visibility)
                self.visible = visibility
            end,
        }
    end,
}
