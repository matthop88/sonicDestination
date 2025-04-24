local doScribbleJotDrawing = function(self)
    local prevX, prevY = nil, nil
    
    for n, pt in ipairs(self.data) do
        if n == 1 then love.graphics.rectangle("fill", pt.x - 2, pt.y - 2, 5, 5)
        else           love.graphics.line(prevX, prevY, pt.x, pt.y)
        end
        
        prevX, prevY = pt.x, pt.y
    end
end

local drawScribbleJot = function(self)
    love.graphics.setColor(self.data.color)
    love.graphics.setLineWidth(5)
    
    doScribbleJotDrawing(self)
end

local addStrokeToJot = function(self, x, y)
    table.insert(self.data, { x = x, y = y })
end

local scribbleJotToString = function(self)
    return "\n-- SERIALIZED SCRIBBLE"
end

local newScribbleJot = function()
    return {
        data     = { color = { 1, 1, 1, 0.5 } },
        draw     = drawScribbleJot,
        add      = addStrokeToJot,
        toString = scribbleJotToString,
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
        self:drawCursor(mx, my)
    end,

    drawCursor = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)
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
        self.jot:add(mx, my)
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        self.jot:add(mx, my)
    end,

}
