local COLOR_PURE_WHITE = { 1, 1, 1 }

return {
    animations = ({
        image    = love.graphics.newImage(relativePath("resources/images/spriteSheets/sonic1Transparent.png")),
        data = {
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
        
        init = function(self)
            self.image:setFilter("nearest", "nearest")
            self:addQuads()
            self.currentAnimation  = self.data.running
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
            love.graphics.setColor(COLOR_PURE_WHITE)
            love.graphics.draw(self:getImage(), self:getCurrentFrame(), x, y, 0, scaleX, scaleY)
        end,

        getImage = function(self)
            return self.image
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
    }):init(),
       
    offset   = { x = 16, y = 20 },
    scale    = { x =  3, y =  3 },

    draw = function(self, x, y)
        love.animations:draw(self:getImageX(x), self:getImageY(y), self.scale.x, self.scale.y)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    getImageX  = function(self, x) return x - (self.offset.x * self.scale.x) end,
    getImageY  = function(self, y) return y - (self.offset.y * self.scale.y) end,

    isXFlipped = function(self)    return self.scale.x < 0                   end,
    flipX      = function(self)    self.scale.x = self.scale.x * -1          end,
          
}
