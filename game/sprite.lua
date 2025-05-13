local COLOR_PURE_WHITE = { 1, 1, 1 }

return ({
    image    = love.graphics.newImage(relativePath("resources/images/spriteSheets/sonic1Transparent.png")),
    animations = {
        standing = {
            rects = {
                { x =  43, y = 257, w = 32, h = 40 },
            },
            quads = { },
        },
        running  = {
            rects = {
                { x =  46, y = 349, w = 24, h = 40 },
                { x = 109, y = 347, w = 40, h = 40 },
                { x = 178, y = 348, w = 32, h = 40 },
                { x = 249, y = 349, w = 40, h = 40 },
                { x = 319, y = 347, w = 40, h = 40 },
                { x = 390, y = 348, w = 40, h = 40 },
            },
            quads = { },
        },
    },
    
    currentAnimation  = nil,
    currentFrameIndex = 1,
        
    offset   = { x = 16, y = 20 },
    scale    = { x =  3, y =  3 },

    init = function(self)
        self:addQuads()
        
        self.currentAnimation = self.animations.running
        self.currentFrameIndex = 3
            
        self.image:setFilter("nearest", "nearest")
        return self
    end,

    draw = function(self, x, y)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.draw(self.image,        self:getCurrentFrame(),
                           self:getImageX(x), self:getImageY(y),
                        0, self.scale.x,      self.scale.y)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    addQuads = function(self)
        for _, animation in pairs(self.animations) do
            for _, rect in ipairs(animation.rects) do
                table.insert(animation.quads, love.graphics.newQuad(
                    rect.x, rect.y, rect.w, rect.h,
                    self.image:getWidth(), self.image:getHeight()))
            end
        end
    end,
        
    getCurrentFrame = function(self)
        return self.currentAnimation.quads[self.currentFrameIndex]
    end,

    advanceFrame = function(self)
        self.currentFrameIndex = self.currentFrameIndex + 1
        if self.currentFrameIndex > #self.currentAnimation.quads then
            self.currentFrameIndex = 1
        end
    end,
        
    getImageX  = function(self, x) return x - (self.offset.x * self.scale.x) end,
    getImageY  = function(self, y) return y - (self.offset.y * self.scale.y) end,

    isXFlipped = function(self)    return self.scale.x < 0                   end,
    flipX      = function(self)    self.scale.x = self.scale.x * -1          end,
          
}):init()
