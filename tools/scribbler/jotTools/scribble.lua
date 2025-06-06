local mutableColor = require("tools/scribbler/utils/mutable/color")

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

local areStrokeSlopesEqual = function(prevJotStroke1, prevJotStroke2, x, y)
    local prevX1, prevY1 = prevJotStroke1.x, prevJotStroke1.y
    local prevX2, prevY2 = prevJotStroke2.x, prevJotStroke2.y
    local slope1, slope2
    if x - prevX1 ~= 0 or prevX1 - prevX2 ~= 0 then
        slope1 = (y      - prevY1) / (x      - prevX1)
        slope2 = (prevY1 - prevY2) / (prevX1 - prevX2)
    end
    return slope1 == slope2
end

local addOptimizedStrokeToJot = function(self, x, y)
    local prevJotStroke1 = self.data[#self.data]
    local prevJotStroke2 = self.data[#self.data - 1]
    if areStrokeSlopesEqual(prevJotStroke1, prevJotStroke2, x, y) then
        prevJotStroke1.x, prevJotStroke1.y = x, y
    else
        table.insert(self.data, { x = x, y = y })
    end
end

local addStrokeToJot = function(self, x, y)
    if #self.data > 1 then addOptimizedStrokeToJot(self, x, y)
    else                   table.insert(self.data, { x = x, y = y })
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

local newScribbleJot = function(data)
    return {
        data     = data or { color = { 1, 1, 1, 0.5 } },
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
        love.graphics.setColor(mutableColor:get())
        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", mx - 3, my - 3, 7, 7)
    end,
    
    penUp = function(self, mx, my)
        if self.picture then 
            self.jot.data.color = mutableColor:get()
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

    createJotFromData = function(self, data)
        return newScribbleJot(data)
    end,

    keypressed = function(self, key)
        if key == "tab" then
            mutableColor:next()
        end
    end,

}
