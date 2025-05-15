return {
    x         = 0,
    y         = 0,
    scale     = 1,
    imagePath = nil,
    imageData = nil,
    image     = nil,

    init = function(self, params)
        self.imagePath = params.imagePath
        self.pixelated = params.pixelated

        self:loadImage()
        
        return self
    end,

    loadImage = function(self)
        self.imageData = love.image.newImageData(self.imagePath)
        self:refresh()
    end,
    
    refresh = function(self)
        self.image = love.graphics.newImage(self.imageData)
        if self.pixelated then
            self.image:setFilter("nearest", "nearest")
        end
    end,

    reload = function(self)
        self:loadImage()
    end,
    
    moveImage = function(self, deltaX, deltaY)
        self.x = self.x + deltaX
        self.y = self.y + deltaY
    end,

    adjustScaleGeometrically = function(self, delta)
        self.scale = self.scale + (delta * self.scale)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        local imageX = math.min(self:getImageWidth()  - 1, (screenX / self.scale) - self.x)
        local imageY = math.min(self:getImageHeight() - 1, (screenY / self.scale) - self.y)

        return imageX, imageY
    end,

    imageToScreenCoordinates = function(self, imageX, imageY)
        local screenX = (imageX + self.x) * self.scale
        local screenY = (imageY + self.y) * self.scale

        return screenX, screenY
    end,

    imageToScreenRect = function(self, imageX, imageY, imageW, imageH)
        local screenX, screenY = self:imageToScreenCoordinates(imageX, imageY)
        local screenW, screenH = imageW * self.scale, imageH * self.scale

        return screenX, screenY, screenW, screenH
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
        local r, g, b, a = self:getImagePixelAt(x, y)
        return { r = r, g = g, b = b, a = a }
    end,

    editPixels = function(self, pixelMapper)
        self.imageData:mapPixel(pixelMapper)
        self:refresh()
    end,

    saveImage = function(self, imgName)
        return self.imageData:encode("png", imgName .. ".png")
    end,
            
    getScale = function(self)
        return self.scale
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



