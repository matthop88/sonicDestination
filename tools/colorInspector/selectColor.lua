require "tools/colorInspector/color"

return {
    selectedColor = nil,

    selectFromImageAt = function(self, mx, my)
        self.selectedColor = self:identifyImageColor(mx, my)
        self:print()
    end,

    set = function(self, color)
        self.selectedColor = color
        self:print()
    end,

    get = function(self)
        return self.selectedColor
    end,

    clear = function(self)
        self.selectedColor = nil
    end,

    identifyImageColor = function(self, mx, my)
        local imageX, imageY = getIMAGE_VIEWER():screenToImageCoordinates(mx, my)
        local r, g, b        = getIMAGE_VIEWER():getImagePixelAt(imageX, imageY)
    
        return { r, g, b }
    end,

    print = function(self)
        local r, g, b = unpack(self.selectedColor)
        print(string.format("{ %.2f, %.2f, %.2f }", r, g, b))
        printToREADOUT(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
    end,

    draw = function(self)
        if self.selectedColor ~= nil then
            local mx, my = love.mouse.getPosition()
            self:drawCursorBody(mx, my)
            self:drawCursorOutline(mx, my)
        end
    end,

    drawCursorBody = function(self, mx, my)
        love.graphics.setColor(self.selectedColor)
        love.graphics.rectangle("fill", mx - 50, my - 50, 100, 100)
    end,

    drawCursorOutline = function(self, mx, my)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(COLOR.JET_BLACK)
        love.graphics.rectangle("line", mx - 50, my - 50, 100, 100)
    end,

    handleMousepressed = function(self, mx, my)
        self:selectFromImageAt(mx, my)
    end,
}
