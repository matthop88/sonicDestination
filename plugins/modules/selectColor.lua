
return {
    --[[
        Depends upon these initialization parameters:
        -------------------------------------------------------
        imageViewer    -> Image Viewer object, with methods
                          screenToImageCoordinates(), getImagePixelAt()
        readout        -> Readout object with printMessage() function
                          (This is poorly coupled!!!)
        -------------------------------------------------------
    --]]
    
    selectedColor = nil,

    init = function(self, params)
        self.imageViewer = params.imageViewer
        self.readout     = params.readout
        return self
    end,
    
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
        local imageX, imageY = self.imageViewer:screenToImageCoordinates(mx, my)
        local r, g, b        = self.imageViewer:getImagePixelAt(imageX, imageY)
    
        return { r, g, b }
    end,

    print = function(self)
        local r, g, b = unpack(self.selectedColor)
        print(string.format("{ r = %.2f, g = %.2f, b = %.2f }", r, g, b))
        self.readout:printMessage(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
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

    handleMousereleased = function(self, mx, my)
        self:clear()
    end,
}
