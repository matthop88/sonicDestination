local scribbleJotDraw = function(self)
    love.graphics.setColor(self.data.color)
    love.graphics.setLineWidth(5)
    
    local prevX, prevY = nil, nil
    
    for n, pt in ipairs(self.data) do
        if n == 1 then
            love.graphics.rectangle("fill", pt.x - 2, pt.y - 2, 5, 5)
        else
            love.graphics.line(prevX, prevY, pt.x, pt.y)
        end
        prevX, prevY = pt.x, pt.y
    end
end

return { 

    init = function(self, picture)
        self.picture = picture
        return self
    end,
        
    jot = nil,

    draw = function(self, mx, my)
        if self.jot then self.jot:draw() end

        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,
    
    penUp = function(self, mx, my)
        if self.jot and self.picture then 
            self.jot.data.color = { 1, 1, 1 }
            self.picture:addJot(self.jot) 
        end
        self.jot = nil
    end,

    penDown = function(self, mx, my)
        self.jot = {
            data = { 
                color = { 1, 1, 1, 0.5 },
                { x = mx, y = my },
            },
                
            draw = scribbleJotDraw,
        }
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        table.insert(self.jot.data, { x = mx, y = my })
    end,

}
