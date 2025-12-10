return {
	create = function(self, name, animationData, image, ANIMATION_FACTORY)
		local subAnimations = {}
        for _, part in ipairs(animationData.parts) do
            table.insert(subAnimations, ANIMATION_FACTORY:createSingle("objects/parts/" .. part.name, part.animation))
        end

		return {
            subAnimations     = subAnimations,
            name              = name,
            image             = image,
            data              = animationData,

			getName           = function(self) return self.name end,

			draw = function(self, GRAPHICS, x, y, scaleX, scaleY)
                for _, subAnim in ipairs(self.subAnimations) do
                    subAnim:draw(x, y, scaleX, scaleY, GRAPHICS)
                end
            end,

			drawBorder = function(self, GRAPHICS, x, y, scaleX, scaleY)
                GRAPHICS:setColor(1, 1, 1)
                GRAPHICS:setLineWidth(2)
                GRAPHICS:rectangle("line", self:getGeneralX(x, scaleX), self:getGeneralY(y, scaleY), self.data.w, self.data.h)
            end,

            update = function(self, dt)
                for _, subAnim in ipairs(self.subAnimations) do
                    subAnim:update(dt)
                end
            end,

            reset = function(self)
                for _, subAnim in ipairs(self.subAnimations) do
                    subAnim:reset(dt)
                end
            end,

            isForeground = function(self)
                return self.data.foreground
            end,
        
            getHitBox = function(self)
                return self.data.hitBox
            end,

            deletable          = function(self)      
                for _, subAnim in ipairs(self.subAnimations) do
                    if not subAnim:deletable() then return false end
                end
                return true
            end,

            isDefault          = function(self)      return self.data.isDefault end,
            getImage           = function(self)      return self.image          end,
            getCurrentQuad     = function(self)      return nil                 end,
            getCurrentFrame    = function(self)      return nil                 end,
            getCurrentOffset   = function(self)      return self.data.offset    end,
            getFPS             = function(self)      return nil                 end,   
            setFPS             = function(self, fps)                            end,
        
            getImageX          = function(self, x, scaleX)  return nil          end,
            getImageY          = function(self, y, scaleY)  return nil          end,
            getImageW          = function(self,    scaleX)  return self.data.w  end,
            getImageH          = function(self,    scaleY)  return self.data.h  end,

            getGeneralX        = function(self, x, scaleX)  return nil          end,
            getGeneralY        = function(self, y, scaleY)  return nil          end,
                
            getCurrentFrameIndex = function(self)
                return nil
            end,

            setCurrentFrameIndex = function(self, frameIndex)
                -- Do nothing
            end,
        }
	end,
}
