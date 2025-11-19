return {
    graphics      = require("tools/lib/graphics"):create(),
    currentSprite = require("tools/spriteSandbox/sprite"):create("objects/ring", 0, 0),

    sprites = {},

    draw = function(self)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", 0, 0, 1200, 800)

        for _, sprite in ipairs(self.sprites) do
            sprite:draw(self.graphics)
        end

        self.currentSprite:draw(self.graphics)
    end,

    update = function(self, dt)
        for _, sprite in ipairs(self.sprites) do
            sprite:update(dt)
        end

        self.currentSprite.x, self.currentSprite.y = self:screenToImageCoordinates(love.mouse.getPosition())
        self.currentSprite:update(dt)
    end,

    handleMousepressed = function(self, mx, my)
        table.insert(self.sprites, self.currentSprite)
        local sX, sY = self:screenToImageCoordinates(love.mouse.getPosition())
        self.currentSprite = require("tools/spriteSandbox/sprite"):create("objects/ring", sX, sY)
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
