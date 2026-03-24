return {
	create = function(self, soundInfo)
		local basePath = soundInfo.isMusic and "game/resources/music/" or "game/resources/sounds/"
		local soundPath = basePath .. soundInfo.filename
		
		return {
			soundInfo = soundInfo,
			soundPath = soundPath,
			volume = soundInfo.volume or 0.5,
			startPoint = soundInfo.startPoint or 0,
			soundData = love.sound.newSoundData(soundPath),
			audioSource = nil,

			init = function(self)
				self.audioSource = love.audio.newSource(self.soundData)
				return self
			end,

			getSampleCount = function(self)
				return self.soundData:getSampleCount()
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
				local timeInSeconds = self.startPoint / self:getSampleRate()
				self.audioSource:seek(timeInSeconds, "seconds")
			end,
			
			jumpToEnd = function(self)
				local lastSample = self:getSampleCount() - 1
				local timeInSeconds = lastSample / self:getSampleRate()
				self.audioSource:seek(timeInSeconds, "seconds")
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
		}
	end,
}
