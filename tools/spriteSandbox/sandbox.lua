return {
    graphics   = require("tools/lib/graphics"):create(),

    ringSprite = require("tools/spriteSandbox/sprite"):create("objects/ring", 0, 0),

    draw = function(self)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", 0, 0, 1200, 800)

        self.ringSprite:draw(self.graphics)
    end,

    update = function(self, dt)
        self.ringSprite.x, self.ringSprite.y = self:screenToImageCoordinates(love.mouse.getPosition())
        self.ringSprite:update(dt)
    end,

    moveImage = function(self, deltaX, deltaY)
        self.graphics:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.graphics:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.graphics:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

}
