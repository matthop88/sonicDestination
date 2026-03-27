return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 100,
			height = params.height or 200,
			soundObject = nil,
			isDragging = false,
			quantize = params.quantize or 0.1,
			
			init = function(self)
				self.padding = 15
				self.sliderWidth = 30
				self.trackX = self.x + self.padding + self.sliderWidth / 2
				self.trackY = self.y + 50
				self.trackHeight = self.height - 80
				self.thumbHeight = 12
				self.titleFont = love.graphics.newFont(16)
				self.labelFont = love.graphics.newFont(20)
				return self
			end,
			
			setSoundObject = function(self, soundObject)
				self.soundObject = soundObject
			end,
			
			draw = function(self)
				self:drawBackground()
				self:drawTitle()
				self:drawTrack()
				self:drawThumb()
				self:drawLabels()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(0.2, 0.2, 0.2)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
				
			drawTitle = function(self)
				love.graphics.setColor(1, 1, 1)
				love.graphics.setFont(self.titleFont)
				local title = "Volume"
				local titleWidth = self.titleFont:getWidth(title)
				local titleX = self.x + (self.width - titleWidth) / 2
				local titleY = self.y + 10
				love.graphics.print(title, titleX, titleY)
			end,
			
			drawTrack = function(self)
				love.graphics.setColor(0.3, 0.3, 0.3)
				love.graphics.setLineWidth(3)
				love.graphics.line(self.trackX, self.trackY, self.trackX, self.trackY + self.trackHeight)
				love.graphics.setLineWidth(1)
			end,
			
			drawThumb = function(self)
				if not self.soundObject then return end
				
				local volume = self.soundObject.volume
				local thumbY = self:volumeToY(volume)
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", self.x + self.padding + 2, thumbY - self.thumbHeight/2, self.sliderWidth - 4, self.thumbHeight)
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("line", self.x + self.padding + 2, thumbY - self.thumbHeight/2, self.sliderWidth - 4, self.thumbHeight)
			end,
			
			drawLabels = function(self)
				love.graphics.setFont(self.labelFont)
				
				local currentVolume = self.soundObject and self.soundObject.volume or 0
				
				for i = 0, 10 do
					local value = i / 10
					local labelY = self:volumeToY(value)
					local label = string.format("%.1f", value)
					
					if math.abs(value - currentVolume) < 0.01 then
						love.graphics.setColor(1, 1, 0)
					else
						love.graphics.setColor(0.7, 0.7, 0.7)
					end
					
					love.graphics.print(label, self.x + self.padding + self.sliderWidth + 15, labelY - 10)
				end
			end,
			
			volumeToY = function(self, volume)
				return self.trackY + self.trackHeight - (volume * self.trackHeight)
			end,
			
			yToVolume = function(self, y)
				local clampedY = math.max(self.trackY, math.min(y, self.trackY + self.trackHeight))
				local volume = 1 - ((clampedY - self.trackY) / self.trackHeight)
				
				-- Quantize to increment
				volume = math.floor(volume / self.quantize + 0.5) * self.quantize
				
				return math.max(0, math.min(1, volume))
			end,
			
			handleMousePressed = function(self, mx, my)
				local sliderLeft = self.x + self.padding
				local sliderRight = sliderLeft + self.sliderWidth
				if mx >= sliderLeft and mx <= sliderRight and
				my >= self.y and my <= self.y + self.height then
					self.isDragging = true
					self:updateVolume(mx, my)
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.isDragging = false
			end,
			
			updateVolume = function(self, mx, my)
				if not self.soundObject then return end
				
				local newVolume = self:yToVolume(my)
				self.soundObject:setVolume(newVolume)
			end,
			
			update = function(self, dt)
				if self.isDragging then
					local mx, my = love.mouse.getPosition()
					self:updateVolume(mx, my)
				end
			end,
		}):init()
	end,
}
