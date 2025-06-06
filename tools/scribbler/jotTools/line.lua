local mutableColor = require("tools/scribbler/utils/mutable/mutableColor")

local doLineJotDrawing = function(self, mx, my)
    local prevX, prevY = mx, my

    for n, pt in ipairs(self.data) do
        if n == 1 then love.graphics.rectangle("fill", pt.x - 2, pt.y - 2, 5, 5)
        else           love.graphics.line(prevX, prevY, pt.x, pt.y)
        end
        prevX, prevY = pt.x, pt.y
    end
end

local drawLineJot = function(self, mx, my)
    love.graphics.setColor(self.data.color or { 1, 1, 1 } )
    love.graphics.setLineWidth(5)

    doLineJotDrawing(self, mx, my)
end

local lineJotToString = function(self)
    local color = self.data.color or { 1, 1, 1 }
    local lineString = "  {\n"
        .. "    name = \"line\",\n"
        .. "    color = { " .. color[1] .. ", " .. color[2] .. ", " .. color[3] .. " },\n"
        .. "    data = {\n"

    for _, pt in ipairs(self.data) do
        lineString = lineString .. "      { x = " .. pt.x .. ", y = " .. pt.y .. " },\n"
    end
    return lineString .. "    },\n" .. "  },\n"
end

local newLineJot = function(data)
    return {
        data     = data or { color = mutableColor:get() },
        draw     = drawLineJot,
        toString = lineJotToString,
    }
end

return { 

    init = function(self, picture)
        self.picture = picture
        return self
    end,

    jot = newLineJot(),

    draw = function(self, mx, my)
        self.jot:draw(mx, my)
        self:drawWorkingLine(mx, my)
        self:drawCursor(mx, my) 
    end,

    drawWorkingLine = function(self, mx, my)
        if #self.jot.data > 0 then 
            love.graphics.setColor(mutableColor:getTransparent())
            local prevX = self.jot.data[#self.jot.data].x
            local prevY = self.jot.data[#self.jot.data].y
            love.graphics.line(prevX, prevY, mx, my)
        end
    end,

    drawCursor = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1)
        love.mouse.setVisible(false)
        love.graphics.line(mx - 16, my, mx + 16, my)
        love.graphics.line(mx, my - 16, mx, my + 16)
        love.graphics.setColor(mutableColor:get())
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
            self:finishPolygon() 
        elseif key == "tab" then
            mutableColor:next()
            self.jot.data.color = mutableColor:get()
        end
    end,

    finishPolygon = function(self)
        self.picture:addJot(self.jot)
        self.jot = newLineJot()
    end,

    createJotFromData = function(self, data)
        return newLineJot(data)
    end,
}
