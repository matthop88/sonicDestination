return {
    x = 0, y = 0, scale = 1,

    ---------------------- Property Setter Functions -------------------
    
    setColor = function(self, color)
        love.graphics.setColor(color)
    end,

    setFont  = function(self, font)
        love.graphics.setFont(font)
    end,

    setLineWidth = function(self, lineWidth)
        love.graphics.setLineWidth(lineWidth)
    end,
    
    ----------------------- Shape Drawing Functions --------------------
    
    rectangle = function(self, mode, x, y, w, h)
        love.graphics.rectangle(mode, x + self.x, y + self.y, w, h)
    end,

    line      = function(self, x1, y1, x2, y2)
        love.graphics.line(x1 + self.x, y1 + self.y, x2 + self.x, y2 + self.y)
    end,

    ------------------------ Text Drawing Functions --------------------

    printf    = function(self, text, x, y, w, align)
        love.graphics.printf(text, x + self.x, y + self.y, w, align)
    end,

    ------------------------- Scrolling Functions ----------------------
    
    setX = function(self, x)
        self.x = x
    end,
    
    setY = function(self, y)
        self.y = y
    end,

    moveImage = function(self, deltaX, deltaY)
        self.x = self.x + deltaX
        self.y = self.y + deltaY
    end,

    ----------------------- Zooming Functions ----------------------

    screenToImageCoordinates = function(self, mx, my)
        local x = mx / self.scale - self.x
        local y = my / self.scale - self.y

        return x, y
    end,
    
    adjustScaleGeometrically = function(self, delta)
        self.scale = self.scale + (delta * self.scale)
    end,
    
    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.x = screenX / self.scale - imageX
        self.y = screenY / self.scale - imageY
    end,
}
