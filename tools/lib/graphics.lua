return {
    x = 0, y = 0, scale = 1,

    fontSize  = 24,
    font      = love.graphics.newFont(24),
    lineWidth = 1,

    FONTS = {
        get = function(self, size)
            local fontSize = math.floor(size)
            if self[fontSize] == nil then
                self[fontSize] = love.graphics.newFont(fontSize)
            end
            return self[fontSize]
        end,
    },

    ---------------------- Property Getter Functions -------------------

    getFontHeight = function(self)
        return self.FONTS:get(self.fontSize):getHeight()
    end,

    getFontWidth = function(self, label)
        return self.FONTS:get(self.fontSize):getWidth(label)
    end,
    
    ---------------------- Property Setter Functions -------------------
    
    setColor     = function(self, arg1, arg2, arg3, arg4)
        love.graphics.setColor(arg1, arg2, arg3, arg4)
    end,
    
    setLineWidth = function(self, lineWidth) self.lineWidth = lineWidth    end,

    setFont  = function(self, font)
        self.font = font
        love.graphics.setFont(font)
    end,

    setFontSize = function(self, fontSize)
        self.fontSize = fontSize
        self:setFont(self.FONTS:get(self.fontSize * self.scale))
    end,
    
    ----------------------- Shape Drawing Functions --------------------
    
    rectangle = function(self, mode, x, y, w, h)
        love.graphics.setLineWidth(self.lineWidth * self.scale)
        love.graphics.rectangle(mode, (x + self.x) * self.scale,
                                      (y + self.y) * self.scale,
                                                w  * self.scale,
                                                h  * self.scale)
    end,

    line      = function(self, x1, y1, x2, y2)
        love.graphics.setLineWidth(self.lineWidth * self.scale)
        love.graphics.line((x1 + self.x) * self.scale,
                           (y1 + self.y) * self.scale,
                           (x2 + self.x) * self.scale, 
                           (y2 + self.y) * self.scale)
    end,

    draw      = function(self, image, quad, x, y, r, sx, sy)
        love.graphics.draw(image, quad, (x + self.x) * self.scale, 
                                        (y + self.y) * self.scale,
                                        0,        sx * self.scale, 
                                                  sy * self.scale)
    end,

    ------------------------ Text Drawing Functions --------------------

    printf    = function(self, text, x, y, w, align)
        love.graphics.printf(text, (x + self.x) * self.scale, 
                                   (y + self.y) * self.scale,
                                             w  * self.scale, align)
    end,

    ------------------------- Scrolling Functions ----------------------
    
    setX = function(self, x) self.x = x end,
    setY = function(self, y) self.y = y end,

    moveImage = function(self, deltaX, deltaY)
        self.x = self.x + deltaX
        self.y = self.y + deltaY
    end,

    ----------------------- Zooming Functions ----------------------

    setScale = function(self, scale) self.scale = scale end,
    
    screenToImageCoordinates = function(self, mx, my)
        local x = mx / self.scale - self.x
        local y = my / self.scale - self.y

        return x, y
    end,
    
    adjustScaleGeometrically = function(self, delta)
        self.scale = self.scale + (delta * self.scale)
    end,
    
    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self:syncImageXWithScreen(imageX, screenX)
        self:syncImageYWithScreen(imageY, screenY)
    end,

    syncImageXWithScreen = function(self, imageX, screenX)
        self.x = screenX / self.scale - imageX
    end,

    syncImageYWithScreen = function(self, imageY, screenY)
        self.y = screenY / self.scale - imageY
    end,

    getScreenWidth  = function(self) return love.graphics.getWidth()  end,
    getScreenHeight = function(self) return love.graphics.getHeight() end,

    calculateViewportRect = function(self)
        local x, y, w, h = self:calculateViewport()

        return { x = x, y = y, w = w, h = h }
    end,

    calculateViewport = function(self)
        local leftX,  topY    = self:screenToImageCoordinates(0, 0)
        local rightX, bottomY = self:screenToImageCoordinates(self:getScreenWidth(), self:getScreenHeight())

        return leftX, topY, rightX - leftX, bottomY - topY
    end,
}
