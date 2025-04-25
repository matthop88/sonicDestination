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
    if #self.data > 0 then
        local prevJotStroke = self.data[#self.data]
        local prevX, prevY = prevJotStroke.x, prevJotStroke.y
        if     x == prevX then
            prevJotStroke.y = y
        elseif y == prevY then
            prevJotStroke.x = x
        else
            table.insert(self.data, { x = x, y = y })
        end
    else
        table.insert(self.data, { x = x, y = y })
    end
end

local scribbleJotToString = function(self)
    local scribbleString = "  {\n"
        .. "    name  = \"scribble\",\n"
        .. "    color = { " .. self.data.color[1] .. ", " .. self.data.color[2] .. ", " .. self.data.color[3] .. " },\n"
        .. "    data  = {\n"

    for _, pt in ipairs(self.data) do
        scribbleString = scribbleString .. "      { x = " .. pt.x .. ", y = " .. pt.y .. " },\n"
    end
    return scribbleString .. "    },\n" .. "  },\n"
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
        if #self.jot.data > 0 then
            local prevJotStroke = self.jot.data[#self.jot.data]
            local prevX, prevY = prevJotStroke.x, prevJotStroke.y
            if mx == prevX then
                prevJotStroke.y = my
            elseif my == prevY then
                prevJotStroke.x = mx
            else
                self.jot:add(mx, my)
            end
        else
            self.jot:add(mx, my)
        end
    end,

}
