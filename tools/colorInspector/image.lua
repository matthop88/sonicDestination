local IMAGE_DATA = love.image.newImageData("resources/images/sadNoFileImage.png")

if __INSPECTOR_FILE ~= nil then
    IMAGE_DATA = love.image.newImageData("resources/images/spriteSheets/" .. __INSPECTOR_FILE .. ".png")
end

IMAGE_VIEWER = {
    x     = 0,
    y     = 0,
    scale = 1,
    image = love.graphics.newImage(IMAGE_DATA),

    moveImage = function(self, deltaX, deltaY)
        self.x = self.x + deltaX
        self.y = self.y + deltaY
    end,

    adjustScaleGeometrically = function(self, delta)
        self.scale = self.scale + (delta * self.scale)
    end,

    screenToImageCoordinates = function(self, sX, sY)
        local imageX = math.min(self:getImageWidth()  - 1, (sX / self.scale) - x)
        local imageY = math.min(self:getImageHeight() - 1, (sY / self.scale) - y)

        return imageX, imageY
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.x = (screenX / self.scale) - imageX
        self.y = (screenY / self.scale) - imageY
    end,
    
    getImageWidth = function(self)
        return self.image:getWidth()
    end,

    getImageHeight = function(self)
        return self.image:getHeight()
    end,

    getImagePixelAt = function(self, x, y)
        return IMAGE_DATA:getPixel(math.floor(x), math.floor(y))
    end,

    drawImage = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.image, self.x * self.scale, self.y * self.scale, 0, self.scale, self.scale)
    end,

    updateImage = function(self)
        if isMotionless() then self:keepImageInBounds() end
    end,

    keepImageInBounds = function(self)
        self.x = math.min(0, math.max(self.x, (WINDOW_WIDTH  / self.scale) - self:getImageWidth()))
        self.y = math.min(0, math.max(self.y, (WINDOW_HEIGHT / self.scale) - self:getImageHeight()))
    end,
}
