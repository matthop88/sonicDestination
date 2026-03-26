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
			loopStartMarker = nil,
			loopEndMarker = nil,
			onMarkerChanged = params.onMarkerChanged,
			
			init = function(self)
				self.topLaneY = self.y + self.laneHeight / 2
				self.bottomLaneY = self.y + self.laneHeight + self.laneHeight / 2
				
				-- Create markers using factory
				self.startMarker = markerFactory.createStartMarker(self)
				self.endMarker = markerFactory.createEndMarker(self)
				self.loopStartMarker = markerFactory.createLoopStartMarker(self)
				self.loopEndMarker = markerFactory.createLoopEndMarker(self)
				
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
				-- Initialize all markers from soundObject
				if soundObject and self.soundView then
					self.startMarker:initializeFromSoundObject()
					self.endMarker:initializeFromSoundObject()
					self.loopStartMarker:initializeFromSoundObject()
					self.loopEndMarker:initializeFromSoundObject()
				end
			end,
			
			setSoundModel = function(self, soundModel)
				self.soundModel = soundModel
				-- Initialize all markers from soundObject
				if self.soundObject and self.soundView then
					self.startMarker:initializeFromSoundObject()
					self.endMarker:initializeFromSoundObject()
					self.loopStartMarker:initializeFromSoundObject()
					self.loopEndMarker:initializeFromSoundObject()
				end
			end,
			
			draw = function(self)
				self:drawBackground()
				self.startMarker:draw()
				self.endMarker:draw()
				self.loopStartMarker:draw()
				self.loopEndMarker:draw()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(0.1, 0.1, 0.1)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
			end,
			
			updateAllMarkerValues = function(self)
				self.startMarker:updateValue()
				self.endMarker:updateValue()
				self.loopStartMarker:updateValue()
				self.loopEndMarker:updateValue()
			end,
			
			handleMousePressed = function(self, mx, my)
				if self.startMarker:handlePressed(mx, my) then
					return true
				end
				if self.endMarker:handlePressed(mx, my) then
					return true
				end
				if self.loopStartMarker:handlePressed(mx, my) then
					return true
				end
				if self.loopEndMarker:handlePressed(mx, my) then
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.startMarker:handleReleased()
				self.endMarker:handleReleased()
				self.loopStartMarker:handleReleased()
				self.loopEndMarker:handleReleased()
			end,
			
			handleMouseDragged = function(self, mx, my)
				self.startMarker:handleDragged(mx, my)
				self.endMarker:handleDragged(mx, my)
				self.loopStartMarker:handleDragged(mx, my)
				self.loopEndMarker:handleDragged(mx, my)
			end,
			
			update = function(self, dt)
				-- Handle marker dragging
				if self.startMarker.isDragging or self.endMarker.isDragging 
					or self.loopStartMarker.isDragging or self.loopEndMarker.isDragging then
					local mx, my = love.mouse.getPosition()
					self:handleMouseDragged(mx, my)
				end
			end,
		}):init()
	end,
}
