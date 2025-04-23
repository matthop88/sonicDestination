local drawLineJot = function(self, mx, my)
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
end

return { 

    init = function(self, picture)
        self.picture = picture
        return self
    end,

    jot = {
        data = { },
        draw = drawLineJot,
    },

    draw = function(self, mx, my)
        self.jot:draw(mx, my)
        self:drawWorkingLine(mx, my)
        self:drawCursor(mx, my) 
    end,

    drawWorkingLine = function(self, mx, my)
        if #self.jot.data > 0 then 
            love.graphics.setColor(1, 1, 1, 0.5)
            local prevX = self.jot.data[#self.jot.data].x
            local prevY = self.jot.data[#self.jot.data].y
            love.graphics.line(prevX, prevY, mx, my)
        end
    end,

    drawCursor = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)
        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,

    penUp = function(self, mx, my)
        -- Do nothing
    end,

    penDown = function(self, mx, my)
        table.insert(self.jot.data, { x = mx, y = my })
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        -- Do nothing
    end,

    keypressed = function(self, key)
        if key == "return" then
            self.picture:addJot(self.jot)

            self.jot = {
                data  = { },
                draw  = drawLineJot,
            }
        end
    end,

}
