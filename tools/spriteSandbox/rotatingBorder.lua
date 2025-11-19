return {
    create = function(self, x, y, w, h)
        local ROTATION = 0
        
        return {
            draw = function(self, GRAFX)
                local px, py = GRAFX:imageToScreenCoordinates(x, y)
                love.graphics.push()
                love.graphics.translate(px, py)
                love.graphics.rotate(ROTATION)
                love.graphics.translate(-px, -py)
                GRAFX:setColor(1, 1, 1)
                GRAFX:setLineWidth(1)
                GRAFX:rectangle("line", x - (w / 2) - 2, y - (h / 2) - 2, w + 4, h + 4)
                love.graphics.pop()
            end,

            update = function(self, dt)
                ROTATION = ROTATION + (math.pi / 90)
            end,
        }
    end,
}
 
