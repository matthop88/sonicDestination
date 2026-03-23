return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 1280,
			margin = params.margin or 40,
			thumbWidth = params.thumbWidth or 12,
			thumbHeight = params.thumbHeight or 20,
			soundObject = nil,
			soundModel = nil,
			isDragging = false,
			onPositionChanged = params.onPositionChanged,
			lineStartX = nil,
			lineEndX = nil,
			lineWidth = nil,
			
			init = function(self)
				self.lineStartX = self.x + self.margin
				self.lineEndX = self.x + self.width - self.margin
				self.lineWidth = self.lineEndX - self.lineStartX
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
			end,
			
			draw = function(self)
				if not self.soundObject or not self.soundModel then return end
				
				self:drawTimeline()
				self:drawThumb()
			end,
			
			drawTimeline = function(self)
				love.graphics.setColor(0, 1, 0)
				love.graphics.setLineWidth(2)
				love.graphics.line(self.lineStartX, self.y, self.lineEndX, self.y)
				love.graphics.setLineWidth(1)
			end,
			
			drawThumb = function(self)
				local thumbX = self:getThumbPosition()
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", 
					thumbX - self.thumbWidth / 2, 
					self.y - self.thumbHeight / 2,
					self.thumbWidth,
					self.thumbHeight)
			end,
			
			getThumbPosition = function(self)
				if not self.soundObject or not self.soundModel then return 0 end
				
				local duration = self.soundObject:getSampleCount() / self.soundObject:getSampleRate()
				local currentTime = self.soundObject.audioSource:tell("seconds")
				local progress = duration > 0 and (currentTime / duration) or 0
				
				return self.lineStartX + (progress * self.lineWidth)
			end,
			
			isMouseOverThumb = function(self, mx, my)
				if not self.soundObject or not self.soundModel then return false end
				
				local thumbX = self:getThumbPosition()
				local thumbLeft = thumbX - self.thumbWidth / 2
				local thumbRight = thumbX + self.thumbWidth / 2
				local thumbTop = self.y - self.thumbHeight / 2
				local thumbBottom = self.y + self.thumbHeight / 2
				
				return mx >= thumbLeft and mx <= thumbRight and my >= thumbTop and my <= thumbBottom
			end,
			
			handleMousePressed = function(self, mx, my)
				if self:isMouseOverThumb(mx, my) then
					self.isDragging = true
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.isDragging = false
			end,
			
			handleMouseDragged = function(self, mx, my)
				if not self.isDragging or not self.soundObject or not self.soundModel then return end
				
				-- Clamp mouse position to timeline bounds
				local clampedX = math.max(self.lineStartX, math.min(mx, self.lineEndX))
				local progress = (clampedX - self.lineStartX) / self.lineWidth
				
				-- Set audio position
				local duration = self.soundObject:getSampleCount() / self.soundObject:getSampleRate()
				local newTime = progress * duration
				self.soundObject.audioSource:seek(newTime, "seconds")
				
				-- Notify that position changed
				if self.onPositionChanged then
					self.onPositionChanged()
				end
			end,
		}):init()
	end,
}
