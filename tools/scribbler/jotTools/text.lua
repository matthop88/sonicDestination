local mutableColor      = require("tools/scribbler/utils/mutable/color")
local mutableMessage    = require("tools/scribbler/utils/mutable/message")
local mutableFont       = require("tools/scribbler/utils/mutable/font")

local idle              = false

local DEFAULT_FONT_SIZE = 32
local defaultFont       = love.graphics.newFont(DEFAULT_FONT_SIZE)

local drawTextJot = function(self)
    love.graphics.setColor(self.data.color or { 1, 1, 1 })
    love.graphics.setFont(self.data.font or defaultFont)
            
    love.graphics.printf(self.data.message, self.data.x, self.data.y, 1000, "left")
end
    
local textJotToString = function(self)
    local color = self.data.color or { 1, 1, 1 }
    local textString = "  {\n"
        .. "    name = \"text\",\n"
        .. "    color = { " .. color[1] .. ", " .. color[2] .. ", " .. color[3] .. " },\n"
        .. "    data = { x = " .. self.data.x .. ", y = " .. self.data.y .. ", "
        .. "fontSize = " .. (self.data.fontSize or DEFAULT_FONT_SIZE) .. ", " 
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
    
    draw = function(self, mx, my)
        if self.jot.data ~= nil then self.jot:draw() end
        if not self.idle then
            self:drawCursor(mx, my)
        end
    end,

    penUp = function(self, mx, my)
        self.jot.data = {
            color = mutableColor:get(),
            fontSize = mutableFont:getFontSize(),
            font = mutableFont:get(),
            message = mutableMessage:get(),
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
        if data ~= nil then
            if data.fontSize then data.font = mutableFont:getFontForSize(data.fontSize)
            else                  data.font = defaultFont
            end  
        end
        
        return newTextJot(data)
    end,

    drawCursor = function(self, mx, my)
        love.mouse.setVisible(false)
        love.graphics.setColor(mutableColor:getTransparent())
        love.graphics.setFont(mutableFont:get())
        love.graphics.printf(mutableMessage:get(), mx, my, 1000, "left")
    end,

    keypressed = function(self, key)
        if     key == "tab"    then mutableColor:next()
        elseif key == "left"   then mutableMessage:prev()
        elseif key == "right"  then mutableMessage:next()
        elseif key == "up"     then mutableFont:next()
        elseif key == "down"   then mutableFont:prev()
        end
    end,

    setIdle = function(self, idle)
        self.idle = idle
    end,

}
