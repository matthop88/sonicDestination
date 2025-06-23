return {
    init   = function(self, params)
        self.GRAPHICS = params.GRAPHICS
        return self
    end,
    
    create = function(self, name)
        return {
            animations = requireRelative("sprites/animationFactory", { GRAPHICS = self.GRAPHICS }):create(name),
            scale      = { x =  3, y =  3 },
        
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

            setFps = function(self, fps)
                self.animations:setFps(fps)
            end,
            
            isXFlipped = function(self)    return self.scale.x < 0                   end,
            flipX      = function(self)    self.scale.x = self.scale.x * -1          end,
        }
    end,      
}
