return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 512,
			width = params.width or 1280,
			height = params.height or 64,
			soundObject = nil,
			soundModel = nil,
			soundView = params.soundView,
			
			-- Marker properties (stored in image coordinates)
			laneHeight = (params.height or 64) / 2,
			markerSize = 12,
			startMarkerImageX = nil,  -- Position in image coordinates
			endMarkerImageX = nil,    -- Position in image coordinates
			isDraggingStart = false,
			isDraggingEnd = false,
			onMarkerChanged = params.onMarkerChanged,
			
			init = function(self)
				self.topLaneY = self.y + self.laneHeight / 2
				self.bottomLaneY = self.y + self.laneHeight + self.laneHeight / 2
				self.startMarkerImageX = (self.soundView and self.soundView.marginLeft) or 100
				self.endMarkerImageX = self.startMarkerImageX  -- Will be updated when sound loads
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
				-- Initialize marker positions from soundObject's startPoint and endPoint
				if soundObject and self.soundView then
					-- Convert from total samples to per-channel samples (for image coordinates)
					local channelCount = soundObject:getChannelCount()
					local perChannelStartPoint = soundObject:getStartPoint() / channelCount
					local perChannelEndPoint = soundObject:getEndPoint() / channelCount
					
					self.startMarkerImageX = self.soundView.marginLeft + perChannelStartPoint
					self.endMarkerImageX = self.soundView.marginLeft + perChannelEndPoint
				end
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
				-- Initialize markers from soundObject's startPoint and endPoint  
				if self.soundObject and self.soundView then
					-- Convert from total samples to per-channel samples (for image coordinates)
					local channelCount = self.soundObject:getChannelCount()
					local perChannelStartPoint = (self.soundObject:getStartPoint() or 0) / channelCount
					local perChannelEndPoint = (self.soundObject:getEndPoint() or 0) / channelCount
					
					self.startMarkerImageX = self.soundView.marginLeft + perChannelStartPoint
					self.endMarkerImageX = self.soundView.marginLeft + perChannelEndPoint
				end
			end,
			
			draw = function(self)
				self:drawBackground()
				self:drawStartMarker()
				self:drawEndMarker()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(0.1, 0.1, 0.1)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			end,
			
			drawStartMarker = function(self)
				if not self.soundView or not self.startMarkerImageX then return end
				
				-- Convert image position to screen position
				local markerScreenX, _ = self.soundView:imageToScreenCoordinates(self.startMarkerImageX, 0)
				
				love.graphics.setColor(1, 0.5, 0)  -- Orange
				
				-- Draw right-pointing triangle with tip at exact marker position
				local centerY = self.topLaneY
				local size = self.markerSize
				love.graphics.polygon("fill",
					markerScreenX - size, centerY - size,  -- Top point
					markerScreenX, centerY,                -- Right point (tip at marker)
					markerScreenX - size, centerY + size   -- Bottom point
				)
			end,
			
			drawEndMarker = function(self)
				if not self.soundView or not self.endMarkerImageX then return end
				
				-- Convert image position to screen position
				local markerScreenX, _ = self.soundView:imageToScreenCoordinates(self.endMarkerImageX, 0)
				
				love.graphics.setColor(0.5, 0, 1)  -- Purple
				
				-- Draw left-pointing triangle with tip at exact marker position
				local centerY = self.topLaneY
				local size = self.markerSize
				love.graphics.polygon("fill",
					markerScreenX + size, centerY - size,  -- Top point
					markerScreenX, centerY,                -- Left point (tip at marker)
					markerScreenX + size, centerY + size   -- Bottom point
				)
			end,
			
			getStartMarkerScreenX = function(self)
				if not self.soundView or not self.startMarkerImageX then return 0 end
				local screenX, _ = self.soundView:imageToScreenCoordinates(self.startMarkerImageX, 0)
				return screenX
			end,
			
			getStartMarkerSample = function(self)
				if not self.soundView or not self.startMarkerImageX or not self.soundModel then return 0 end
				
				local marginLeft = self.soundView.marginLeft or 100
				local sampleOffset = math.floor(self.startMarkerImageX - marginLeft)
				
				-- Convert per-channel sample to total sample space
				local totalSample = self.soundModel:totalSampleFromPerChannelSample(math.max(0, sampleOffset))
				
				-- Debug output
				print(string.format("Marker: imageX=%.2f, marginLeft=%.2f, sampleOffset=%d, channelCount=%d, totalSample=%d",
					self.startMarkerImageX, marginLeft, sampleOffset, 
					self.soundModel:getChannelCount(), totalSample))
				
				return totalSample
			end,
			
			getStartMarkerProgress = function(self)
				if not self.soundModel then return 0 end
				
				local sampleOffset = self.startMarkerImageX - (self.soundView and self.soundView.marginLeft or 100)
				local totalSamples = self.soundModel:getSampleCount()
				
				return totalSamples > 0 and (sampleOffset / totalSamples) or 0
			end,
			
			getEndMarkerSample = function(self)
				if not self.soundView or not self.endMarkerImageX or not self.soundModel then return 0 end
				
				local marginLeft = self.soundView.marginLeft or 100
				local sampleOffset = math.floor(self.endMarkerImageX - marginLeft)
				
				-- Convert per-channel sample to total sample space
				local totalSample = self.soundModel:totalSampleFromPerChannelSample(math.max(0, sampleOffset))
				
				return totalSample
			end,
			
			getEndMarkerProgress = function(self)
				if not self.soundModel then return 0 end
				
				local sampleOffset = self.endMarkerImageX - (self.soundView and self.soundView.marginLeft or 100)
				local totalSamples = self.soundModel:getSampleCount()
				
				return totalSamples > 0 and (sampleOffset / totalSamples) or 0
			end,
			
			isMouseOverStartMarker = function(self, mx, my)
				if not self.soundView or not self.startMarkerImageX then return false end
				
				local screenX = self:getStartMarkerScreenX()
				local size = self.markerSize
				local centerY = self.topLaneY
				-- Tip is now at screenX, base extends from screenX - size
				return mx >= screenX - size and mx <= screenX
					and my >= centerY - size and my <= centerY + size
			end,
			
			isMouseOverEndMarker = function(self, mx, my)
				if not self.soundView or not self.endMarkerImageX then return false end
				
				local screenX = self:getEndMarkerScreenX()
				local size = self.markerSize
				local centerY = self.topLaneY
				-- Tip is now at screenX, base extends to screenX + size
				return mx >= screenX and mx <= screenX + size
					and my >= centerY - size and my <= centerY + size
			end,
			
			getEndMarkerScreenX = function(self)
				if not self.soundView or not self.endMarkerImageX then return 0 end
				local screenX, _ = self.soundView:imageToScreenCoordinates(self.endMarkerImageX, 0)
				return screenX
			end,
			
			handleMousePressed = function(self, mx, my)
				if self:isMouseOverStartMarker(mx, my) then
					self.isDraggingStart = true
					return true
				end
				if self:isMouseOverEndMarker(mx, my) then
					self.isDraggingEnd = true
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.isDraggingStart = false
				self.isDraggingEnd = false
			end,
			
			handleMouseDragged = function(self, mx, my)
				if not self.soundView then return end
				
				-- Convert screen position to image position
				local imageX, _ = self.soundView:screenToImageCoordinates(mx, my)
				
				-- Constrain to waveform bounds in image space
				local marginLeft = self.soundView.marginLeft or 100
				local sampleCount = self.soundModel and self.soundModel:getSampleCount() or 0
				local maxImageX = marginLeft + sampleCount
				
				if self.isDraggingStart then
					self.startMarkerImageX = math.max(marginLeft, math.min(imageX, maxImageX))
					
					-- Update soundObject's startPoint (convert from per-channel to total samples)
					if self.soundObject then
						local perChannelSample = math.floor(self.startMarkerImageX - marginLeft)
						local channelCount = self.soundObject:getChannelCount()
						self.soundObject:setStartPoint(perChannelSample * channelCount)
					end
					
					if self.onMarkerChanged then
						self.onMarkerChanged()
					end
				elseif self.isDraggingEnd then
					self.endMarkerImageX = math.max(marginLeft, math.min(imageX, maxImageX))
					
					-- Update soundObject's endPoint (convert from per-channel to total samples)
					if self.soundObject then
						local perChannelSample = math.floor(self.endMarkerImageX - marginLeft)
						local channelCount = self.soundObject:getChannelCount()
						self.soundObject:setEndPoint(perChannelSample * channelCount)
					end
					
					if self.onMarkerChanged then
						self.onMarkerChanged()
					end
				end
			end,
			
			update = function(self, dt)
				-- Handle marker dragging
				if self.isDraggingStart or self.isDraggingEnd then
					local mx, my = love.mouse.getPosition()
					self:handleMouseDragged(mx, my)
				end
			end,
		}):init()
	end,
}
