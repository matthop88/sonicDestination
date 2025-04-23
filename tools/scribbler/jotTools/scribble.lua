local drawScribbleJot = function(self)
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

local addStrokeToJot = function(self, x, y)
    table.insert(self.jot.data, { x = x, y = y })
end

local newScribbleJot = function()
    return {
        data = { color = { 1, 1, 1, 0.5 } },
        draw = drawScribbleJot,
    }
end

return { 
    jot = newScribbleJot(),
    
    init = function(self, picture)
        self.picture = picture
        return self
    end,
        
    draw = function(self, mx, my)
        self.jot:draw()

        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,
    
    penUp = function(self, mx, my)
        if self.picture then 
            self.jot.data.color = { 1, 1, 1 }
            self.picture:addJot(self.jot) 
        end
        self.jot = newScribbleJot()
    end,

    penDown = function(self, mx, my)
        self.jot = newScribbleJot()
        addStrokeToJot(mx, my)
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        addStrokeToJot(mx, my)
    end,

}
