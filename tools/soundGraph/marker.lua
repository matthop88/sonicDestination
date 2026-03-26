-- Base marker object factory
local function createMarker(config)
	return ({
		markerPane = config.markerPane,
		imageX = config.initialImageX or 100,
		isDragging = false,
		color = config.color or {1, 1, 1},
		laneY = config.laneY,
		size = config.size or 12,
		leftOffset = config.leftOffset or 0,
		rightOffset = config.rightOffset or 0,
		getValueFromSoundObject = config.getValueFromSoundObject,
		setValueOnSoundObject = config.setValueOnSoundObject,
		
		getScreenX = function(self)
			if not self.markerPane.soundView or not self.imageX then return 0 end
			local screenX, _ = self.markerPane.soundView:imageToScreenCoordinates(self.imageX, 0)
			return screenX
		end,
		
		getSample = function(self)
			if not self.markerPane.soundView or not self.imageX or not self.markerPane.soundModel then return 0 end
			
			local marginLeft = self.markerPane.soundView.marginLeft or 100
			local sampleOffset = math.floor(self.imageX - marginLeft)
			
			-- Convert per-channel sample to total sample space
			local totalSample = self.markerPane.soundModel:totalSampleFromPerChannelSample(math.max(0, sampleOffset))
			
			return totalSample
		end,
		
		getProgress = function(self)
			if not self.markerPane.soundModel then return 0 end
			
			local sampleOffset = self.imageX - (self.markerPane.soundView and self.markerPane.soundView.marginLeft or 100)
			local totalSamples = self.markerPane.soundModel:getSampleCount()
			
			return totalSamples > 0 and (sampleOffset / totalSamples) or 0
		end,
		
		isMouseOver = function(self, mx, my)
			if not self.markerPane.soundView or not self.imageX then return false end
			
			local screenX = self:getScreenX()
			local centerY = self.laneY
			
			return mx >= screenX + self.leftOffset and mx <= screenX + self.rightOffset
				and my >= centerY - self.size and my <= centerY + self.size
		end,
		
		draw = function(self)
			if not self.markerPane.soundView or not self.imageX then return end
			
			local screenX = self:getScreenX()
			local centerY = self.laneY
			
			love.graphics.setColor(unpack(self.color))
			
			self:drawShape(screenX, centerY)
		end,
		
		-- Stub for drawShape (should be overridden by factory)
		drawShape = function(self, screenX, centerY)
		end,
	
	handlePressed = function(self, mx, my)
			if self:isMouseOver(mx, my) then
				self.isDragging = true
				return true
			end
			return false
		end,
		
		handleReleased = function(self)
			self.isDragging = false
		end,
		
		handleDragged = function(self, mx, my)
			if not self.isDragging or not self.markerPane.soundView then return end
			
			-- Convert screen position to image position
			local imageX, _ = self.markerPane.soundView:screenToImageCoordinates(mx, my)
			
			-- Constrain to waveform bounds in image space
			local marginLeft = self.markerPane.soundView.marginLeft or 100
			local sampleCount = self.markerPane.soundModel and self.markerPane.soundModel:getSampleCount() or 0
			local maxImageX = marginLeft + sampleCount
			
			self.imageX = math.max(marginLeft, math.min(imageX, maxImageX))
			
			-- Update soundObject (convert from per-channel to total samples)
			if self.markerPane.soundObject and self.setValueOnSoundObject then
				local perChannelSample = math.floor(self.imageX - marginLeft)
				local channelCount = self.markerPane.soundObject:getChannelCount()
				self.setValueOnSoundObject(self.markerPane.soundObject, perChannelSample * channelCount)
				
				-- Read back the constrained value from soundObject and update visual position
				local constrainedValue = self.getValueFromSoundObject(self.markerPane.soundObject)
				local constrainedPerChannel = constrainedValue / channelCount
				self.imageX = marginLeft + constrainedPerChannel
			end
			
			if self.markerPane.onMarkerChanged then
				self.markerPane.onMarkerChanged()
			end
		end,
		
		initializeFromSoundObject = function(self)
			if not self.markerPane.soundObject or not self.markerPane.soundView then return end
			
			-- Get value from soundObject and convert to per-channel samples
			local totalSampleValue = self.getValueFromSoundObject(self.markerPane.soundObject)
			local channelCount = self.markerPane.soundObject:getChannelCount()
			local perChannelValue = totalSampleValue / channelCount
			
			self.imageX = self.markerPane.soundView.marginLeft + perChannelValue
		end,
	})
end

