return {
	create = function(self, params)
		return {
			graphics = require("tools/lib/graphics"):create(),
			soundObject = params.soundObject,
			samplingRate = params.samplingRate or 64,
			marginLeft = params.marginLeft or 100,
			sampleData = {},
			followPlaybackCursor = false,
			currentSample = nil,
			analysisProgress = 1,  -- 0 to 1, 1 means complete
			analysisCoroutine = nil,

			analyzeData = function(self)
				if not self.soundObject then return end
				
				local NUM_SAMPLES = self.soundObject:getSampleCount()
				local CHUNK_SIZE = 100000  -- Process this many samples per frame
				
				print("Starting analysis of " .. NUM_SAMPLES .. " samples")
				
				-- First pass: find maximum absolute amplitude
				local maxAmplitude = 0
				for i = 0, NUM_SAMPLES - 1 do
					local sample = math.abs(self.soundObject:getSample(i))
					if sample > maxAmplitude then
						maxAmplitude = sample
					end
					
					-- Yield every CHUNK_SIZE samples to update progress
					if i % CHUNK_SIZE == 0 then
						self.analysisProgress = (i / NUM_SAMPLES) * 0.5  -- First pass is 0-50%
						coroutine.yield()
					end
				end
				
				print("First pass complete, maxAmplitude: " .. maxAmplitude)
		
				-- Calculate scale factor to fit waveform on screen
				-- Screen height is 512, centered at 256, so max amplitude should map to 256
				local amplitudeScale = maxAmplitude > 0 and (256 / maxAmplitude) or 512
		
				-- Second pass: scale samples
				for i = 0, NUM_SAMPLES - 1 do
					local currentSample = self.soundObject:getSample(i) * amplitudeScale
					table.insert(self.sampleData, currentSample)
					
					-- Yield every CHUNK_SIZE samples to update progress
					if i % CHUNK_SIZE == 0 then
						self.analysisProgress = 0.5 + (i / NUM_SAMPLES) * 0.5  -- Second pass is 50-100%
						coroutine.yield()
					end
				end
				
				print("Second pass complete")
		
				-- Calculate minimum scale with limit for large files
				-- 2 seconds of music at 44100 Hz = 88200 samples per channel
				local NUM_SAMPLES_IN_2_SECONDS = 2 * 44100
				self.minScale = math.max(1024 / NUM_SAMPLES, 1024 / NUM_SAMPLES_IN_2_SECONDS)
				self.graphics:setScale(self.minScale)
				self:moveImage(self.marginLeft / self.graphics:getScale(), 0)
				
				self.analysisProgress = 1  -- Complete
				print("Analysis complete!")
			end,
		
			refresh = function(self, soundObject, samplingRate, marginLeft)
				self.soundObject = soundObject
				self.samplingRate = samplingRate or self.samplingRate
				self.marginLeft = marginLeft or self.marginLeft
				self.sampleData = {}
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
				love.graphics.setColor(1, 1, 1)
				
				-- Convert screen bounds to image coordinates
				local leftmostImageX, _ = self:screenToImageCoordinates(0, 0)
				local rightmostImageX, _ = self:screenToImageCoordinates(1280, 0)
				
				-- Convert image coordinates to sample array indices (1-based)
				-- Samples are positioned from marginLeft to marginLeft + #sampleData in image space
				local startSample = math.max(1, math.floor(leftmostImageX - self.marginLeft + 1))
				local endSample = math.min(#self.sampleData - 1, math.ceil(rightmostImageX - self.marginLeft + 1))
				
				-- Only draw visible samples
				for k = startSample, endSample do
					local imageX1 = self.marginLeft + k - 1
					local imageX2 = self.marginLeft + k
					local screenX1, _ = self:imageToScreenCoordinates(imageX1, 0)
					local screenX2, _ = self:imageToScreenCoordinates(imageX2, 0)
					
					local y1 = 256 - self.sampleData[k]
					local y2 = 256 - self.sampleData[k + 1]
					
					love.graphics.line(screenX1, y1, screenX2, y2)
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
				if self.followPlaybackCursor then return end
				
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
				
				if self.followPlaybackCursor and self.soundObject then
					if self.currentSample then
						local imageX = self.marginLeft + self.currentSample
						local screenX, _ = self:imageToScreenCoordinates(imageX, 0)
						
						-- Keep cursor centered on screen (640 is middle of 1280)
						if screenX ~= 640 then
							self:syncImageCoordinatesWithScreen(imageX, 0, 640, 0)
						end
					end
				end
			end,
			
			updateCurrentSample = function(self)
				if self.soundObject then
					self.currentSample = self.soundObject:getCurrentSample()
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
				local sampleIndex = math.floor(imageX - self.marginLeft)
				return math.max(0, math.min(sampleIndex, self.soundObject:getSampleCount() - 1))
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
