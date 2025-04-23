local drawRectJot = function(self)
    if self.data ~= nil then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(5)
        
        love.graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
    end
end

local newRectJot = function()
    return {
        data = nil,
        draw = drawRectJot,
    }
end
    
return { 
    init = function(self, picture)
        self.picture = picture
        return self
    end,

    originX = nil, 
    originY = nil,

    jot = newRectJot(),

    draw = function(self, mx, my)
        self.jot:draw()
        self:drawWorkingRectangle(mx, my)
        
        love.mouse.setVisible(false)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,

    drawWorkingRectangle(self, mx, my)
        if self.originX ~= nil and self.originY ~= nil then
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.setLineWidth(5)

            love.graphics.rectangle("line", self.originX, self.originY, mx - self.originX, my - self.originY)
        end
    end,

    penUp = function(self, mx, my)
        self:finishRectangle()
        self.picture:addJot(self.jot)
        self.jot = newRectJot()
        self.originX, self.originY = nil, nil
    end,

    penDown = function(self, mx, my)
        self.originX, self.originY = mx, my
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        -- Do nothing
    end,

    finishRectangle = function(self, mx, my)
        self.jot.data = {
            x = self.originX,
            y = self.originY,
            w = mx - self.originX,
            h = my - self.originY,
        }
    end,

}
