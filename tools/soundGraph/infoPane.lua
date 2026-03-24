return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 512,
			width = params.width or 1280,
			height = params.height or 200,
			soundObject = nil,
			soundModel = nil,
			font = love.graphics.newFont(16),
			timelineScrubber = nil,
			onPositionChanged = params.onPositionChanged,
			markerPane = params.markerPane,
			
			init = function(self)
				self.timelineScrubber = require("tools/soundGraph/timelineScrubber"):create {
					x = self.x,
					y = self.y + 170,
					width = self.width,
					margin = 40,
					thumbWidth = 12,
					thumbHeight = 20,
					onPositionChanged = self.onPositionChanged,
					markerPane = self.markerPane,
				}
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
				self.timelineScrubber:setSoundObject(soundObject)
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
				self.timelineScrubber:setSoundModel(soundModel)
			end,
			
			draw = function(self)
				love.graphics.setFont(self.font)
				self:drawBackground()
				self:drawBorder()
				self:drawInfoText()
				self.timelineScrubber:draw()
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
			
			handleMousePressed = function(self, mx, my)
				return self.timelineScrubber:handleMousePressed(mx, my)
			end,
			
			handleMouseReleased = function(self)
				self.timelineScrubber:handleMouseReleased()
			end,
			
			handleMouseDragged = function(self, mx, my)
				self.timelineScrubber:handleMouseDragged(mx, my)
			end,
			
			update = function(self, dt)
				-- Future: could add animations or other updates here
			end,
		}):init()
	end,
}
