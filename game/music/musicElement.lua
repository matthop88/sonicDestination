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
			echoSource     = nil,
			echoDelay      = 0,
			echoStrength   = 1,
			
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
				local trackType = self.echoSource and "echo" or "main"
				print(string.format("[musicElement] play() called: type=%s, musicPath=%s", trackType, self.musicPath))
				
				if not self.echoSource then
					self:refreshVolume()
					self.audioSource:play()
				end
			end,
				
			stop = function(self)
				self.audioSource:stop()
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
				if self.echoSource and not self:isPlaying() then
					local sourceSample = self.echoSource:getCurrentSample()
					if sourceSample >= self.echoDelay then
						self:refreshVolume()
						local targetSample = sourceSample - self.echoDelay
						self:jumpToSample(targetSample)
						print(string.format("[musicElement] Echo starting at sample %d (source at %d, delay %d samples)", 
							targetSample, sourceSample, self.echoDelay))
						self.audioSource:play()
					end
				end
				
				if self:checkLoopEndReached() then
					self:initiateLoop()
				elseif self:checkEndpointReached() then
					self:jumpToEnd()
				end
			end,
					
			getVolume = function(self)
				if self.echoSource then
					return self.echoSource:getVolume() * self.echoStrength
				end
				local volume = self.volume
				if self.volumeFn then volume = self.volumeFn() end
				return volume
			end,
	
			setVolume = function(self, volume)
				print(string.format("[musicElement] setVolume called: volume=%.2f, has volumeFn=%s, musicPath=%s", 
					volume, tostring(self.volumeFn ~= nil), self.musicPath))
				self.volume = volume
				self:refreshVolume()
			end,
		
			setVolumeFn = function(self, volumeFn)
				self.volumeFn = volumeFn
				self:refreshVolume()
			end,
			
			setEchoSource = function(self, sourceTrack, delay, strength)
				self.echoSource = sourceTrack
				self.echoDelay = delay * 44100
				self.echoStrength = strength
				print(string.format("[musicElement] setEchoSource: delay=%.2f sec (%d samples), strength=%.2f", 
					delay, self.echoDelay, strength))
			end,
	
			setVolumeScalar = function(self, volumeScalar)
				print(string.format("[musicElement] setVolumeScalar called: scalar=%.2f, has volumeFn=%s, musicPath=%s", 
					volumeScalar, tostring(self.volumeFn ~= nil), self.musicPath))
				self.volumeScalar = volumeScalar
				self:refreshVolume()
			end,
		
			refreshVolume = function(self)
				local calculatedVolume = self:getVolume()
				local finalVolume = calculatedVolume * self.volumeScalar
				local echoInfo = self.echoSource and string.format("echo(sampleDelay=%d)", self.echoDelay) or "main"
				print(string.format("[musicElement] refreshVolume: %s, baseVolume=%.2f, calculatedVolume=%.2f, scalar=%.2f, finalVolume=%.2f", 
					echoInfo, self.volume, calculatedVolume, self.volumeScalar, finalVolume))
				self.audioSource:setVolume(finalVolume)
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
