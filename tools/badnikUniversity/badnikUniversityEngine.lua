return {
    create = function(self, params)
        return ({
            graphics = require("tools/lib/graphics"):create(), 
            
            init = function(self, params)
                self.badnikSprite = require("tools/lib/sprites/sprite"):create("objects/motobug", 500, 300)
                return self
            end,

            draw = function(self)
                love.graphics.setColor(0.24, 0.1, 0.1)
                love.graphics.rectangle("fill", 0, 0, 1200, 800)
                self.badnikSprite:draw(self.graphics)
            end,

            update = function(self, dt)
                -- update functionality goes here
            end,

            handleKeypressed = function(self, key)
                -- key pressed functionality goes here
            end,

            handleMousepressed = function(self, mx, my)
                -- mouse pressed functionality goes here
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

