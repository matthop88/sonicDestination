return {
    create = function(self, x, y)
        return ({
            init = function(self, x, y)
                self.x, self.y = x, y
                return self
            end,

            draw = function(self, GRAFX)
                local alpha = self:getAlpha(GRAFX)
                GRAFX:setColor(0, 0, 0, 0.5 * alpha)
                GRAFX:rectangle("fill", self.x + 6, self.y + 6, 40, 9)
                GRAFX:setColor(1, 1, 1, 0.7 * alpha)
                GRAFX:setLineWidth(0.5)
                GRAFX:rectangle("line", self.x + 6, self.y + 6, 40, 9)
                GRAFX:setColor(1, 1, 1, alpha)
                GRAFX:setFontSize(6)
                GRAFX:printf("" .. math.floor(self.x) .. ", " .. math.floor(self.y), self.x + 7, self.y + 7, 40, "center")
            end,

            getAlpha = function(self, GRAFX)
                local px, py = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
                local distance = math.sqrt(((px - self.x) * (px - self.x)) + ((py - self.y) * (py - self.y)))
                return math.max(0.1, ((10 - math.sqrt(distance)) / 10) + 0.2)
            end,

            updateCoordinates = function(self, x, y)
                self.x = x
                self.y = y
            end,

        }):init(x, y)
    end,
}
 
