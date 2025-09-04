local LabelFont = love.graphics.newFont(36)

return {
    create = function(self, x, y, w, h, textLabel, updateModelFn)
        local textValue = nil
        
        return {
            draw = function(self)
                self:drawField()
                self:drawText()
            end,
            
            drawField = function(self)
                self:drawFieldBody()
                self:drawFieldOutline()
            end,

            drawFieldBody = function(self)
                love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
                love.graphics.rectangle("fill", x, y, w, h)
            end,

            drawFieldOutline = function(self)
                if self:isInsideRect(love.mouse.getPosition()) then love.graphics.setColor(1, 1, 0)
                else                                                love.graphics.setColor(0.5, 0.5, 0.5) end
                
                love.graphics.rectangle("line", x, y, w, h)
            end,

            drawText = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.setFont(LabelFont)
                love.graphics.printf((textLabel or "{UNLABELED}"), x + 20, y, w - 30, "left")
                love.graphics.printf((textValue or "{N/A}"),       x + 20, y, w - 30, "right")
            end,

            handleKeypressed = function(self, key)
                if self:isInsideRect(love.mouse.getPosition()) then
                    if     key == "up"   then 
                        self:incValue()
                        return true
                    elseif key == "down" then 
                        self:decValue()
                        return true
                    end
                end
            end,

            getValue = function(self)
                return textValue
            end,

            setValue = function(self, value)
                textValue = value
            end,

            incValue = function(self)
                if textValue ~= nil then textValue = textValue + 1 end
                updateModelFn(textValue)
            end,

            decValue = function(self)
                if textValue ~= nil then textValue = textValue - 1 end
                updateModelFn(textValue)
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,
        }
    end,
}
