return {
    create = function(self, x, y, w, h)
        local ROTATION = 0
        
        return ({
            init = function(self, x, y, w, h)
                self.x, self.y, self.w, self.h = x, y, w, h
                return self
            end,

            draw = function(self, GRAFX)
                local px, py = GRAFX:imageToScreenCoordinates(self.x, self.y)
                love.graphics.push()
                love.graphics.translate(px, py)
                love.graphics.rotate(ROTATION)
                love.graphics.translate(-px, -py)
                GRAFX:setColor(1, 1, 1)
                GRAFX:setLineWidth(1)
                GRAFX:rectangle("line", self.x - (self.w / 2) - 2, self.y - (self.h / 2) - 2, self.w + 4, self.h + 4)
                love.graphics.pop()
            end,

            update = function(self, dt)
                ROTATION = ROTATION + (math.pi / 90)
            end,

            updateCoordinates = function(self, x, y)
                self.x, self.y = x, y
            end,

            updateDimensions = function(self, w, h)
                self.w, self.h = w, h
            end,

        }):init(x, y, w, h)
    end,
}
 
