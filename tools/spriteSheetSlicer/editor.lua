local LabelFont = love.graphics.newFont(36)

local TextField = {
    create = function(self, x, y, w, h, textLabel, updateModelFn)
        local textValue = nil
        
        return {
            draw = function(self)
                love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
                love.graphics.rectangle("fill", x, y, w, h)
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.rectangle("line", x, y, w, h)

                love.graphics.setColor(1, 1, 1)
                love.graphics.setFont(LabelFont)
                love.graphics.printf((textLabel or "{UNLABELED}"), x + 20, y, w - 30, "left")
                love.graphics.printf((textValue or "{N/A}"),       x + 20, y, w - 30, "right")
            end,

            handleKeypressed = function(self, key)
                if self:isInsideRect(love.mouse.getPosition()) then
                    if key == "up" then self:incValue()
                    elseif key == "down" then self:decValue() end
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

return {
    create = function(self)
        local x, y, w, h = 228, 50, 568, 568
        
        local isActive = false

        local scale      = 10
        local image      = nil
        local spriteRect = nil

        local offsetXField = TextField:create(x + 83, y + 449, 402, 42, "Offset X:", function(value) spriteRect.offsetX = value end)
        local offsetYField = TextField:create(x + 83, y + 504, 402, 42, "Offset Y:", function(value) spriteRect.offsetY = value end)
        
        return {
            draw = function(self)
                if isActive then
                    love.graphics.setColor(0.3, 0.3, 0.3, 0.7)
                    love.graphics.rectangle("fill", x,      y,        w,   h)
                    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
                    love.graphics.rectangle("fill", x + 84, y + 34, 400, 400)
                    love.graphics.setColor(0.5, 0.5, 0.5)
                    love.graphics.rectangle("line", x + 83, y + 33, 402, 402)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.rectangle("line", x,      y,        w,   h)

                    offsetXField:draw()
                    offsetYField:draw()
                    
                    self:drawSprite()
                end
            end,

            mousepressed = function(self, mx, my)
                return isActive and self:isInsideRect(mx, my)
            end,

            keypressed = function(self, key)
                local mx, my = love.mouse.getPosition()
                if isActive and self:isInsideRect(mx, my) then
                    offsetXField:handleKeypressed(key)
                    offsetYField:handleKeypressed(key)
                    return true
                end
            end,
            
            setActive = function(self, active) 
                isActive = active 
            end,

            setSprite = function(self, img, sprRect)
                image      = img
                spriteRect = sprRect
                offsetXField:setValue(spriteRect.offsetX)
                offsetYField:setValue(spriteRect.offsetY)
            end,

            drawSprite = function(self)
                if image ~= nil then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(image, spriteRect.quad, x + 284 - (spriteRect.offsetX * scale),
                                                               y + 234 - (spriteRect.offsetY * scale), 0, scale, scale)
                end
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,
        }
    end,
}
