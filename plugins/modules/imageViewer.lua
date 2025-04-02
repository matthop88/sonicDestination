return {
    x         = 0,
    y         = 0,
    scale     = 1,
    imageData = nil,
    image     = nil,

    init = function(self, params)
        self.imageData = love.image.newImageData(params.imagePath)
        self.image = love.graphics.newImage(self.imageData)

        return self
    end,

    moveImage = function(self, deltaX, deltaY)
        self.x = self.x + deltaX
        self.y = self.y + deltaY
    end,

    adjustScaleGeometrically = function(self, delta)
        self.scale = self.scale + (delta * self.scale)
    end,

    screenToImageCoordinates = function(self, sX, sY)
        local imageX = math.min(self:getImageWidth()  - 1, (sX / self.scale) - self.x)
        local imageY = math.min(self:getImageHeight() - 1, (sY / self.scale) - self.y)

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

    getImageSize   = function(self)
        return self:getImageWidth(), self:getImageHeight()
    end,

    getImagePixelAt = function(self, x, y)
        return self.imageData:getPixel(math.floor(x), math.floor(y))
    end,

    getPixelColorAt = function(self, x, y)
        local r, g, b = self:getImagePixelAt(x, y)
        return { r = r, g = g, b = b }
    end,

    draw = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.image, self.x * self.scale, self.y * self.scale, 0, self.scale, self.scale)
    end,

    update = function(self, dt)
        -- Do nothing
    end,

    keepImageInBounds = function(self)
        self.x = math.min(0, math.max(self.x, (love.graphics:getWidth()  / self.scale) - self:getImageWidth()))
        self.y = math.min(0, math.max(self.y, (love.graphics:getHeight() / self.scale) - self:getImageHeight()))
    end,
}



