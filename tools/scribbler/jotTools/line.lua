 return { 

    init = function(self, picture)
        self.picture = picture
        return self
    end,
    
    data = { },
    
    draw = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(5)
        
        local prevX, prevY = mx, my
        
        for n, pt in ipairs(self.data) do
            if n == 1 then
                love.graphics.rectangle("fill", pt.x - 2, pt.y - 2, 5, 5)
            else
                love.graphics.line(prevX, prevY, pt.x, pt.y)
            end
            prevX, prevY = pt.x, pt.y
        end

        love.graphics.line(prevX, prevY, mx, my)
        
        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,

    penUp = function(self, mx, my)
        -- Do nothing
    end,

    penDown = function(self, mx, my)
        table.insert(self.data, { x = mx, y = my })
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        -- Do nothing
    end,

}
