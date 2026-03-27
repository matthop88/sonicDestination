-- Base marker object factory
local function createMarker(config)
	local doubleClickModule = dofile("plugins/modules/doubleClick.lua")
	local doubleClick = doubleClickModule:init { interval = 0.3 }
	
	return ({
		markerPane = config.markerPane,
		imageX = config.initialImageX or 100,
		isDragging = false,
		readyToDrag = false,
		pressedX = nil,
		pressedY = nil,
		active = config.active ~= false,  -- Default to true
		enabled = config.enabled ~= false,  -- Default to true
		color = config.color or {1, 1, 1},
		laneY = config.laneY,
		size = config.size or 12,
		leftOffset = config.leftOffset or 0,
		rightOffset = config.rightOffset or 0,
		getValueFromSoundObject = config.getValueFromSoundObject,
		setValueOnSoundObject = config.setValueOnSoundObject,
		toggleable = config.toggleable or false,
		doubleClick = doubleClick,
		
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
			if not self.active or not self.markerPane.soundView or not self.imageX then return false end
			
			local screenX = self:getScreenX()
			local centerY = self.laneY
			
			return mx >= screenX + self.leftOffset and mx <= screenX + self.rightOffset
				and my >= centerY - self.size and my <= centerY + self.size
		end,
		
	draw = function(self)
		if not self.active or not self.markerPane.soundView or not self.imageX then return end
		
		local screenX = self:getScreenX()
		local centerY = self.laneY
		
		if self.enabled then
			love.graphics.setColor(unpack(self.color))
		else
			love.graphics.setColor(0.3, 0.3, 0.3)
		end
		
		self:drawShape(screenX, centerY)
	end,
		
		-- Stub for drawShape (should be overridden by factory)
		drawShape = function(self, screenX, centerY)
		end,
	
	handlePressed = function(self, mx, my)
		if self:isMouseOver(mx, my) then
			local params = {}
			if self.doubleClick then
				self.doubleClick:prehandleMousepressed(mx, my, params)
			end
			
			if params.doubleClicked and self.toggleable then
				self.enabled = not self.enabled
				
				if self.markerPane.soundObject then
					local isLoopingEnabled = self.markerPane:isLoopingEnabled()
					self.markerPane.soundObject:setLoopMarkersEnabled(isLoopingEnabled)
				end
				
				self.readyToDrag = false
				return true
			end
			
			if self.toggleable then
				self.readyToDrag = true
				self.pressedX = mx
				self.pressedY = my
			else
				self.isDragging = true
			end
			return true
		end
		return false
	end,
		
	handleReleased = function(self)
		self.isDragging = false
		self.readyToDrag = false
		self.pressedX = nil
		self.pressedY = nil
	end,
		
	handleDragged = function(self, mx, my)
		if not self.enabled or not self.markerPane.soundView then return end
		
		-- For toggleable markers, only start dragging if mouse has moved
		if self.readyToDrag then
			local dragThreshold = 3
			local dx = mx - (self.pressedX or mx)
			local dy = my - (self.pressedY or my)
			local distance = math.sqrt(dx * dx + dy * dy)
			
			if distance > dragThreshold then
				self.isDragging = true
				self.readyToDrag = false
			else
				return
			end
		end
		
		if not self.isDragging then return end
			
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
		
		updateValue = function(self)
			if not self.markerPane.soundObject or not self.markerPane.soundView then return end
			
			local marginLeft = self.markerPane.soundView.marginLeft or 100
			local channelCount = self.markerPane.soundObject:getChannelCount()
			
			local constrainedValue = self.getValueFromSoundObject(self.markerPane.soundObject)
			local constrainedPerChannel = constrainedValue / channelCount
			self.imageX = marginLeft + constrainedPerChannel
		end,
		
	setActive = function(self, active)
		self.active = active
	end,
	
	setEnabled = function(self, enabled)
		self.enabled = enabled
	end,
	
	isEnabled = function(self)
		return self.enabled
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
			toggleable = true,
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
			toggleable = true,
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
