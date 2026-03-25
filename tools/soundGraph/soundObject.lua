return {
	create = function(self, soundInfo)
		local basePath = soundInfo.isMusic and "game/resources/music/" or "game/resources/sounds/"
		local soundPath = basePath .. soundInfo.filename
		
		return {
			soundInfo = soundInfo,
			soundPath = soundPath,
			volume = soundInfo.volume or 0.5,
			startPoint = soundInfo.startPoint or 0,
			endPoint = nil,  -- Set in init() to default to last sample
			soundData = love.sound.newSoundData(soundPath),
			audioSource = nil,

			init = function(self)
				self.audioSource = love.audio.newSource(self.soundData)
				-- Cache duration calculation
				self.duration = self:getPerChannelSampleCount() / self:getSampleRate()
				-- Set endPoint in total sample space
				self.endPoint = soundInfo.endPoint or (self:getSampleCount() - 1)
				return self
			end,

			getPerChannelSampleCount = function(self)
				-- LOVE2D's soundData:getSampleCount() is poorly named - it returns the number
				-- of samples per channel (frames), not the total number of interleaved samples
				return self.soundData:getSampleCount()
			end,
			
			getSampleCount = function(self)
				return self:getPerChannelSampleCount() * self:getChannelCount()
			end,
			
			getDuration = function(self)
				return self.duration
			end,
			
			getChannelCount = function(self)
				return self.soundData:getChannelCount()
			end,

			getSampleRate = function(self)
				return self.soundData:getSampleRate()
			end,

			getSample = function(self, index)
				return self.soundData:getSample(index)
			end,

			playFromSample = function(self, samplePosition)
				local timeInSeconds = samplePosition / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
				self.audioSource:play()
			end,
			
			jumpToBeginning = function(self)
				local timeInSeconds = self.startPoint / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
			end,
			
			jumpToEnd = function(self)
				local timeInSeconds = self.endPoint / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
				self:pause()
			end,

			getCurrentSample = function(self)
				local timeInSeconds = self.audioSource:tell("seconds")
				return math.floor(timeInSeconds * self:getSampleRate() * self:getChannelCount())
			end,

			stop = function(self)
				self.audioSource:stop()
			end,
			
			pause = function(self)
				self.audioSource:pause()
			end,

			isPlaying = function(self)
				return self.audioSource:isPlaying()
			end,
			
			checkEndpointReached = function(self)
				if self:isPlaying() then
					local currentSample = self:getCurrentSample()
					return currentSample >= self.endPoint
				end
				return false
			end,
			
			jumpToEnd = function(self)
				local timeInSeconds = self.endPoint / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
				self:pause()
			end,
			
			getStartPoint = function(self)
				return self.startPoint
			end,
			
			setStartPoint = function(self, value)
				self.startPoint = value
			end,
			
			getEndPoint = function(self)
				return self.endPoint
			end,
			
			setEndPoint = function(self, value)
				self.endPoint = value
			end,
		}
	end,
}
