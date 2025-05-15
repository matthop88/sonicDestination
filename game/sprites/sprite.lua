local COLOR_PURE_WHITE = { 1, 1, 1 }

return ({
    animations = requireRelative("sprites/data/sonic1"),
    scale      = { x =  3, y =  3 },

    init = function(self)
        self:initAnimations(self.animations)
        return self
    end,

    draw = function(self, x, y)
        self.animations:draw(x, y, self.scale.x, self.scale.y)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    initAnimations = function(self, anim)
        anim.currentAnimation  = nil
        anim.currentFrameIndex = 1
        anim.currentAnimation  = anim.data.standing

        anim.image:setFilter("nearest", "nearest")

        for _, animation in pairs(anim.data) do
            animation.quads = {}
            for _, rect in ipairs(animation.rects) do
                table.insert(animation.quads, love.graphics.newQuad(
                    rect.x, rect.y, rect.w, rect.h,
                    anim.image:getWidth(), anim.image:getHeight()))
            end
        end

        anim.draw = function(self, x, y, scaleX, scaleY)
            graphics:setColor(COLOR_PURE_WHITE)
            graphics:draw(self:getImage(),           
                          self:getCurrentFrame(), 
                          self:getImageX(x, scaleX), 
                          self:getImageY(y, scaleY),
                          0, scaleX, scaleY)
        end

        anim.setCurrentAnimation = function(self, animationName)
            self.currentAnimation = self.data[animationName]
            self.currentFrameIndex = 1
        end

        anim.getImage = function(self)
            return self.image
        end

        anim.getCurrentFrame = function(self)
            return self.currentAnimation.quads[self.currentFrameIndex]
        end

        anim.getCurrentOffset = function(self)
            return self.currentAnimation.rects[self.currentFrameIndex].offset
        end
        
        anim.getImageX = function(self, x, scaleX) 
            return x - (self:getCurrentOffset().x * scaleX) 
        end

        anim.getImageY = function(self, y, scaleY)
            return y - (self:getCurrentOffset().y * scaleY)
        end

        anim.advanceFrame = function(self)
            self.currentFrameIndex = self.currentFrameIndex + 1
            if self.currentFrameIndex > #self.currentAnimation.quads then
                self.currentFrameIndex = 1
            end
        end

        anim.regressFrame = function(self)
            self.currentFrameIndex = self.currentFrameIndex - 1
            if self.currentFrameIndex < 1 then
                self.currentFrameIndex = #self.currentAnimation.quads
            end
        end
    end,

    isXFlipped = function(self)    return self.scale.x < 0                   end,
    flipX      = function(self)    self.scale.x = self.scale.x * -1          end,
          
}):init()
