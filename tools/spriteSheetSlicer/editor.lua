local LabelFont = love.graphics.newFont(36)

local TextField = {
    create = function(self, x, y, w, h, textValue)
        return {
            draw = function(self)
                love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
                love.graphics.rectangle("fill", x, y, w, h)
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.rectangle("line", x, y, w, h)

                love.graphics.setColor(1, 1, 1)
                love.graphics.setFont(LabelFont)
                love.graphics.printf((textValue or "{UNLABELED}"), x + 20, y, w - 30, "left")
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

        local offsetXField = TextField:create(x + 83, y + 449, 402, 42, "Offset X:")
        local offsetYField = TextField:create(x + 83, y + 504, 402, 42, "Offset Y:")
        
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
                return isActive and self:isInsideRect(love.mouse.getPosition())
            end,
            
            setActive = function(self, active) 
                isActive = active 
            end,

            setSprite = function(self, img, sprRect)
                image      = img
                spriteRect = sprRect
            end,

            drawSprite = function(self)
                if image ~= nil then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(image, spriteRect.quad, x + 284 - ((spriteRect.w / 2) * scale),
                                                               y + 234 - ((spriteRect.h / 2) * scale), 0, scale, scale)
                end
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,
        }
    end,
}
