local BASE_PATH = relativePath("resources/music/")

local findByTrackName = function(musicData, trackName)
	for k, v in pairs(musicData) do
		if v.label == trackName then
			return v
		end
	end
end

return {
	create = function(self, musicData, trackName)

		local musicInfo = findByTrackName(musicData, trackName)
		local musicPath = BASE_PATH .. musicInfo.filename
		
		return ({
			musicInfo      = musicInfo,
			musicPath      = musicPath,
			volume         = musicInfo.volume         or 0.5,
			startPoint     = musicInfo.startPoint     or 0,
			endPoint       = nil,
			loopStartPoint = musicInfo.loopStartPoint or 0,
			loopEndPoint   = nil,  
			musicData      = love.sound.newSoundData(musicPath),
			audioSource    = nil,

			init = function(self)
				self.audioSource = love.audio.newSource(self.musicData)
				
				self.audioSource:setVolume(self.volume)
				self.endPoint     = self.musicInfo.endPoint     or (self:getSampleCount() - 1)
				self.loopEndPoint = self.musicInfo.loopEndPoint or (self:getSampleCount() - 1)

				print("Loop End Point: ", self.loopEndPoint)
				print("Loop Start Point: ", self.loopStartPoint)
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
				self.audioSource:play()
			end,
			
			stop = function(self)
				self.audioSource:stop()
			end,
			
			pause = function(self)
				self.audioSource:pause()
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
				if self:checkLoopEndReached() then
					self:initiateLoop()
				elseif self:checkEndpointReached() then
					self:jumpToEnd()
				end
			end,
			
			setVolume = function(self, volume)
				self.volume = volume
				self.audioSource:setVolume(volume)
			end,
		
		}):init()
	end,
}
