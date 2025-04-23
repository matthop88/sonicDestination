return { 
    init = function(self, picture)
        self.picture = picture
        return self
    end,
  
    data = { },

    draw = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(5)
        
        if self.data.x ~= nil and self.data.y ~= nil then
            if self.data.w ~= nil and self.data.h ~= nil then
                love.graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
            else
                love.graphics.rectangle("line", self.data.x, self.data.y, mx - self.data.x, my - self.data.y)
            end
        end

        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,

    penUp = function(self, mx, my)
        self.data.w = mx - self.data.x
        self.data.h = my - self.data.y
    end,

    penDown = function(self, mx, my)
        self.data = { x = mx, y = my }
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        -- Do nothing
    end,

}
