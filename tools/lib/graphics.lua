return {
    x = 0,
    y = 0,
    
    setColor = function(self, color)
        love.graphics.setColor(color)
    end,

    rectangle = function(self, mode, x, y, w, h)
        love.graphics.rectangle(mode, x + self.x, y + self.y, w, h)
    end,

    setX = function(self, x)
        self.x = x
    end,
    
    setY = function(self, y)
        self.y = y
    end,
}
