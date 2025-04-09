return {
    rect = nil,
    
    initFromRect = function(self, rect)
        if rect == nil then self.rect = nil
        else                self.rect = { x = rect.x, y = rect.y, w = rect.w, h = rect.h }
        end
    end,
    
    draw = function(self)
        if self.rect ~= nil then
            if love.mouse.isDown(1) then self:drawFilled()
            else                         self:drawOutline()
            end
        end
    end,

    drawFilled = function(self)
        love.graphics.setColor(1, 1, 0.8, 0.5)
        love.graphics.rectangle("fill", self:toScreenRect())
    end,

    drawOutline = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(3 * getImageViewer():getScale())
        -- XXX do we want to access imageViewer this way?
        love.graphics.rectangle("line", self:toScreenRect())
    end,

    toScreenRect = function(self)
        return getImageViewer():imageToScreenRect(self.rect.x - 2, self.rect.y - 2, self.rect.w + 4, self.rect.h + 4)
    end,

    containsPt = function(self, x, y)
        return self.rect ~= nil
           and x >= self.rect.x and x <= self.rect.x + self.rect.w - 1
           and y >= self.rect.y and y <= self.rect.y + self.rect.h - 1

        -- XXX How is this function called?
    end,

}
