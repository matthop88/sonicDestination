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
				self:drawStartMarkerIndicator()
				self:drawEndMarkerIndicator()
				
				-- Only draw loop markers for music tracks
				local isMusic = self.soundObject.soundInfo and self.soundObject.soundInfo.isMusic
				if isMusic then
					self:drawLoopStartMarkerIndicator()
					self:drawLoopEndMarkerIndicator()
				end
				
				self:drawThumb()
			end,
			
			drawTimeline = function(self)
				love.graphics.setColor(0, 1, 0)
				love.graphics.setLineWidth(2)
				love.graphics.line(self.lineStartX, self.y, self.lineEndX, self.y)
				love.graphics.setLineWidth(1)
			end,
			
			drawStartMarkerIndicator = function(self)
				if not self.soundObject then return end
				
				local progress = self.soundObject:getStartPoint() / self.soundObject:getSampleCount()
				local markerX = self.lineStartX + (progress * self.lineWidth)
				local markerSize = 6
				
				love.graphics.setColor(1, 0.5, 0)
				love.graphics.polygon("fill",
					markerX - markerSize, self.y - markerSize,
					markerX, self.y,
					markerX - markerSize, self.y + markerSize
				)
			end,
			
			drawEndMarkerIndicator = function(self)
				if not self.soundObject then return end
				
				local progress = self.soundObject:getEndPoint() / self.soundObject:getSampleCount()
				local markerX = self.lineStartX + (progress * self.lineWidth)
				local markerSize = 6
				
				love.graphics.setColor(0.5, 0, 1)
				love.graphics.polygon("fill",
					markerX + markerSize, self.y - markerSize,
					markerX, self.y,
					markerX + markerSize, self.y + markerSize
				)
			end,
			
			drawLoopStartMarkerIndicator = function(self)
				if not self.soundObject then return end
				
				local progress = self.soundObject:getLoopStartPoint() / self.soundObject:getSampleCount()
				local markerX = self.lineStartX + (progress * self.lineWidth)
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.setLineWidth(1)
				
				local dotRadius = 1
				local colonOffset = -2
				love.graphics.circle("fill", markerX + colonOffset, self.y - 2, dotRadius)
				love.graphics.circle("fill", markerX + colonOffset, self.y + 2, dotRadius)
				
				local lineHeight = 4
				local lineOffset = -5
				love.graphics.line(markerX + lineOffset, self.y - lineHeight, markerX + lineOffset, self.y + lineHeight)
				love.graphics.line(markerX + lineOffset - 2, self.y - lineHeight, markerX + lineOffset - 2, self.y + lineHeight)
			end,
			
			drawLoopEndMarkerIndicator = function(self)
				if not self.soundObject then return end
				
				local progress = self.soundObject:getLoopEndPoint() / self.soundObject:getSampleCount()
				local markerX = self.lineStartX + (progress * self.lineWidth)
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.setLineWidth(1)
				
				local dotRadius = 1
				local colonOffset = -3
				love.graphics.circle("fill", markerX + colonOffset, self.y - 2, dotRadius)
				love.graphics.circle("fill", markerX + colonOffset, self.y + 2, dotRadius)
				
				local lineHeight = 4
				love.graphics.line(markerX, self.y - lineHeight, markerX, self.y + lineHeight)
				love.graphics.line(markerX + 2, self.y - lineHeight, markerX + 2, self.y + lineHeight)
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
				
				local duration = self.soundObject:getDuration()
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
				local duration = self.soundObject:getDuration()
				local newTime = progress * duration
				self.soundObject.audioSource:seek(newTime, "seconds")
				
				-- Notify that position changed
				if self.onPositionChanged then
					self.onPositionChanged()
				end
			end,
			
			update = function(self, dt)
				-- Handle thumb dragging
				if self.isDragging then
					local mx, my = love.mouse.getPosition()
					self:handleMouseDragged(mx, my)
				end
			end,
		}):init()
	end,
}
