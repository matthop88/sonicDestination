return {
	create = function(self, params)
		return {
			graphics = require("tools/lib/graphics"):create(),
			soundObject = params.soundObject,
			samplingRate = params.samplingRate or 64,
			marginLeft = params.marginLeft or 100,
			sampleData = {},
			sampleDataChannel2 = {},
			channelCount = 1,
			followPlaybackCursor = false,
			currentSample = nil,
			analysisProgress = 1,  -- 0 to 1, 1 means complete
			analysisCoroutine = nil,

			analyzeData = function(self)
				if not self.soundObject then return end
				
				local NUM_SAMPLES = self.soundObject:getSampleCount()
				local CHANNEL_COUNT = self.soundObject:getChannelCount()
				local TOTAL_SAMPLES = NUM_SAMPLES * CHANNEL_COUNT  -- Total interleaved samples
				local CHUNK_SIZE = 100000  -- Process this many samples per frame
				
				self.channelCount = CHANNEL_COUNT
				
				-- First pass: find maximum absolute amplitude (check all channels)
				local maxAmplitude = 0
				for i = 0, TOTAL_SAMPLES - 1 do
					local sample = math.abs(self.soundObject:getSample(i))
					if sample > maxAmplitude then
						maxAmplitude = sample
					end
					
					-- Yield every CHUNK_SIZE samples to update progress
					if i % CHUNK_SIZE == 0 then
						self.analysisProgress = (i / TOTAL_SAMPLES) * 0.5  -- First pass is 0-50%
						coroutine.yield()
					end
				end
		
				-- Calculate scale factor to fit waveform on screen
				-- Screen height is 512, centered at 256, so max amplitude should map to 256
				local amplitudeScale = maxAmplitude > 0 and (256 / maxAmplitude) or 512
		
				-- Second pass: scale and store samples by channel
				for i = 0, TOTAL_SAMPLES - 1 do
					local currentSample = self.soundObject:getSample(i) * amplitudeScale
					
					if CHANNEL_COUNT == 1 then
						-- Mono: store in sampleData
						table.insert(self.sampleData, currentSample)
					elseif i % CHANNEL_COUNT == 0 then
						-- Stereo/Multi: channel 1 (left)
						table.insert(self.sampleData, currentSample)
					else
						-- Stereo/Multi: other channels (e.g., right)
						table.insert(self.sampleDataChannel2, currentSample)
					end
					
					-- Yield every CHUNK_SIZE samples to update progress
					if i % CHUNK_SIZE == 0 then
						self.analysisProgress = 0.5 + (i / TOTAL_SAMPLES) * 0.5  -- Second pass is 50-100%
						coroutine.yield()
					end
				end
		
				-- Calculate minimum scale with limit for large files
				-- 1 second of music at 44100 Hz = 44100 samples per channel
				local NUM_SAMPLES_IN_1_SECOND = 44100
				self.minScale = math.max(1024 / #self.sampleData, 1024 / NUM_SAMPLES_IN_1_SECOND)
				self.graphics:setScale(self.minScale)
				self:moveImage(self.marginLeft / self.graphics:getScale(), 0)
				
				self.analysisProgress = 1  -- Complete
			end,
		
			refresh = function(self, soundObject, samplingRate, marginLeft)
				self.soundObject = soundObject
				self.samplingRate = samplingRate or self.samplingRate
				self.marginLeft = marginLeft or self.marginLeft
				self.sampleData = {}
				self.sampleDataChannel2 = {}
				self.channelCount = soundObject:getChannelCount()
				self.analysisProgress = 0
				self.analysisCoroutine = coroutine.create(function() self:analyzeData() end)
			end,
			
			getProgress = function(self)
				return self.analysisProgress
			end,
			
			isAnalysisComplete = function(self)
				return self.analysisProgress >= 1
			end,
		
			drawWaveform = function(self)
				if #self.sampleData == 0 then return end
				
				love.graphics.setLineWidth(1)
				
				-- Convert screen bounds to image coordinates
				local leftmostImageX, _ = self:screenToImageCoordinates(0, 0)
				local rightmostImageX, _ = self:screenToImageCoordinates(1280, 0)
				
				-- Convert image coordinates to sample array indices (1-based)
				-- Samples are positioned from marginLeft to marginLeft + #sampleData in image space
				local startSample = math.max(1, math.floor(leftmostImageX - self.marginLeft + 1))
				local endSample = math.min(#self.sampleData - 1, math.ceil(rightmostImageX - self.marginLeft + 1))
				
				-- Draw channel 1 (white)
				love.graphics.setColor(1, 1, 1)
				for k = startSample, endSample do
					local imageX1 = self.marginLeft + k - 1
					local imageX2 = self.marginLeft + k
					local screenX1, _ = self:imageToScreenCoordinates(imageX1, 0)
					local screenX2, _ = self:imageToScreenCoordinates(imageX2, 0)
					
					local y1 = 256 - self.sampleData[k]
					local y2 = 256 - self.sampleData[k + 1]
					
					love.graphics.line(screenX1, y1, screenX2, y2)
				end
				
				-- Draw channel 2 if stereo (white)
				if self.channelCount > 1 and #self.sampleDataChannel2 > 0 then
					love.graphics.setColor(1, 1, 1)
					for k = startSample, endSample do
						if self.sampleDataChannel2[k] and self.sampleDataChannel2[k + 1] then
							local imageX1 = self.marginLeft + k - 1
							local imageX2 = self.marginLeft + k
							local screenX1, _ = self:imageToScreenCoordinates(imageX1, 0)
							local screenX2, _ = self:imageToScreenCoordinates(imageX2, 0)
							
							local y1 = 256 - self.sampleDataChannel2[k]
							local y2 = 256 - self.sampleDataChannel2[k + 1]
							
							love.graphics.line(screenX1, y1, screenX2, y2)
						end
					end
				end
			end,
	
			draw = function(self)
				self:drawWaveform()
				self:drawPlaybackCursor()
				self:drawMouseCursor()
			end,
			
			drawPlaybackCursor = function(self)
				if not self.soundObject then return end
				
				if self.currentSample then
					local imageX = self.marginLeft + self.currentSample
					local screenX, _ = self:imageToScreenCoordinates(imageX, 0)
					love.graphics.setColor(1, 1, 0)
					love.graphics.setLineWidth(3)
					love.graphics.line(screenX, 0, screenX, 512)
					love.graphics.setLineWidth(1)
				end
			end,
	
			drawMouseCursor = function(self)
				if not self.soundObject or #self.sampleData == 0 then return end
				if self.followPlaybackCursor and self.soundObject:isPlaying() then return end
				
				love.graphics.setColor(0, 1, 0)
				local mx = self:getConstrainedMouseX()
				love.graphics.line(mx, 0, mx, 512)
			end,
			
			update = function(self, dt)
				-- Resume analysis coroutine if it exists and isn't finished
				if self.analysisCoroutine and coroutine.status(self.analysisCoroutine) ~= "dead" then
					local success, err = coroutine.resume(self.analysisCoroutine)
					if not success then
						print("Error in analysis coroutine: " .. tostring(err))
					end
				end
				
				self:updateCurrentSample()
				
				if self.followPlaybackCursor and self.soundObject and self.soundObject:isPlaying() then
					self:syncViewWithCurrentSample()
				end
			end,
			
			refreshView = function(self)
				self:updateCurrentSample()
				self:syncViewWithCurrentSample()
			end,
			
			syncViewWithCurrentSample = function(self)
				if self.currentSample then
					local imageX = self.marginLeft + self.currentSample
					local screenX, _ = self:imageToScreenCoordinates(imageX, 0)
					
					-- Keep cursor centered on screen (640 is middle of 1280)
					if screenX ~= 640 then
						self:syncImageCoordinatesWithScreen(imageX, 0, 640, 0)
					end
				end
			end,
			
			updateCurrentSample = function(self)
				if self.soundObject then
					local totalSample = self.soundObject:getCurrentSample()
					-- Convert from total sample space to per-channel space
					self.currentSample = math.floor(totalSample / self.channelCount)
				else
					self.currentSample = nil
				end
			end,
			
			setFollowPlaybackCursor = function(self, enabled)
				self.followPlaybackCursor = enabled
			end,
			
			toggleFollowPlaybackCursor = function(self)
				self.followPlaybackCursor = not self.followPlaybackCursor
				return self.followPlaybackCursor
			end,
	
			getConstrainedMouseX = function(self)
				local mx, _ = love.mouse.getPosition()
				local leftmostScreenX, _ = self:imageToScreenCoordinates(self.marginLeft, 0)
				local rightmostScreenX, _ = self:imageToScreenCoordinates(self.marginLeft + #self.sampleData, 0)
				return math.min(math.max(mx, leftmostScreenX), rightmostScreenX)
			end,
	
			getSampleXFromMouseX = function(self)
				if not self.soundObject then return 0 end
				
				local mx, my = love.mouse.getPosition()
				local imageX, _ = self:screenToImageCoordinates(mx, my)
				local perChannelSampleIndex = math.floor(imageX - self.marginLeft)
				perChannelSampleIndex = math.max(0, math.min(perChannelSampleIndex, #self.sampleData - 1))
				
				-- Convert from per-channel space to total sample space
				return perChannelSampleIndex * self.channelCount
			end,
	
			---------------------- Graphics Object Methods ------------------------
	
		    moveImage = function(self, deltaX, deltaY)
		        if #self.sampleData == 0 then return end
		        
		        self.graphics:moveImage(deltaX, deltaY)
		        
		        -- Constrain left scrolling
		        local currentX = self.graphics:getX()
		        if currentX > (self.marginLeft / self.graphics:getScale()) then
		            self.graphics:setX(self.marginLeft / self.graphics:getScale())
		        end
		        
		        -- Constrain right scrolling
		        local rightmostImageX = self.marginLeft + #self.sampleData
		        local rightmostScreenX, _ = self:imageToScreenCoordinates(rightmostImageX, 0)
		        if rightmostScreenX < 1124 then
					self:syncImageCoordinatesWithScreen(rightmostImageX, 0, 1124, 0)
		        end
		    end,
	
			screenToImageCoordinates = function(self, screenX, screenY)
				return self.graphics:screenToImageCoordinates(screenX, screenY)
			end,
	
			imageToScreenCoordinates = function(self, imageX, imageY)
				return self.graphics:imageToScreenCoordinates(imageX, imageY)
			end,
	
		    adjustScaleGeometrically = function(self, deltaScale)
				if not self.minScale then return end
		        
				self.graphics:adjustScaleGeometrically(deltaScale * 2)
				if self.graphics:getScale() > 10 then
					self.graphics:setScale(10)
				elseif self.graphics:getScale() < self.minScale then
					self.graphics:setScale(self.minScale)
				end
		    end,

		    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
		        self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
		    end,
		}
	end,
}
