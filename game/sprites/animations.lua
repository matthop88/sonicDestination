local COLOR_PURE_WHITE = { 1, 1, 1 }

return {
    init = function(self, spriteDataName)
        local spriteData = requireRelative("sprites/data/" .. spriteDataName)
        self.data = spriteData.animations

        self.image = love.graphics.newImage(relativePath("resources/images/spriteSheets/" .. spriteData.imageName .. ".png"))
        self.image:setFilter("nearest", "nearest")

        self:initQuads()

        self.currentAnimation  = nil
        self.currentFrameIndex = 1
        
        self:setUpDefaultAnimation()

        return self
    end,

    initQuads = function(self)
        for _, anim in pairs(self.data) do
            anim.quads = {}
            for _, rect in ipairs(anim) do
                table.insert(anim.quads, love.graphics.newQuad(rect.x, rect.y, rect.w, rect.h,
                                                               self.image:getWidth(), self.image:getHeight()))
            end
        end
    end,

    setUpDefaultAnimation = function(self)
        for _, anim in pairs(self.data) do
            if anim.isDefault or self.currentAnimation == nil then
                self.currentAnimation = anim
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
        return self.currentAnimation[self.currentFrameIndex].offset
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
}
