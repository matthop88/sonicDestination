if __DEV_MODE then
    return require("tools/lib/graphics"):create()
else
    return {
        x = 0,
        y = 0,

        setColor     = function(self, arg1, arg2, arg3, arg4)
            love.graphics.setColor(arg1, arg2, arg3, arg4)
        end,
        
        setLineWidth = function(self, lineWidth)
            love.graphics.setLineWidth(lineWidth)
        end,
        
        rectangle = function(self, mode, x, y, w, h)
            love.graphics.rectangle(mode, x, y + self.y, w, h)
        end,
        
        line = function(self, x1, y1, x2, y2)
            love.graphics.line(x1, y1 + self.y, x2, y2 + self.y)
        end,
        
        draw = function(self, image, quad, x, y, r, sx, sy)
            love.graphics.draw(image, quad, x, y + self.y, r, sx, sy)
        end,

        screenToImageCoordinates = function(self, x, y)
            return x, y - self.y
        end,

        getScreenWidth  = function(self) return love.graphics.getWidth()  end,
        getScreenHeight = function(self) return love.graphics.getHeight() end,

        calculateViewportRect = function(self)
            return { x = 0, y = -self.y, w = self:getScreenWidth(), h = self:getScreenHeight() }
        end,

        getX = function(self) return self.x end,
        getY = function(self) return self.y end,
            
        setX = function(self, x) self.x = x end,
        setY = function(self, y) self.y = y end,
        
    }
end
