return {
    rect = nil,
    
    initFrom = function(self, rect)        self.rect  = rect end,
    isActive = function(self)       return self.rect ~= nil  end,
    
    getX     = function(self)       return self.rect.x       end,
    getY     = function(self)       return self.rect.y       end,
    getW     = function(self)       return self.rect.w       end,
    getH     = function(self)       return self.rect.h       end,

    calculateUsing = function(self, imageX, imageY, rectCalculator)
        if not self:containsPt(imageX, imageY) then
            self:initFrom(rectCalculator(imageX, imageY))
        end
    end,
    
    containsPt = function(self, x, y)
        return  self:isActive()
            and x >= self:getX()
            and x <= self:getX() + self:getW() - 1
            and y >= self:getY()
            and y <= self:getY() + self:getH() - 1
    end,

    draw = function(self)
        if self:isActive() then
            if love.mouse.isDown(1) then self:drawFilled()
            else                         self:drawOutline()
            end
        end
    end,

    drawFilled = function(self)
        love.graphics.setColor(1, 1, 0.8, 0.5)
        love.graphics.rectangle("fill", self:toScreenRect())
    end,

    toScreenRect = function(self)
        return getImageViewer():imageToScreenRect(self:getX() - 2, self:getY() - 2, self:getW() + 4, self:getH() + 4)
    end,

    printUsing = function(self, printFn)
        if self:isActive() then
            printFn("{ x = " .. self:getX() .. ", y = " .. self:getY() .. ", w = " .. self:getW() .. ", h = " .. self:getH() .. " }")
        end
    end,

    drawOutline = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(3 * getImageViewer():getScale())
        love.graphics.rectangle("line", self:toScreenRect())
    end,
}
