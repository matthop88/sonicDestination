local mutableColor = require("tools/scribbler/mutableColor")
local textFonr     = love.graphics.newFont(32)

local drawTextJot = function(self)
    love.graphics.setColor(self.data.color or { 1, 1, 1 })
    love.graphics.setFont(self.data.font or textFont)
            
    love.graphics.printf(self.data.message, self.data.x, self.data.y, 1000, "left")
end
    
local textJotToString = function(self)
    local color = self.data.color or { 1, 1, 1 }
    local textString = "  {\n"
        .. "    name = \"text\",\n"
        .. "    color = { " .. color[1] .. ", " .. color[2] .. ", " .. color[3] .. " },\n"
        .. "    data = { x = " .. self.data.x .. ", y = " .. self.data.y .. ", " 
         .. "message = \"" .. self.data.message .. "\", },\n"
                
    return textString .. "  },\n"
end

local newTextJot = function(data)
    return {
        data     = data,
        draw     = drawTextJot,
        toString = textJotToString,
    }
end

return { 
    init = function(self, picture)
        self.picture = picture
        self.jot     = newTextJot()
        return self
    end,

    x       = nil,
    y       = nil,
    message = "Standing Left",

    draw = function(self, mx, my)
        if self.jot.data ~= nil then self.jot:draw() end
        self:drawCursor(mx, my)
    end,

    penUp = function(self, mx, my)
        self.jot.data = {
            color = mutableColor:get(),
            font = textFont,
            message = self.message,
            x = self.x,
            y = self.y,
        }

        self.picture:addJot(self.jot)
        self.jot = newTextJot()
        self.x, self.y = nil, nil
    end,

    penDown = function(self, mx, my)
        self.x, self.y = mx, my
    end,

    penMoved = function(self, mx, my)
        -- Do nothing
    end,

    penDragged = function(self, mx, my)
        -- Do nothing
    end,

    keypressed = function(self, key)
        if key == "tab" then mutableColor:next() end
    end,

    createJotFromData = function(self, data)
        return newTextJot(data)
    end,

    drawCursor = function(self, mx, my)
        love.mouse.setVisible(false)
        love.graphics.setColor(mutableColor:getTransparent())
        love.graphics.setFont(textFont)
        love.graphics.printf(self.message, mx, my, 1000, "left")
    end,

}
