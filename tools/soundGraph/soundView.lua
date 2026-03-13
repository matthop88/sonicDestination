return {
	create = function(self, params)
		return {
			graphics = require("tools/lib/graphics"):create(),
			soundObject = params.soundObject,
			samplingRate = params.samplingRate or 64,
			marginLeft = params.marginLeft or 100,
			sampleData = {},

			analyzeData = function(self)
				if not self.soundObject then return end
				
				local NUM_SAMPLES = self.soundObject:getSampleCount()
		
				-- First pass: find maximum absolute amplitude
				local maxAmplitude = 0
				for i = 0, NUM_SAMPLES - 1 do
					local sample = math.abs(self.soundObject:getSample(i))
					if sample > maxAmplitude then
						maxAmplitude = sample
					end
				end
		
				-- Calculate scale factor to fit waveform on screen
				-- Screen height is 512, centered at 256, so max amplitude should map to 256
				local amplitudeScale = maxAmplitude > 0 and (256 / maxAmplitude) or 512
		
				-- Second pass: scale samples
				for i = 0, NUM_SAMPLES - 1 do
					local currentSample = self.soundObject:getSample(i) * amplitudeScale
					table.insert(self.sampleData, currentSample)
				end
		
				self.minScale = 1024 / NUM_SAMPLES
				self.graphics:setScale(self.minScale)
				self:moveImage(self.marginLeft / self.graphics:getScale(), 0)
			end,
		
			refresh = function(self, soundObject, samplingRate, marginLeft)
				self.soundObject = soundObject
				self.samplingRate = samplingRate or self.samplingRate
				self.marginLeft = marginLeft or self.marginLeft
				self.sampleData = {}
				self:analyzeData()
			end,
		
			drawWaveform = function(self)
				love.graphics.setLineWidth(1)
				love.graphics.setColor(1, 1, 1)
				for k = 1, #self.sampleData - 1 do
					local imageX1 = k
					local imageX2 = k + 1
					local screenX1, _ = self:imageToScreenCoordinates(imageX1, 0)
					local screenX2, _ = self:imageToScreenCoordinates(imageX2, 0)
					
					local y1 = 256 - self.sampleData[k]
					local y2 = 256 - self.sampleData[k + 1]
					
					love.graphics.line(screenX1, y1, screenX2, y2)
				end
			end,
	
			drawPlaybackCursor = function(self)
				if not self.soundObject then return end
				
				local currentSample = self.soundObject:getCurrentSample()
				if currentSample then
					local imageX = self.marginLeft + currentSample
					local screenX, _ = self:imageToScreenCoordinates(imageX, 0)
					love.graphics.setColor(1, 1, 0)
					love.graphics.setLineWidth(3)
					love.graphics.line(screenX, 0, screenX, 512)
					love.graphics.setLineWidth(1)
				end
			end,
	
			drawMouseCursor = function(self)
				if not self.soundObject or #self.sampleData == 0 then return end
				
				love.graphics.setColor(0, 1, 0)
				local mx = self:getConstrainedMouseX()
				love.graphics.line(mx, 0, mx, 512)
			end,
	
			draw = function(self)
				self:drawWaveform()
				self:drawPlaybackCursor()
				self:drawMouseCursor()
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
				if self.graphics:getScale() > 1 then
					self.graphics:setScale(1)
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
