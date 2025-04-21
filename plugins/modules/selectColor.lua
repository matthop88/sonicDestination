
return {
    selectedColor   = nil,
    onColorSelected = function(selectedColor) end,
    
    init = function(self, params)
        self.imageViewer = params.imageViewer
        self.onColorSelected = params.onColorSelected or self.onColorSelected
        
        return self
    end,
    
    selectFromImageAt = function(self, mx, my)
        self:set(self:identifyImageColor(mx, my))
    end,

    set = function(self, color)
        self.selectedColor = color
        self.onColorSelected(color)
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
    
        return { r, g, b, r = r, g = g, b = b }
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

    handleMousepressed  = function(self, mx, my)
        self:selectFromImageAt(mx, my)
        return true
    end,
    
    handleMousereleased = function(self, mx, my)
        self:clear()
    end,
}
