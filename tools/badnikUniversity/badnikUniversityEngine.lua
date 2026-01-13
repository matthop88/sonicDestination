
return {
    create = function(self, params)
        return ({
            graphics   = require("tools/lib/graphics"):create(), 
            badnikMode = false,
            badniks    = require("tools/badnikUniversity/badnikList"),
            badnikTemplate = require("tools/badnikUniversity/factories/badnikTemplateFactory"):createTemplate("motobug", "objects/motobug"),

            init = function(self, params)
                local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                return self
            end,

            draw = function(self)
                love.graphics.setColor(0.24, 0.1, 0.1)
                love.graphics.rectangle("fill", 0, 0, 1200, 800)
                
                self.badniks:draw(self.graphics)

                if self.badnikMode then
                    love.mouse.setVisible(false)
                    local x, y = self:screenToImageCoordinates(love.mouse.getPosition())
                    self.badnikTemplate:drawPreviewSprite(self.graphics, math.floor(x), math.floor(y))
                else
                    love.mouse.setVisible(true)
                end
            end,

            update = function(self, dt)
                -- update functionality goes here
            end,

            handleKeypressed = function(self, key)
                if key == "b" then
                    self.badnikMode = not self.badnikMode
                elseif key == "x" and self.badnikMode then
                    self.badnikTemplate:flipX()
                end
            end,

            handleMousepressed = function(self, mx, my)
                if self.badnikMode then
                    local x, y = self:screenToImageCoordinates(mx, my)
                    self.badniks:placeBadnik(self.badnikTemplate:create(math.floor(x), math.floor(y)), self.graphics)
                    self.badnikMode = false
                end
            end,

            handleMousereleased = function(self, mx, my)
                -- mouse released functionality goes here
            end,

            ---------------------- Graphics Object Methods ------------------------

            moveImage = function(self, deltaX, deltaY)
                self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
            end,

            screenToImageCoordinates = function(self, screenX, screenY)
                return self.graphics:screenToImageCoordinates(screenX, screenY)
            end,

            imageToScreenCoordinates = function(self, imageX, imageY)
                return self.graphics:imageToScreenCoordinates(imageX, imageY)
            end,

            adjustScaleGeometrically = function(self, deltaScale)
                self.graphics:adjustScaleGeometrically(deltaScale)
            end,

            syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
                self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
            end,

        }):init(params)
    end,
}

