return {
	create = function(self, soundFilePath)
		return {
			soundData = love.sound.newSoundData(soundFilePath),
			audioSource = nil,

			init = function(self)
				self.audioSource = love.audio.newSource(self.soundData)
				return self
			end,

			getSampleCount = function(self)
				return self.soundData:getSampleCount()
			end,

			getSampleRate = function(self)
				return self.soundData:getSampleRate()
			end,

			getSample = function(self, index)
				return self.soundData:getSample(index)
			end,

			playFromSample = function(self, samplePosition)
				local timeInSeconds = samplePosition / self:getSampleRate()
				self.audioSource:seek(timeInSeconds, "seconds")
				self.audioSource:play()
			end,
			
			jumpToBeginning = function(self)
				self.audioSource:seek(0, "seconds")
			end,
			
			jumpToEnd = function(self)
				local lastSample = self:getSampleCount() - 1
				local timeInSeconds = lastSample / self:getSampleRate()
				self.audioSource:seek(timeInSeconds, "seconds")
			end,

			getCurrentSample = function(self)
				local timeInSeconds = self.audioSource:tell("seconds")
				return math.floor(timeInSeconds * self:getSampleRate())
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
