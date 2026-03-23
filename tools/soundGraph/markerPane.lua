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
			isDraggingStart = false,
			onMarkerChanged = params.onMarkerChanged,
			
			init = function(self)
				self.topLaneY = self.y + self.laneHeight / 2
				self.bottomLaneY = self.y + self.laneHeight + self.laneHeight / 2
				self.startMarkerImageX = (self.soundView and self.soundView.marginLeft) or 100
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
				-- Reset marker to start of waveform
				if self.soundView then
					self.startMarkerImageX = self.soundView.marginLeft
				end
			end,
			
			draw = function(self)
				self:drawBackground()
				self:drawStartMarker()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(0.1, 0.1, 0.1)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			end,
			
			drawStartMarker = function(self)
				if not self.soundView or not self.startMarkerImageX then return end
				
				-- Convert image position to screen position
				local screenX, _ = self.soundView:imageToScreenCoordinates(self.startMarkerImageX, 0)
				
				love.graphics.setColor(1, 0.5, 0)  -- Orange
				
				-- Draw right-pointing triangle (play button shape)
				local centerY = self.topLaneY
				local size = self.markerSize
				love.graphics.polygon("fill",
					screenX, centerY - size,  -- Top point
					screenX + size, centerY,  -- Right point
					screenX, centerY + size   -- Bottom point
				)
			end,
			
			getStartMarkerScreenX = function(self)
				if not self.soundView or not self.startMarkerImageX then return 0 end
				local screenX, _ = self.soundView:imageToScreenCoordinates(self.startMarkerImageX, 0)
				return screenX
			end,
			
			isMouseOverStartMarker = function(self, mx, my)
				if not self.soundView or not self.startMarkerImageX then return false end
				
				local screenX = self:getStartMarkerScreenX()
				local size = self.markerSize
				local centerY = self.topLaneY
				return mx >= screenX and mx <= screenX + size
					and my >= centerY - size and my <= centerY + size
			end,
			
			handleMousePressed = function(self, mx, my)
				if self:isMouseOverStartMarker(mx, my) then
					self.isDraggingStart = true
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.isDraggingStart = false
			end,
			
			handleMouseDragged = function(self, mx, my)
				if not self.isDraggingStart or not self.soundView then return end
				
				-- Convert screen position to image position
				local imageX, _ = self.soundView:screenToImageCoordinates(mx, my)
				
				-- Constrain to waveform bounds in image space
				local marginLeft = self.soundView.marginLeft or 100
				local sampleCount = self.soundModel and self.soundModel:getSampleCount() or 0
				local maxImageX = marginLeft + sampleCount
				
				self.startMarkerImageX = math.max(marginLeft, math.min(imageX, maxImageX))
				
				if self.onMarkerChanged then
					self.onMarkerChanged()
				end
			end,
			
			update = function(self, dt)
				-- Future: could add animations or other updates here
			end,
		}):init()
	end,
}
