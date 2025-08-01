local mutableColor = require("tools/scribbler/utils/mutable/color")

local drawRectJot = function(self)
    if self.data ~= nil then
        love.graphics.setColor(self.data.color or { 1, 1, 1} )
        love.graphics.setLineWidth(5)
        if self.data.filled then
            love.graphics.rectangle("fill", self.data.x, self.data.y, self.data.w, self.data.h)
        else
            love.graphics.rectangle("line", self.data.x, self.data.y, self.data.w, self.data.h)
        end
    end
end

rectJotToString = function(self)
    local color = self.data.color or { 1, 1, 1 }
    local filled = "false"
    if self.data.filled then filled = "true" end
    local rectString = "  {\n"
        .. "    name = \"rect\",\n"
        .. "    color = { " .. color[1] .. ", " .. color[2] .. ", " .. color[3] .. " },\n"
        .. "    data = { x = " .. self.data.x .. ", y = " .. self.data.y 
        .. ", w = " .. self.data.w .. ", h = " .. self.data.h .. ", filled = " .. filled .. " },\n"

    return rectString .. "  },\n"
end

local newRectJot = function(data)
    return {
        data     = data,
        draw     = drawRectJot,
        toString = rectJotToString,
    }
end
    
return { 
    init = function(self, picture)
        self.picture = picture
        return self
    end,

    X = nil, Y = nil,

    filled = false,

    jot = newRectJot(),

    draw = function(self, mx, my)
        self.jot:draw()
        self:drawWorkingRectangle(mx, my)
    end,

    drawWorkingRectangle = function(self, mx, my)
        if self.X ~= nil and self.Y ~= nil then
            love.graphics.setColor(mutableColor:getWithAlpha(0.5))
            love.graphics.setLineWidth(5)

            if self.filled then love.graphics.rectangle("fill", self.X, self.Y, mx - self.X, my - self.Y)
            else                love.graphics.rectangle("line", self.X, self.Y, mx - self.X, my - self.Y) end
        end
    end,

    drawCursor = function(self, mx, my, alpha)
        love.graphics.setLineWidth(1)
        love.mouse.setVisible(false)
        self:drawCursorCircle(mx, my, alpha)
        self:drawCursorCrosshairs(mx, my, alpha)
    end,

    drawCursorCircle = function(self, mx, my, alpha)
        if self.filled then
            love.graphics.setColor(mutableColor:getWithAlpha(alpha / 2))
            love.graphics.circle("fill", mx, my, 15, 15)
        else
            love.graphics.setColor(mutableColor:getWithAlpha(alpha))
            love.graphics.circle("line", mx, my, 15, 15)
        end
    end,

    drawCursorCrosshairs = function(self, mx, my, alpha)
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.line(mx - 24, my,      mx -  8, my)
        love.graphics.line(mx +  8, my,      mx + 24, my)
        love.graphics.line(mx,      my - 24, mx,      my - 8)
        love.graphics.line(mx,      my +  8, mx,      my + 24)
        love.graphics.setColor(mutableColor:getWithAlpha(alpha))
        love.graphics.rectangle("fill", mx - 2.5, my - 2.5, 5, 5)
    end,

    penUp = function(self, mx, my)
        self:finishRectangle(mx, my)
        self.picture:addJot(self.jot)
        self.jot = newRectJot()
        self.X, self.Y = nil, nil
    end,

    penDown = function(self, mx, my)
        self.X, self.Y = mx, my
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        -- Do nothing
    end,

    finishRectangle = function(self, mx, my)
        self.jot.data = {
            x =      self.X,      y =      self.Y,
            w = mx - self.X,      h = my - self.Y,
            filled = self.filled, color = mutableColor:get(),
        }
        self.filled = false
    end,

    createJotFromData = function(self, data)
        return newRectJot(data)
    end,

    keypressed = function(self, key)
        if     key == "tab"   then mutableColor:next()
        elseif key == "space" then self:toggleFill()
        end
    end,

    toggleFill = function(self)
        self.filled = not self.filled
    end,

}