-- Marker factory
return {
	createStartMarker = function(markerPane)
		-- Creates right-pointing orange triangle (►)
		local marker = createMarker {
			markerPane = markerPane,
			initialImageX = (markerPane.soundView and markerPane.soundView.marginLeft) or 100,
			color = {1, 0.5, 0},  -- Orange
			laneY = markerPane.topLaneY,
			size = markerPane.markerSize,
			leftOffset = -markerPane.markerSize,  -- Extends left from marker position
			rightOffset = 0,
			getValueFromSoundObject = function(soundObject) return soundObject:getStartPoint() end,
			setValueOnSoundObject = function(soundObject, value) soundObject:setStartPoint(value) end,
		}
		
		marker.drawShape = function(self, screenX, centerY)
			love.graphics.polygon("fill",
				screenX - self.size, centerY - self.size,  -- Top point
				screenX, centerY,                          -- Right point (tip at marker)
				screenX - self.size, centerY + self.size   -- Bottom point
			)
		end
		
		return marker
	end,
	
	createEndMarker = function(markerPane)
		-- Creates left-pointing purple triangle (◄)
		local marker = createMarker {
			markerPane = markerPane,
			initialImageX = (markerPane.soundView and markerPane.soundView.marginLeft) or 100,
			color = {0.5, 0, 1},  -- Purple
			laneY = markerPane.topLaneY,
			size = markerPane.markerSize,
			leftOffset = 0,
			rightOffset = markerPane.markerSize,  -- Extends right from marker position
			getValueFromSoundObject = function(soundObject) return soundObject:getEndPoint() end,
			setValueOnSoundObject = function(soundObject, value) soundObject:setEndPoint(value) end,
		}
		
		marker.drawShape = function(self, screenX, centerY)
			love.graphics.polygon("fill",
				screenX + self.size, centerY - self.size,  -- Top point
				screenX, centerY,                          -- Left point (tip at marker)
				screenX + self.size, centerY + self.size   -- Bottom point
			)
		end
		
		return marker
	end,
	
	createLoopStartMarker = function(markerPane)
		-- Creates white musical start repeat symbol (||:) with right edge of colon at marker position
		local marker = createMarker {
			markerPane = markerPane,
			initialImageX = (markerPane.soundView and markerPane.soundView.marginLeft) or 100,
			color = {1, 1, 1},  -- White
			laneY = markerPane.bottomLaneY,
			size = markerPane.markerSize,
			leftOffset = -14,  -- Symbol extends left from marker position
			rightOffset = 0,
			getValueFromSoundObject = function(soundObject) return soundObject:getLoopStartPoint() end,
			setValueOnSoundObject = function(soundObject, value) soundObject:setLoopStartPoint(value) end,
		}
		
		marker.drawShape = function(self, screenX, centerY)
			love.graphics.setLineWidth(2)
			
			local dotRadius = 2
			local colonCenterOffset = -3
			love.graphics.circle("fill", screenX + colonCenterOffset, centerY - 4, dotRadius)
			love.graphics.circle("fill", screenX + colonCenterOffset, centerY + 4, dotRadius)
			
			local lineHeight = self.size * 1.5
			local lineOffset = -8
			love.graphics.line(screenX + lineOffset, centerY - lineHeight/2, screenX + lineOffset, centerY + lineHeight/2)
			love.graphics.line(screenX + lineOffset - 3, centerY - lineHeight/2, screenX + lineOffset - 3, centerY + lineHeight/2)
			
			love.graphics.setLineWidth(1)
		end
		
		return marker
	end,
	
	createLoopEndMarker = function(markerPane)
		-- Creates white musical end repeat symbol (:||) with left edge of lines at marker position
		local marker = createMarker {
			markerPane = markerPane,
			initialImageX = (markerPane.soundView and markerPane.soundView.marginLeft) or 100,
			color = {1, 1, 1},  -- White
			laneY = markerPane.bottomLaneY,
			size = markerPane.markerSize,
			leftOffset = -8,  -- Colon extends left
			rightOffset = 6,  -- Lines extend right
			getValueFromSoundObject = function(soundObject) return soundObject:getLoopEndPoint() end,
			setValueOnSoundObject = function(soundObject, value) soundObject:setLoopEndPoint(value) end,
		}
		
		marker.drawShape = function(self, screenX, centerY)
			love.graphics.setLineWidth(2)
			
			local dotRadius = 2
			local colonCenterOffset = -5
			love.graphics.circle("fill", screenX + colonCenterOffset, centerY - 4, dotRadius)
			love.graphics.circle("fill", screenX + colonCenterOffset, centerY + 4, dotRadius)
			
			local lineHeight = self.size * 1.5
			love.graphics.line(screenX, centerY - lineHeight/2, screenX, centerY + lineHeight/2)
			love.graphics.line(screenX + 3, centerY - lineHeight/2, screenX + 3, centerY + lineHeight/2)
			
			love.graphics.setLineWidth(1)
		end
		
		return marker
	end,
}
