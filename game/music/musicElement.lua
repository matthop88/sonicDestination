local BASE_PATH = relativePath("resources/music/")

local findByLabelOrKey = function(musicData, labelOrKey)
	for k, v in pairs(musicData) do
		if v.label == labelOrKey or k == labelOrKey then
			return v
		end
	end
end

return {
	create = function(self, musicData, labelOrKey)

		local musicInfo = findByLabelOrKey(musicData, labelOrKey)
		local musicPath = BASE_PATH .. musicInfo.filename
		
		return ({
			musicInfo      = musicInfo,
			musicPath      = musicPath,
			volume         = musicInfo.volume         or 0.5,
			volumeScalar   = 1,
			startPoint     = musicInfo.startPoint     or 0,
			endPoint       = nil,
			loopStartPoint = musicInfo.loopStartPoint or 0,
			loopEndPoint   = nil,  
			musicData      = love.sound.newSoundData(musicPath),
			audioSource    = nil,
			delay          = 0,
			
			init = function(self)
				self.audioSource = love.audio.newSource(self.musicData)
				
				self.audioSource:setVolume(self.volume)
				self.endPoint     = self.musicInfo.endPoint     or (self:getSampleCount() - 1)
				self.loopEndPoint = self.musicInfo.loopEndPoint or (self:getSampleCount() - 1)

				return self
			end,

			getSampleCount = function(self)
				return self.musicData:getSampleCount() * self:getChannelCount()
			end,

			getChannelCount = function(self)
				return self.musicData:getChannelCount()
			end,

			getSampleRate = function(self)
				return self.musicData:getSampleRate()
			end,

			getCurrentSample = function(self)
				local timeInSeconds = self.audioSource:tell("seconds")
				return math.floor(timeInSeconds * self:getSampleRate() * self:getChannelCount())
			end,

			isPlaying = function(self)
				return self.audioSource:isPlaying()
			end,

			jumpToSample = function(self, sample)
				local timeInSeconds = sample / (self:getSampleRate() * self:getChannelCount())
				self.audioSource:seek(timeInSeconds, "seconds")
			end,
			
			jumpToBeginning = function(self)
				self:jumpToSample(self.startPoint)
			end,
			
			jumpToEnd = function(self)
				self:jumpToSample(self.endPoint)
				self:pause()
			end,

			play = function(self)
				if self.delay == 0 then
					self.audioSource:play()
					self.playTimer = nil
				else
					self.playTimer = 0
				end
			end,
			
			stop = function(self)
				self.audioSource:stop()
				self.playTimer = nil
			end,
			
			pause = function(self)
				self.audioSource:pause()
				self.playTimer = nil
			end,

			checkEndpointReached = function(self)
				if self:isPlaying() then
					local currentSample = self:getCurrentSample()
					return currentSample >= self.endPoint
				end
				return false
			end,
			
			checkLoopEndReached = function(self)
				if self:isPlaying() then
					local currentSample = self:getCurrentSample()
					return currentSample >= self.loopEndPoint
				end
				return false
			end,
			
			initiateLoop = function(self)
				local currentSample = self:getCurrentSample()
				local delta = currentSample - self.loopEndPoint
				local targetSample = self.loopStartPoint + delta
				self:jumpToSample(targetSample)
			end,
			
			update = function(self, dt)
				if self.playTimer then 
					self.playTimer = self.playTimer + dt
					if self.playTimer >= self.delay then
						self.audioSource:play()
						self.playTimer = nil
					end
				end
				if self:checkLoopEndReached() then
					self:initiateLoop()
				elseif self:checkEndpointReached() then
					self:jumpToEnd()
				end
			end,
			
			getVolume = function(self)
				local volume = self.volume
				if self.volumeFn then volume = self.volumeFn() end
				return volume
			end,

			setVolume = function(self, volume)
				self.volume = volume
				self:refreshVolume()
			end,

			setVolumeFn = function(self, volumeFn)
				self.volumeFn = volumeFn
				self:refreshVolume()
			end,

			setVolumeScalar = function(self, volumeScalar)
				self.volumeScalar = volumeScalar
				self:refreshVolume()
			end,

			refreshVolume = function(self)
				self.audioSource:setVolume(self:getVolume() * self.volumeScalar)
			end,
			
			setPitch = function(self, pitch)
				self.audioSource:setPitch(pitch)
			end,

			setDelay = function(self, delay)
				self.delay = delay
			end,
	
		}):init()
	end,
}
