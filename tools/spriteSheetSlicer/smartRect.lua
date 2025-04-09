local rectToString = function(self)
    return "{ x = " .. self.x .. ", y = " .. self.y .. ", w = " .. self.w .. ", h = " .. self.h .. " }"
end

return {
    rect   = nil,
    filled = false,
    
    initFromRect = function(self, rect)
        self.filled = false
        
        if rect == nil then self.rect = nil
        else                self.rect = { x = rect.x, y = rect.y, w = rect.w, h = rect.h, toString = rectToString }
        end
    end,

    toString = function(self)
        if self:isValid() then return self.rect:toString()
        else                   return nil
        end
    end,
    
    draw = function(self)
        if self:isValid() then
            if self.filled then self:drawFilled()
            else                self:drawOutline()
            end
        end
    end,

    isValid = function(self)
        return self.rect ~= nil
    end,

    drawFilled = function(self)
        love.graphics.setColor(1, 1, 0.8, 0.5)
        love.graphics.rectangle("fill", self:toScreenRect())
    end,

    drawOutline = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(3 * getImageViewer():getScale())
        love.graphics.rectangle("line", self:toScreenRect())
    end,

    toScreenRect = function(self)
        return getImageViewer():imageToScreenRect(self.rect.x - 2, self.rect.y - 2, self.rect.w + 4, self.rect.h + 4)
    end,

    containsPt = function(self, x, y)
        return self:isValid()
           and x >= self.rect.x and x <= self.rect.x + self.rect.w - 1
           and y >= self.rect.y and y <= self.rect.y + self.rect.h - 1
    end,

}
