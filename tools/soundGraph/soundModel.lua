return {
	create = function(self, soundObject)
		return {
			soundObject = soundObject,
			sampleData = {},
			sampleDataChannel2 = {},
			channelCount = soundObject:getChannelCount(),
			analysisProgress = 0,
			analysisCoroutine = nil,
			minScale = nil,
			minOptimumScale = nil,
			
			analyzeData = function(self)
				if not self.soundObject then return end
				
				local NUM_SAMPLES = self.soundObject:getSampleCount()
				local CHANNEL_COUNT = self.soundObject:getChannelCount()
				local TOTAL_SAMPLES = NUM_SAMPLES * CHANNEL_COUNT
				local CHUNK_SIZE = 100000
				
				self.channelCount = CHANNEL_COUNT
				
				-- First pass: find maximum absolute amplitude (check all channels)
				local maxAmplitude = 0
				for i = 0, TOTAL_SAMPLES - 1 do
					local sample = math.abs(self.soundObject:getSample(i))
					if sample > maxAmplitude then
						maxAmplitude = sample
					end
					
					if i % CHUNK_SIZE == 0 then
						self.analysisProgress = (i / TOTAL_SAMPLES) * 0.5
						coroutine.yield()
					end
				end
		
				-- Calculate scale factor to fit waveform on screen
				local amplitudeScale = maxAmplitude > 0 and (256 / maxAmplitude) or 512
		
				-- Second pass: scale and store samples by channel
				for i = 0, TOTAL_SAMPLES - 1 do
					local currentSample = self.soundObject:getSample(i) * amplitudeScale
					
					if CHANNEL_COUNT == 1 then
						table.insert(self.sampleData, currentSample)
					elseif i % CHANNEL_COUNT == 0 then
						table.insert(self.sampleData, currentSample)
					else
						table.insert(self.sampleDataChannel2, currentSample)
					end
					
					if i % CHUNK_SIZE == 0 then
						self.analysisProgress = 0.5 + (i / TOTAL_SAMPLES) * 0.5
						coroutine.yield()
					end
				end
		
				-- Calculate minimum scales
				self.minScale = 1024 / #self.sampleData
				local NUM_SAMPLES_IN_1_SECOND = 44100
				self.minOptimumScale = 1024 / NUM_SAMPLES_IN_1_SECOND
				
				self.analysisProgress = 1
			end,
			
			startAnalysis = function(self)
				self.sampleData = {}
				self.sampleDataChannel2 = {}
				self.analysisProgress = 0
				self.analysisCoroutine = coroutine.create(function() self:analyzeData() end)
			end,
			
			updateAnalysis = function(self)
				if self.analysisCoroutine and coroutine.status(self.analysisCoroutine) ~= "dead" then
					local success, err = coroutine.resume(self.analysisCoroutine)
					if not success then
						print("Error in analysis coroutine: " .. tostring(err))
					end
				end
			end,
			
			getProgress = function(self)
				return self.analysisProgress
			end,
			
			isAnalysisComplete = function(self)
				return self.analysisProgress >= 1
			end,
			
			getSampleCount = function(self)
				return #self.sampleData
			end,
			
			getSample = function(self, index, channel)
				channel = channel or 1
				if channel == 1 then
					return self.sampleData[index]
				else
					return self.sampleDataChannel2[index]
				end
			end,
			
			getChannelCount = function(self)
				return self.channelCount
			end,
			
			getMinScale = function(self)
				return self.minScale
			end,
			
			getMinOptimumScale = function(self)
				return self.minOptimumScale
			end,
			
			getCurrentSample = function(self)
				local totalSample = self.soundObject:getCurrentSample()
				return math.floor(totalSample / self.channelCount)
			end,
			
			totalSampleFromPerChannelSample = function(self, perChannelSample)
				return perChannelSample * self.channelCount
			end,
		}
	end,
}
