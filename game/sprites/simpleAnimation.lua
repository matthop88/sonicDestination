return {
	create = function(self, name, animationData, image)
		self:enhanceWithQuads(animationData, image)

		return {
			name              = name,
			data              = animationData,
			currentFrameIndex = 1,
			repCount          = 0,
			image             = image,

			getName           = function(self) return self.name end,

			draw = function(self, GRAPHICS, x, y, scaleX, scaleY)
                local currentQuad = self:getCurrentQuad()
                if currentQuad then
                    GRAPHICS:draw(self:getImage(), self:getCurrentQuad(), self:getImageX(x, scaleX), self:getImageY(y, scaleY), 0, scaleX, scaleY)
                end
            end,

			drawBorder = function(self, GRAPHICS, x, y, scaleX, scaleY)
                GRAPHICS:setColor(1, 1, 1)
                GRAPHICS:setLineWidth(2)
                GRAPHICS:rectangle("line", self:getGeneralX(x, scaleX), self:getGeneralY(y, scaleY), self.data.w, self.data.h)
            end,

            update = function(self, dt)
                local prevFrameIndex = math.floor(self.currentFrameIndex)
                self.currentFrameIndex = self.currentFrameIndex + (self:getFPS() * dt)
                if math.floor(self.currentFrameIndex) > prevFrameIndex then
                    self.repCount = self.repCount + (1 / #self.data)
                    if math.floor(self.currentFrameIndex) > #self.data then
                        self.currentFrameIndex = self.currentFrameIndex - #self.data
                    end
                end
            end,

            reset = function(self)
                self.currentFrameIndex     = 1
                self.repCount              = 0
            end,

            isForeground = function(self)
                return self.data.foreground or self:getCurrentFrame().foreground
            end,
        
            getHitBox = function(self)
                return self.data.hitBox
            end,

            deletable          = function(self)      
                return  self.data.reps ~= nil
                    and self.data.reps <= self.repCount
            end,

            isDefault          = function(self)      return self.data.isDefault                                  end,
            getImage           = function(self)      return self.image                                           end,
            getCurrentQuad     = function(self)      return self:getCurrentFrame().quad                          end,
            getCurrentFrame    = function(self)      return self.data[self:getCurrentFrameIndex()]               end,
            getCurrentOffset   = function(self)      return self:getCurrentFrame().offset                        end,
            getFPS             = function(self)      return self.data.fps                                        end,   
            setFPS             = function(self, fps) self.data.fps = fps                                         end,
        
            getImageX          = function(self, x, scaleX)  return x - (self:getCurrentOffset().x * scaleX)      end,
            getImageY          = function(self, y, scaleY)  return y - (self:getCurrentOffset().y * scaleY)      end,
            getImageW          = function(self,    scaleX)  return self:getCurrentFrame().w * scaleX             end,
            getImageH          = function(self,    scaleY)  return self:getCurrentFrame().h * scaleY             end,

            getGeneralX        = function(self, x, scaleX)  return x - (self.data.offset.x * math.abs(scaleX))   end,
            getGeneralY        = function(self, y, scaleY)  return y - (self.data.offset.y * math.abs(scaleY))   end,
                
            getCurrentFrameIndex = function(self)
                if math.floor(self.currentFrameIndex) > #self.data then
                    self.currentFrameIndex = 1
                    -- XXX: The reason for this necessity is UNKNOWN
                    --      but if this isn't done, game will crash when resetting world
                end
                return math.floor(self.currentFrameIndex)
            end,

            setCurrentFrameIndex = function(self, frameIndex)
                if     frameIndex < 1          then frameIndex = #self.data
                elseif frameIndex > #self.data then frameIndex = 1      end
                    
                self.currentFrameIndex = frameIndex
            end,
        }
	end,

	enhanceWithQuads = function(self, animationData, image)
		for _, frame in ipairs(animationData) do
			if frame.x then
				frame.quad = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h,
												   image:getWidth(), image:getHeight())
			end
		end
	end,
}
