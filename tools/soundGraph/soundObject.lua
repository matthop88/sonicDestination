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
			loopStartPoint = soundInfo.loopStartPoint or 0,
			loopEndPoint = nil,  -- Set in init() to default to last sample
			soundData = love.sound.newSoundData(soundPath),
			audioSource = nil,

			init = function(self)
				self.audioSource = love.audio.newSource(self.soundData)
				self.audioSource:setVolume(self.volume)
				-- Cache duration calculation
				self.duration = self:getPerChannelSampleCount() / self:getSampleRate()
				-- Set endPoint in total sample space
				self.endPoint = soundInfo.endPoint or (self:getSampleCount() - 1)
				-- Set loopEndPoint in total sample space
				self.loopEndPoint = soundInfo.loopEndPoint or (self:getSampleCount() - 1)
				-- Enforce all constraints on initial values
				self:enforceConstraints()
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
			
			isLoopingEnabled = function(self)
				return self.soundInfo and self.soundInfo.isMusic
			end,
			
			checkLoopEndReached = function(self)
				if self:isPlaying() and self:isLoopingEnabled() then
					local currentSample = self:getCurrentSample()
					return currentSample >= self.loopEndPoint
				end
				return false
			end,
			
			jumpToLoopStart = function(self)
				local timeInSeconds = self.loopStartPoint / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
			end,
			
			jumpToLoopStartWithDelta = function(self, currentSample)
				local delta = currentSample - self.loopEndPoint
				local targetSample = self.loopStartPoint + delta
				local timeInSeconds = targetSample / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
			end,
			
			update = function(self, dt)
				if self:checkLoopEndReached() then
					local currentSample = self:getCurrentSample()
					self:jumpToLoopStartWithDelta(currentSample)
				elseif self:checkEndpointReached() then
					self:jumpToEnd()
				end
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
			
			getLoopStartPoint = function(self)
				return self.loopStartPoint
			end,
			
			setLoopStartPoint = function(self, value)
				self.loopStartPoint = value
			end,
			
			getLoopEndPoint = function(self)
				return self.loopEndPoint
			end,
			
			setLoopEndPoint = function(self, value)
				self.loopEndPoint = value
			end,
			
			setVolume = function(self, volume)
				self.volume = volume
				self.audioSource:setVolume(volume)
			end,
			
			enforceConstraints = function(self)
				self.startPoint     = math.min(self.startPoint, self.endPoint)
				self.loopStartPoint = math.max(self.startPoint, math.min(self.loopStartPoint, self.endPoint))
				self.loopEndPoint   = math.max(self.startPoint, math.min(self.loopEndPoint, self.endPoint))
				self.loopStartPoint = math.min(self.loopStartPoint, self.loopEndPoint)
			end,
		}
	end,
}
