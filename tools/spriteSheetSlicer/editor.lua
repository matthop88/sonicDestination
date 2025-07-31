local LabelFont = love.graphics.newFont(36)

local TextField = {
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

return {
    create = function(self)
        local x, y, w, h = 228, 50, 568, 568
        
        local isActive = false

        local scale      = 10
        local image      = nil
        local spriteRect = nil

        local offsetXField = TextField:create(x + 83, y + 449, 402, 42, "Offset X:", function(value) spriteRect.offset.x = value end)
        local offsetYField = TextField:create(x + 83, y + 504, 402, 42, "Offset Y:", function(value) spriteRect.offset.y = value end)
        
        return {
            draw = function(self)
                if isActive then
                    self:drawOuterPane()
                    self:drawInnerPane()
                    self:drawTextFields()
                    self:drawSprite()
                end
            end,

            drawOuterPane = function(self)
                self:drawOuterPaneBody()
                self:drawOuterPaneOutline()
            end,

            drawOuterPaneBody = function(self)
                love.graphics.setColor(0.3, 0.3, 0.3, 0.7)
                love.graphics.rectangle("fill", x, y, w, h)
            end,

            drawOuterPaneOutline = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line", x, y, w, h)
            end,

            drawInnerPane = function(self)
                self:drawInnerPaneBody()
                self:drawInnerPaneOutline()
            end,

            drawInnerPaneBody = function(self)
                love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
                love.graphics.rectangle("fill", x + 84, y + 34, 400, 400)
            end,

            drawInnerPaneOutline = function(self)
                if self:isInsideInnerRect(love.mouse.getPosition()) then
                    love.graphics.setColor(1, 1, 0)
                else
                    love.graphics.setColor(0.5, 0.5, 0.5)
                end
                
                love.graphics.rectangle("line", x + 83, y + 33, 402, 402)
            end,

            drawTextFields = function(self)
                offsetXField:draw()
                offsetYField:draw()
            end,
            
            mousepressed = function(self, mx, my)
                return isActive and self:isInsideRect(mx, my)
            end,

            keypressed = function(self, key)
                local mx, my = love.mouse.getPosition()
                if isActive then
                    if   offsetXField:handleKeypressed(key)
                      or offsetYField:handleKeypressed(key)
                      or self:isInsideInnerRect(mx, my)     
                    then
                        return true
                    end
                end
            end,
            
            setActive = function(self, active) 
                isActive = active 
            end,

            setSprite = function(self, img, sprRect)
                image      = img
                spriteRect = sprRect
                offsetXField:setValue(spriteRect.offset.x)
                offsetYField:setValue(spriteRect.offset.y)
            end,

            drawSprite = function(self)
                if image ~= nil then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(image, spriteRect.quad, x + 284 - (spriteRect.offset.x * scale),
                                                               y + 234 - (spriteRect.offset.y * scale), 0, scale, scale)
                end
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,

            isInsideInnerRect = function(self, px, py)
                return px >= x + 83 and px <= x + 83 + 402 and py >= y + 33 and py <= y + 33 + 402
            end,
        }
    end,
}
