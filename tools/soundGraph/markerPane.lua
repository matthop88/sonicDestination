local markerFactory = require("tools/soundGraph/marker")

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
			
			-- Marker properties
			laneHeight = (params.height or 64) / 2,
			markerSize = 12,
			startMarker = nil,
			endMarker = nil,
			onMarkerChanged = params.onMarkerChanged,
			
			init = function(self)
				self.topLaneY = self.y + self.laneHeight / 2
				self.bottomLaneY = self.y + self.laneHeight + self.laneHeight / 2
				
				-- Create markers using factory
				self.startMarker = markerFactory.createStartMarker(self)
				self.endMarker = markerFactory.createEndMarker(self)
				
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
				-- Initialize both markers from soundObject
				if soundObject and self.soundView then
					self.startMarker:initializeFromSoundObject()
					self.endMarker:initializeFromSoundObject()
				end
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
				-- Initialize both markers from soundObject
				if self.soundObject and self.soundView then
					self.startMarker:initializeFromSoundObject()
					self.endMarker:initializeFromSoundObject()
				end
			end,
			
			draw = function(self)
				self:drawBackground()
				self.startMarker:draw()
				self.endMarker:draw()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(0.1, 0.1, 0.1)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			end,
			
			getStartMarkerScreenX = function(self)
				return self.startMarker:getScreenX()
			end,
			
			getStartMarkerSample = function(self)
				local totalSample = self.startMarker:getSample()
				
				-- Debug output
				if self.soundView and self.soundModel then
					local marginLeft = self.soundView.marginLeft or 100
					local sampleOffset = self.startMarker.imageX - marginLeft
					print(string.format("Marker: imageX=%.2f, marginLeft=%.2f, sampleOffset=%d, channelCount=%d, totalSample=%d",
						self.startMarker.imageX, marginLeft, sampleOffset, 
						self.soundModel:getChannelCount(), totalSample))
				end
				
				return totalSample
			end,
			
			getStartMarkerProgress = function(self)
				return self.startMarker:getProgress()
			end,
			
			getEndMarkerSample = function(self)
				return self.endMarker:getSample()
			end,
			
			getEndMarkerProgress = function(self)
				return self.endMarker:getProgress()
			end,
			
			getEndMarkerScreenX = function(self)
				return self.endMarker:getScreenX()
			end,
			
			handleMousePressed = function(self, mx, my)
				if self.startMarker:handlePressed(mx, my) then
					return true
				end
				if self.endMarker:handlePressed(mx, my) then
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.startMarker:handleReleased()
				self.endMarker:handleReleased()
			end,
			
			handleMouseDragged = function(self, mx, my)
				self.startMarker:handleDragged(mx, my)
				self.endMarker:handleDragged(mx, my)
			end,
			
			update = function(self, dt)
				-- Handle marker dragging
				if self.startMarker.isDragging or self.endMarker.isDragging then
					local mx, my = love.mouse.getPosition()
					self:handleMouseDragged(mx, my)
				end
			end,
		}):init()
	end,
}
