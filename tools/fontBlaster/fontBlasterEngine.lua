return {
    create = function(self, params)
        return ({
            graphics         = require("tools/lib/graphics"):create(), 
            
            init = function(self, params)
                return self
            end,

            draw = function(self)
                -- Do nothing
            end,

            update = function(self, dt)
                -- Do nothing
            end,

            handleKeypressed = function(self, key)
                -- Do nothing
            end,

            handleMousepressed = function(self, mx, my)
                -- Do nothing
            end,

            handleMousereleased = function(self, mx, my)
                -- Do nothing
            end,

            -- IMAGE VIEWER METHODS --
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

