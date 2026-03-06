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

			stop = function(self)
				self.audioSource:stop()
			end,

			isPlaying = function(self)
				return self.audioSource:isPlaying()
			end,
		}
	end,
}
