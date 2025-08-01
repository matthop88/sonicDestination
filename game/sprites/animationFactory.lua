local COLOR_PURE_WHITE = { 1, 1, 1 }

return {
    init   = function(self, params)
        self.GRAPHICS = params.GRAPHICS
        return self
    end,
    
    create = function(self, spriteDataName)
        return ({
            frameTimer    = 0,
            frameTimerMax = 1,

            graphics      = self.GRAPHICS,
            
            init = function(self, spriteDataName)
                self:initSpriteData()
                self:initFrames()
                self:initAnimations()
                
                return self
            end,

            initSpriteData  = function(self)
                local spriteData = requireRelative("sprites/data/" .. spriteDataName)
                self.data = spriteData.animations
                self.image = love.graphics.newImage(relativePath("resources/images/spriteSheets/" .. spriteData.imageName .. ".png"))
                self.image:setFilter("nearest", "nearest")
            end,
                
            initFrames = function(self)
                for _, anim in pairs(self.data) do
                    for _, frame in ipairs(anim) do
                        frame.quad = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h,
                                                           self.image:getWidth(), self.image:getHeight())
                    end
                end
            end,

            initAnimations = function(self)
                self.currentAnimation  = nil
                self.currentFrameIndex = 1
                
                self:setUpDefaultAnimation()
                self:updateFrameRate()
            end,
        
            setUpDefaultAnimation = function(self)
                for name, anim in pairs(self.data) do
                    if anim.isDefault or self.currentAnimation == nil then
                        anim.name = name
                        self.currentAnimation = anim
                    end
                end
            end,
        
            draw = function(self, x, y, scaleX, scaleY)
                self.graphics:setColor(COLOR_PURE_WHITE)
                self.graphics:draw(self:getImage(), self:getCurrentQuad(), self:getImageX(x, scaleX), self:getImageY(y, scaleY), 0, scaleX, scaleY)
            end,
        
            update = function(self, dt)
                if self:getFPS() ~= 0 then
                    self.frameTimer = self.frameTimer + dt
                    if self.frameTimer >= self.frameTimerMax then
                        self.frameTimer = 0
                        self:advanceFrame()
                    end
                end
            end,
        
            setCurrentAnimation = function(self, animationName)
                self.currentAnimation = self.data[animationName]
                self.currentAnimation.name = animationName
                self.currentFrameIndex = 1
                self.frameTimer = 0
                self:updateFrameRate()
            end,
        
            updateFrameRate = function(self)
                if self.currentAnimation.fps ~= nil and self.currentAnimation.fps ~= 0 then
                    self.frameTimerMax = 1 / self.currentAnimation.fps
                else
                    self.frameTimerMax = 1
                end
            end,
        
            getImage           = function(self)      return self.image                                    end,
            getCurrentQuad     = function(self)      return self:getCurrentFrame().quad                   end,
            getCurrentFrame    = function(self)      return self.currentAnimation[self.currentFrameIndex] end,
            getCurrentAnimName = function(self)      return self.currentAnimation.name                    end,
            getCurrentOffset   = function(self)      return self:getCurrentFrame().offset                 end,
            getFPS             = function(self)      return self.currentAnimation.fps                     end,
                
            setFPS           = function(self, fps) 
                self.currentAnimation.fps = fps
                self:updateFrameRate()
            end,
        
            getImageX = function(self, x, scaleX)  return x - (self:getCurrentOffset().x * scaleX)      end,
            getImageY = function(self, y, scaleY)  return y - (self:getCurrentOffset().y * scaleY)      end,
        
            getCurrentFrameIndex = function(self)  return self.currentFrameIndex                        end,

            setCurrentFrameIndex = function(self, frameIndex)
                if     frameIndex < 1                      then frameIndex = #self.currentAnimation
                elseif frameIndex > #self.currentAnimation then frameIndex = 1                  end
                    
                self.currentFrameIndex = frameIndex
            end,

            advanceFrame = function(self) self:setCurrentFrameIndex(self.currentFrameIndex + 1)        end,     
        }):init(spriteDataName)
    end,
}
