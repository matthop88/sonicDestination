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
				local textX2 = self.x + 400  -- Second column
				local textY = self.y + 20
				local lineHeight = 25
				
				self:drawSampleRate(textX, textY)
				textY = textY + lineHeight
				
				self:drawChannelCount(textX, textY)
				self:drawStartPoint(textX2, textY)
				textY = textY + lineHeight
				
				self:drawTotalSamples(textX, textY)
				self:drawEndPoint(textX2, textY)
				textY = textY + lineHeight
				
				self:drawDuration(textX, textY)
				self:drawLoopStartPoint(textX2, textY)
				textY = textY + lineHeight
				
				self:drawLoopEndPoint(textX2, textY)
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
			
			drawStartPoint = function(self, textX, textY)
				local startPoint = self.soundObject:getStartPoint()
				love.graphics.print("Start Point: " .. startPoint, textX, textY)
			end,
			
			drawEndPoint = function(self, textX, textY)
				local endPoint = self.soundObject:getEndPoint()
				love.graphics.print("End Point: " .. endPoint, textX, textY)
			end,
			
			drawLoopStartPoint = function(self, textX, textY)
				local loopStartPoint = self.soundObject:getLoopStartPoint()
				love.graphics.print("Loop Start: " .. loopStartPoint, textX, textY)
			end,
			
			drawLoopEndPoint = function(self, textX, textY)
				local loopEndPoint = self.soundObject:getLoopEndPoint()
				love.graphics.print("Loop End: " .. loopEndPoint, textX, textY)
			end,
			
			drawTotalSamples = function(self, textX, textY)
				local startPoint = self.soundObject:getStartPoint()
				local endPoint = self.soundObject:getEndPoint()
				local activeSamples = endPoint - startPoint + 1
				love.graphics.print("Total Samples: " .. activeSamples, textX, textY)
			end,
			
			drawDuration = function(self, textX, textY)
				local startPoint = self.soundObject:getStartPoint()
				local endPoint = self.soundObject:getEndPoint()
				local activeSamples = endPoint - startPoint + 1
				local sampleRate = self.soundObject:getSampleRate()
				local channelCount = self.soundObject:getChannelCount()
				local activeDuration = activeSamples / (sampleRate * channelCount)
				love.graphics.print("Duration: " .. self:formatTime(activeDuration), textX, textY)
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
		}
	end,
}
