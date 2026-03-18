return {
	create = function(self, params)
		return {
			x = params.x or 0,
			y = params.y or 512,
			width = params.width or 1280,
			height = params.height or 200,
			soundObject = nil,
			soundModel = nil,
			font = love.graphics.newFont(16),
			
			-- Timeline scrubber
			timelineY = (params.y or 512) + 170,
			timelineMargin = 40,
			thumbWidth = 12,
			thumbHeight = 20,
			isDraggingThumb = false,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
			end,
			
			draw = function(self)
				love.graphics.setFont(self.font)
				self:drawBackground()
				self:drawBorder()
				self:drawInfoText()
				self:drawTimeline()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(0.15, 0.15, 0.15)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			end,
			
			drawBorder = function(self)
				love.graphics.setColor(0.5, 0.5, 0.5)
				love.graphics.setLineWidth(2)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
				love.graphics.setLineWidth(1)
			end,
			
			drawInfoText = function(self)
				if not self.soundObject or not self.soundModel then return end
				
				love.graphics.setColor(1, 1, 1)
				local textX = self.x + 20
				local textY = self.y + 20
				local lineHeight = 25
				
				self:drawSampleRate(textX, textY)
				textY = textY + lineHeight
				
				self:drawChannelCount(textX, textY)
				textY = textY + lineHeight
				
				self:drawTotalSamples(textX, textY)
				textY = textY + lineHeight
				
				self:drawDuration(textX, textY)
				textY = textY + lineHeight
				
				self:drawCurrentPosition(textX, textY)
			end,
			
			drawSampleRate = function(self, textX, textY)
				local sampleRate = self.soundObject:getSampleRate()
				love.graphics.print("Sample Rate: " .. sampleRate .. " Hz", textX, textY)
			end,
			
			drawChannelCount = function(self, textX, textY)
				local channels = self.soundModel:getChannelCount()
				local channelText = channels == 1 and "Mono" or (channels == 2 and "Stereo" or channels .. " Channels")
				love.graphics.print("Channels: " .. channelText, textX, textY)
			end,
			
			drawTotalSamples = function(self, textX, textY)
				local totalSamples = self.soundObject:getSampleCount()
				love.graphics.print("Total Samples: " .. totalSamples, textX, textY)
			end,
			
			drawDuration = function(self, textX, textY)
				local sampleRate = self.soundObject:getSampleRate()
				local totalSamples = self.soundObject:getSampleCount()
				local duration = totalSamples / sampleRate
				love.graphics.print("Duration: " .. self:formatTime(duration), textX, textY)
			end,
			
			drawCurrentPosition = function(self, textX, textY)
				if self.soundObject:isPlaying() or self.soundObject:getCurrentSample() > 0 then
					local currentTime = self.soundObject.audioSource:tell("seconds")
					local currentMinutes = math.floor(currentTime / 60)
					local currentSeconds = currentTime % 60
					love.graphics.print(string.format("Current Position: %d:%06.3f", currentMinutes, currentSeconds), textX, textY)
				end
			end,
			
			formatTime = function(self, timeInSeconds)
				local minutes = math.floor(timeInSeconds / 60)
				local seconds = timeInSeconds % 60
				
				if timeInSeconds < 10 then
					-- Show milliseconds for times under 10 seconds
					return string.format("%d:%06.3f", minutes, seconds)
				else
					-- Regular format for 10 seconds and above
					return string.format("%d:%05.2f", minutes, seconds)
				end
			end,
			
			drawTimeline = function(self)
				if not self.soundObject or not self.soundModel then return end
				
				-- Draw green timeline line
				local lineStartX = self.x + self.timelineMargin
				local lineEndX = self.x + self.width - self.timelineMargin
				love.graphics.setColor(0, 1, 0)
				love.graphics.setLineWidth(2)
				love.graphics.line(lineStartX, self.timelineY, lineEndX, self.timelineY)
				love.graphics.setLineWidth(1)
				
				-- Calculate thumb position based on current playback position
				local duration = self.soundObject:getSampleCount() / self.soundObject:getSampleRate()
				local currentTime = self.soundObject.audioSource:tell("seconds")
				local progress = duration > 0 and (currentTime / duration) or 0
				local lineWidth = lineEndX - lineStartX
				local thumbX = lineStartX + (progress * lineWidth)
				
				-- Draw white thumb
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", 
					thumbX - self.thumbWidth / 2, 
					self.timelineY - self.thumbHeight / 2,
					self.thumbWidth,
					self.thumbHeight)
			end,
			
			getThumbPosition = function(self)
				if not self.soundObject or not self.soundModel then return 0 end
				
				local lineStartX = self.x + self.timelineMargin
				local lineEndX = self.x + self.width - self.timelineMargin
				local duration = self.soundObject:getSampleCount() / self.soundObject:getSampleRate()
				local currentTime = self.soundObject.audioSource:tell("seconds")
				local progress = duration > 0 and (currentTime / duration) or 0
				local lineWidth = lineEndX - lineStartX
				
				return lineStartX + (progress * lineWidth)
			end,
			
			isMouseOverThumb = function(self, mx, my)
				if not self.soundObject or not self.soundModel then return false end
				
				local thumbX = self:getThumbPosition()
				local thumbLeft = thumbX - self.thumbWidth / 2
				local thumbRight = thumbX + self.thumbWidth / 2
				local thumbTop = self.timelineY - self.thumbHeight / 2
				local thumbBottom = self.timelineY + self.thumbHeight / 2
				
				return mx >= thumbLeft and mx <= thumbRight and my >= thumbTop and my <= thumbBottom
			end,
			
			handleMousePressed = function(self, mx, my)
				if self:isMouseOverThumb(mx, my) then
					self.isDraggingThumb = true
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.isDraggingThumb = false
			end,
			
			handleMouseDragged = function(self, mx, my)
				if not self.isDraggingThumb or not self.soundObject or not self.soundModel then return end
				
				-- Calculate new position based on mouse X
				local lineStartX = self.x + self.timelineMargin
				local lineEndX = self.x + self.width - self.timelineMargin
				local lineWidth = lineEndX - lineStartX
				
				-- Clamp mouse position to timeline bounds
				local clampedX = math.max(lineStartX, math.min(mx, lineEndX))
				local progress = (clampedX - lineStartX) / lineWidth
				
				-- Set audio position
				local duration = self.soundObject:getSampleCount() / self.soundObject:getSampleRate()
				local newTime = progress * duration
				self.soundObject.audioSource:seek(newTime, "seconds")
			end,
			
			update = function(self, dt)
				-- Future: could add animations or other updates here
			end,
		}
	end,
}
