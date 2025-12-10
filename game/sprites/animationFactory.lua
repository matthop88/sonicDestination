local COLOR_PURE_WHITE = { 1, 1, 1 }
local IMAGE_LOADER     = requireRelative("util/imageLoader")

return {
    init   = function(self, params)
        self.GRAPHICS = params.GRAPHICS
        return self
    end,

    create = function(self, spriteDataName)
        local spriteData       = requireRelative("sprites/data/" .. spriteDataName)
        local animationData    = spriteData.animations
        local image            = IMAGE_LOADER:loadImage("resources/images/spriteSheets/" .. spriteData.imageName .. ".png")
    
        local animations       = self:createAnimationObjects(animationData, image)
        local defaultAnimation = self:setUpDefaultAnimation(animations)

        return self:createSpriteAnimations {
            GRAPHICS         = self.GRAPHICS, 
            spriteDataName   = spriteDataName,
            image            = image,
            animations       = animations,
            defaultAnimation = defaultAnimation,
        }
    end,

    createSingle = function(self, spriteDataName, animationName)
        local spriteData       = requireRelative("sprites/data/" .. spriteDataName)
        local animationData    = spriteData.animations
        local image            = IMAGE_LOADER:loadImage("resources/images/spriteSheets/" .. spriteData.imageName .. ".png")
    
        local animation        = self:createSpecificAnimationObject(animationData, animationName, image)
        
        return self:createSpriteAnimations {
            GRAPHICS         = self.GRAPHICS, 
            spriteDataName   = spriteDataName,
            image            = image,
            animations       = { animation },
            defaultAnimation = animation,
        }
    end,

    createAnimationObjects = function(self, animationData, image)
        local animations = {}

        for name, animEntry in pairs(animationData) do
            animations[name] = self:createAnimObject(name, animEntry, image)
        end

        return animations
    end,

    createSpecificAnimationObject = function(self, animationData, animationName, image)
        for name, animEntry in pairs(animationData) do
            if name == animationName then
                return self:createAnimObject(name, animEntry, image)
            end
        end
    end,

    createAnimObject = function(self, name, animEntry, image)
        if animEntry.parts then return self:createCompositeAnimation(name, animEntry, image)
        else                    return self:createSimpleAnimation(name, animEntry, image) end
    end,    

    createCompositeAnimation = function(self, name, animationEntry, image)
        return requireRelative("sprites/compositeAnimation"):create(name, animationEntry, image, self)
    end,

    createSimpleAnimation = function(self, name, animationEntry, image)
        return requireRelative("sprites/simpleAnimation"):create(name, animationEntry, image)
    end,

    setUpDefaultAnimation = function(self, animations)
        local defaultAnimation = nil

        for name, anim in pairs(animations) do
            if anim:isDefault() or defaultAnimation == nil then
                anim.name        = name
                defaultAnimation = anim
            end
        end
        
        return defaultAnimation
    end,

    createSpriteAnimations = function(self, params)
        return {
            graphics          = params.GRAPHICS,
            name              = params.spriteDataName,
            animations        = params.animations,
            currentAnimation  = params.defaultAnimation,
            
            draw = function(self, x, y, scaleX, scaleY, GRAPHICS)
                GRAPHICS = GRAPHICS or self.graphics
                GRAPHICS:setColor(COLOR_PURE_WHITE)
                self.currentAnimation:draw(GRAPHICS, x, y, scaleX, scaleY)
            end,

            update = function(self, dt)
                self.currentAnimation:update(dt)
            end,

            setCurrentAnimation = function(self, animationName)
                if self.animations[animationName] == nil then
                    print("ERROR: Cannot switch to animation \"" .. animationName .. "\"")
                else
                    self:setCurrentAnimationIntern(animationName)
                end
            end,

            setCurrentAnimationIntern = function(self, animationName)
                if self.currentAnimation:getName() ~= animationName then
                    self.currentAnimation = self.animations[animationName]
                    self.currentAnimation:reset()
                end
            end,

            deletable          = function(self)      
                return  self.currentAnimation.reps ~= nil
                    and self.currentAnimation.reps <= self.repCount
            end,

            isForeground       = function(self)      return self.currentAnimation:isForeground()                 end,
            getHitBox          = function(self)      return self.currentAnimation:getHitBox()                    end,
            getImage           = function(self)      return self.currentAnimation:getImage()                     end,
            getCurrentQuad     = function(self)      return self.currentAnimation:getCurrentQuad()               end,
            getCurrentFrame    = function(self)      return self.currentAnimation:getCurrentFrame()              end,
            getCurrentAnimName = function(self)      return self.currentAnimation:getName()                      end,
            getCurrentOffset   = function(self)      return self.currentAnimation:getCurrentOffset()             end,
            getFPS             = function(self)      return self.currentAnimation:getFPS()                       end,   
            setFPS             = function(self, fps)        self.currentAnimation:setFPS(fps)                    end,
        
            getImageX          = function(self, x, scaleX)  return self.currentAnimation:getImageX()             end,
            getImageY          = function(self, y, scaleY)  return self.currentAnimation:getImageY()             end,
            getImageW          = function(self,    scaleX)  return self.currentAnimation:getImageW(scaleX)       end,
            getImageH          = function(self,    scaleY)  return self.currentAnimation:getImageH(scaleY)       end,

            getGeneralX        = function(self, x, scaleX)  return self.currentAnimation:getGeneralX()           end,
            getGeneralY        = function(self, y, scaleY)  return self.currentAnimation:getGeneralY()           end,
                
            getCurrentFrameIndex = function(self)
                return self.currentAnimation:getCurrentFrameIndex()
            end,
            
            setCurrentFrameIndex = function(self, frameIndex)
                self.currentAnimation:setCurrentFrameIndex(frameIndex)
            end,
        }
    end,
}
