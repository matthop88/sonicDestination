if __DEV_MODE then
    return require("tools/lib/graphics")
else
    return {
        setColor	= function(self, color)
            love.graphics.setColor(color)
        end,
        
        setLineWidth = function(self, lineWidth)
            love.graphics.setLineWidth(lineWidth)
        end,
        
        rectangle = function(self, mode, x, y, w, h)
            love.graphics.rectangle(mode, x, y, w, h)
        end,
        
        line = function(self, x1, y1, x2, y2)
            love.graphics.line(x1, y1, x2, y2)
        end,
        
        draw = function(self, image, quad, x, y, r, sx, sy)
            love.graphics.draw(image, quad, x, y, r, sx, sy)
        end,

        screenToImageCoordinates = function(self, x, y)
            return x, y
        end,

        getScreenWidth  = function(self) return love.graphics.getWidth()  end,
        getScreenHeight = function(self) return love.graphics.getHeight() end,

        calculateViewportRect = function(self)
            return { x = 0, y = 0, w = self:getScreenWidth(), h = self:getScreenHeight() }
        end,
    }
end
