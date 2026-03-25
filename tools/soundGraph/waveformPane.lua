return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 1280,
			height = params.height or 512,
			graphics = require("tools/lib/graphics"):create(),
			soundObject = nil,
			soundModel = nil,
			samplingRate = params.samplingRate or 64,
			marginLeft = params.marginLeft or 100,
			followPlaybackCursor = false,
			currentSample = nil,
			scaleInitialized = false,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
			end,
			
			refresh = function(self, soundObject, samplingRate, marginLeft)
				self.soundObject = soundObject
				self.samplingRate = samplingRate or self.samplingRate
				self.marginLeft = marginLeft or self.marginLeft
				self.scaleInitialized = false
			end,
			
			initializeScale = function(self, minOptimumScale)
				if not self.scaleInitialized and minOptimumScale then
					self.graphics:setScale(minOptimumScale)
					self:moveImage(self.marginLeft / self.graphics:getScale(), 0)
					self.scaleInitialized = true
				end
			end,
			
			draw = function(self)
				self:drawWaveform()
				self:drawPlaybackCursor()
				self:drawMouseCursor()
			end,
			
			drawWaveform = function(self)
				if not self.soundModel or self.soundModel:getSampleCount() == 0 then return end
				
				love.graphics.setLineWidth(1)
				
				-- Convert screen bounds to image coordinates
				local leftmostImageX, _ = self:screenToImageCoordinates(0, 0)
				local rightmostImageX, _ = self:screenToImageCoordinates(self.width, 0)
				
				-- Convert image coordinates to sample array indices (1-based)
				local sampleCount = self.soundModel:getSampleCount()
				local startSample = math.max(1, math.floor(leftmostImageX - self.marginLeft + 1))
				local endSample = math.min(sampleCount - 1, math.ceil(rightmostImageX - self.marginLeft + 1))
				
				-- Calculate sample skip for performance when zoomed out
				local currentScale = self.graphics:getScale()
				local sampleStep = 1
				local minOptimumScale = self.soundModel:getMinOptimumScale()
				if minOptimumScale and currentScale < minOptimumScale then
					sampleStep = math.max(1, math.floor(minOptimumScale / currentScale))
				end
				
				-- Draw all channels
				self:drawChannel(1, startSample, endSample, sampleStep)
				if self.soundModel:getChannelCount() > 1 then
					self:drawChannel(2, startSample, endSample, sampleStep)
				end
			end,
			
			drawChannel = function(self, channelNumber, startSample, endSample, sampleStep)
				if not self.soundObject then return end
				
				-- Get start and end points in per-channel sample space
				local channelCount = self.soundObject:getChannelCount()
				local startPointPerChannel = self.soundObject:getStartPoint() / channelCount
				local endPointPerChannel = self.soundObject:getEndPoint() / channelCount
				
				for k = startSample, endSample, sampleStep do
					local sample1 = self.soundModel:getSample(k, channelNumber)
					local sample2 = self.soundModel:getSample(k + 1, channelNumber)
					if sample1 and sample2 then
						-- Check if we're in the active range
						local samplePos = k - 1  -- Convert to 0-based for comparison
						if samplePos >= startPointPerChannel and samplePos <= endPointPerChannel then
							love.graphics.setColor(1, 1, 1)  -- White for active range
						else
							love.graphics.setColor(0.5, 0.5, 0.5)  -- Gray for inactive range
						end
						
						local imageX1 = self.marginLeft + k - 1
						local imageX2 = self.marginLeft + k
						local screenX1, _ = self:imageToScreenCoordinates(imageX1, 0)
						local screenX2, _ = self:imageToScreenCoordinates(imageX2, 0)
						
						local y1 = 256 - sample1
						local y2 = 256 - sample2
						
						love.graphics.line(screenX1, y1, screenX2, y2)
					end
				end
			end,
			
			drawPlaybackCursor = function(self)
				if not self.soundObject then return end
				
				if self.currentSample then
					local imageX = self.marginLeft + self.currentSample
					local screenX, _ = self:imageToScreenCoordinates(imageX, 0)
					love.graphics.setColor(1, 1, 0)
					love.graphics.setLineWidth(3)
					love.graphics.line(screenX, 0, screenX, self.height)
					love.graphics.setLineWidth(1)
				end
			end,
			
			drawMouseCursor = function(self)
				if not self.soundObject or not self.soundModel or self.soundModel:getSampleCount() == 0 then return end
				if self.followPlaybackCursor and self.soundObject:isPlaying() then return end
				
				love.graphics.setColor(0, 1, 0)
				local mx = self:getConstrainedMouseX()
				love.graphics.line(mx, 0, mx, self.height)
			end,
			
			updateCurrentSample = function(self)
				if self.soundModel then
					self.currentSample = self.soundModel:getCurrentSample()
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
			
			getConstrainedMouseX = function(self)
				if not self.soundModel then return 0 end
				local mx, _ = love.mouse.getPosition()
				local leftmostScreenX, _ = self:imageToScreenCoordinates(self.marginLeft, 0)
				local rightmostScreenX, _ = self:imageToScreenCoordinates(self.marginLeft + self.soundModel:getSampleCount(), 0)
				return math.min(math.max(mx, leftmostScreenX), rightmostScreenX)
			end,
			
			getSampleXFromMouseX = function(self)
				if not self.soundObject or not self.soundModel then return 0 end
				
				local mx, my = love.mouse.getPosition()
				local imageX, _ = self:screenToImageCoordinates(mx, my)
				local perChannelSampleIndex = math.floor(imageX - self.marginLeft)
				perChannelSampleIndex = math.max(0, math.min(perChannelSampleIndex, self.soundModel:getSampleCount() - 1))
				
				-- Convert from per-channel space to total sample space
				return self.soundModel:totalSampleFromPerChannelSample(perChannelSampleIndex)
			end,
			
			---------------------- Graphics Object Methods ------------------------
			
			moveImage = function(self, deltaX, deltaY)
				if not self.soundModel or self.soundModel:getSampleCount() == 0 then return end
				
				self.graphics:moveImage(deltaX, deltaY)
				
				-- Constrain left scrolling
				local currentX = self.graphics:getX()
				if currentX > (self.marginLeft / self.graphics:getScale()) then
					self.graphics:setX(self.marginLeft / self.graphics:getScale())
				end
				
				-- Constrain right scrolling
				local rightmostImageX = self.marginLeft + self.soundModel:getSampleCount()
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
				if not self.soundModel then return end
				local minScale = self.soundModel:getMinScale()
				if not minScale then return end
				
				self.graphics:adjustScaleGeometrically(deltaScale * 2)
				if self.graphics:getScale() > 10 then
					self.graphics:setScale(10)
				elseif self.graphics:getScale() < minScale then
					self.graphics:setScale(minScale)
				end
			end,
			
			syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
				self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
			end,
			
			getLeftScreenBound = function(self)
				if not self.soundModel then return 0 end
				local leftImageX = self.marginLeft
				local leftScreenX, _ = self:imageToScreenCoordinates(leftImageX, 0)
				return leftScreenX
			end,
			
			getRightScreenBound = function(self)
				if not self.soundModel then return 0 end
				local rightImageX = self.marginLeft + self.soundModel:getSampleCount()
				local rightScreenX, _ = self:imageToScreenCoordinates(rightImageX, 0)
				return rightScreenX
			end,
			
			init = function(self)
				return self
			end,
		}):init()
	end,
}
