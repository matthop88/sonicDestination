return {
    x = 0,
    y = 0,

    ---------------------- Property Setter Functions -------------------
    
    setColor = function(self, color)
        love.graphics.setColor(color)
    end,

    ----------------------- Shape Drawing Functions --------------------
    
    rectangle = function(self, mode, x, y, w, h)
        love.graphics.rectangle(mode, x + self.x, y + self.y, w, h)
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
}
