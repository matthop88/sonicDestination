local COLOR_PURE_WHITE = { 1, 1, 1 }

return ({
    image    = love.graphics.newImage(relativePath("resources/images/spriteSheets/sonic1Transparent.png")),
    data = {
        standing = {
            rects = {
                { x =  43, y = 257, w = 32, h = 40, offset = { x = 12, y = 20 }, },
            },
            quads = { },
        },
        running  = {
            rects = {
                { x =  46, y = 349, w = 24, h = 40, offset = { x =  8, y = 19 }, },
                { x = 109, y = 347, w = 40, h = 40, offset = { x = 16, y = 19 }, },
                { x = 178, y = 348, w = 32, h = 40, offset = { x = 16, y = 19 }, },
                { x = 249, y = 349, w = 40, h = 40, offset = { x = 16, y = 19 }, },
                { x = 319, y = 347, w = 40, h = 40, offset = { x = 16, y = 19 }, },
                { x = 390, y = 348, w = 40, h = 40, offset = { x = 16, y = 19 }, },
            },
            quads = { },
        },
    },
    
    currentAnimation  = nil,
    currentFrameIndex = 1,
    
    init = function(self)
        self.image:setFilter("nearest", "nearest")
        self:addQuads()
        self.currentAnimation  = self.data.standing
        self.currentFrameIndex = 1

        return self
    end,

    addQuads = function(self)
        for _, animation in pairs(self.data) do
            for _, rect in ipairs(animation.rects) do
                table.insert(animation.quads, love.graphics.newQuad(
                    rect.x, rect.y, rect.w, rect.h,
                    self.image:getWidth(), self.image:getHeight()))
            end
        end
    end,

    draw = function(self, x, y, scaleX, scaleY)
        graphics:setColor(COLOR_PURE_WHITE)
        graphics:draw(self:getImage(),           
                      self:getCurrentFrame(), 
                      self:getImageX(x, scaleX), 
                      self:getImageY(y, scaleY),
                      0, scaleX, scaleY)
    end,

    setCurrentAnimation = function(self, animationName)
        self.currentAnimation = self.data[animationName]
        self.currentFrameIndex = 1
    end,

    getImage = function(self)
        return self.image
    end,

    getCurrentFrame = function(self)
        return self.currentAnimation.quads[self.currentFrameIndex]
    end,

    getCurrentOffset = function(self)
        return self.currentAnimation.rects[self.currentFrameIndex].offset
    end,
        
    getImageX = function(self, x, scaleX) 
        return x - (self:getCurrentOffset().x * scaleX) 
    end,

    getImageY = function(self, y, scaleY)
        return y - (self:getCurrentOffset().y * scaleY)
    end,

    advanceFrame = function(self)
        self.currentFrameIndex = self.currentFrameIndex + 1
        if self.currentFrameIndex > #self.currentAnimation.quads then
            self.currentFrameIndex = 1
        end
    end,

    regressFrame = function(self)
        self.currentFrameIndex = self.currentFrameIndex - 1
        if self.currentFrameIndex < 1 then
            self.currentFrameIndex = #self.currentAnimation.quads
        end
    end,

}):init()
