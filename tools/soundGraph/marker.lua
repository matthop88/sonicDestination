-- Base marker object factory
local function createMarker(config)
	return ({
		markerPane = config.markerPane,
		imageX = config.initialImageX or 100,
		isDragging = false,
		color = config.color or {1, 1, 1},
		direction = config.direction or "right",  -- "right" or "left"
		laneY = config.laneY,
		size = config.size or 12,
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
			
			if self.direction == "right" then
				-- Tip at screenX, base extends from screenX - size
				return mx >= screenX - self.size and mx <= screenX
					and my >= centerY - self.size and my <= centerY + self.size
			else
				-- Tip at screenX, base extends to screenX + size
				return mx >= screenX and mx <= screenX + self.size
					and my >= centerY - self.size and my <= centerY + self.size
			end
		end,
		
		draw = function(self)
			if not self.markerPane.soundView or not self.imageX then return end
			
			local screenX = self:getScreenX()
			local centerY = self.laneY
			
			love.graphics.setColor(unpack(self.color))
			
			if self.direction == "right" then
				-- Right-pointing triangle with tip at exact marker position
				love.graphics.polygon("fill",
					screenX - self.size, centerY - self.size,  -- Top point
					screenX, centerY,                          -- Right point (tip at marker)
					screenX - self.size, centerY + self.size   -- Bottom point
				)
			else
				-- Left-pointing triangle with tip at exact marker position
				love.graphics.polygon("fill",
					screenX + self.size, centerY - self.size,  -- Top point
					screenX, centerY,                          -- Left point (tip at marker)
					screenX + self.size, centerY + self.size   -- Bottom point
				)
			end
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
		return createMarker {
			markerPane = markerPane,
			initialImageX = (markerPane.soundView and markerPane.soundView.marginLeft) or 100,
			color = {1, 0.5, 0},  -- Orange
			direction = "right",
			laneY = markerPane.topLaneY,
			size = markerPane.markerSize,
			getValueFromSoundObject = function(soundObject) return soundObject:getStartPoint() end,
			setValueOnSoundObject = function(soundObject, value) soundObject:setStartPoint(value) end,
		}
	end,
	
	createEndMarker = function(markerPane)
		return createMarker {
			markerPane = markerPane,
			initialImageX = (markerPane.soundView and markerPane.soundView.marginLeft) or 100,
			color = {0.5, 0, 1},  -- Purple
			direction = "left",
			laneY = markerPane.topLaneY,
			size = markerPane.markerSize,
			getValueFromSoundObject = function(soundObject) return soundObject:getEndPoint() end,
			setValueOnSoundObject = function(soundObject, value) soundObject:setEndPoint(value) end,
		}
	end,
}
