return {
    init   = function(self, params)
        self.GRAPHICS = params.GRAPHICS
        return self
    end,
    
    create = function(self, name)
        return {
            animations = requireRelative("sprites/animationFactory", { GRAPHICS = self.GRAPHICS }):create(name),
            scale      = { x =  1, y =  1 },
        
            draw = function(self, x, y)
                self.animations:draw(x, y, self.scale.x, self.scale.y)
            end,
        
            update = function(self, dt)
                self.animations:update(dt)
            end,
        
            --------------------------------------------------------------
            --                  Specialized Functions                   --
            --------------------------------------------------------------

            getCurrentOffset     = function(self) return self.animations:getCurrentOffset()      end,
            getCurrentFrameIndex = function(self) return self.animations:getCurrentFrameIndex()  end,

            setCurrentFrameIndex = function(self, frameIndex)
                self.animations:setCurrentFrameIndex(frameIndex)
            end,
            
            setCurrentAnimation = function(self, animationName)
                self.animations:setCurrentAnimation(animationName)
            end,

            getCurrentAnimationName = function(self)
                return self.animations:getCurrentAnimName()
            end,

            getFPS = function(self)      return self.animations:getFPS() end,
            setFPS = function(self, fps) self.animations:setFPS(fps)     end,
            
            flipX       = function(self)           self.scale.x = self.scale.x * -1          end,
            isXFlipped  = function(self)           return self.scale.x < 0                   end,
            setXFlipped = function(self, xFlipped)
                if xFlipped then self.scale.x = -math.abs(self.scale.x)
                else             self.scale.x =  math.abs(self.scale.x) end
            end,
        }
    end,      
}
