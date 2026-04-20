local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 100,
			height = params.height or 200,
			title = params.title or "Slider",
			minValue = params.minValue or 0,
			maxValue = params.maxValue or 1,
			quantize = params.quantize or 0.1,
			titleFontSize = params.titleFontSize or 16,
			labelFontSize = params.labelFontSize or 20,
			showLabels = params.showLabels == nil and true or params.showLabels,
			getValue = params.getValue,
			setValue = params.setValue,
			isDragging = false,
				
			init = function(self)
				self.padding = 15
				self.sliderWidth = 30
				self.trackX = self.x + self.padding + self.sliderWidth / 2
				
				if self.showLabels then
					self.trackY = self.y + 50
					self.trackHeight = self.height - 80
				else
					self.trackY = self.y + 60
					self.trackHeight = self.height - 90
				end
				
				self.thumbHeight = 12
				self.titleFont = love.graphics.newFont(self.titleFontSize)
				self.labelFont = love.graphics.newFont(self.labelFontSize)
				return self
			end,
			
			draw = function(self)
				self:drawBackground()
				self:drawTitle()
				self:drawTrack()
				self:drawThumb()
				self:drawLabels()
			end,
			
			drawBackground = function(self)
				love.graphics.setColor(COLOR.DARK_GREY)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(COLOR.JET_BLACK)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
					
			drawTitle = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(self.titleFont)
				local titleWidth = self.titleFont:getWidth(self.title)
				local titleX = self.x + (self.width - titleWidth) / 2
				local titleY = self.y + 10
				love.graphics.print(self.title, titleX, titleY)
			end,
				
			drawTrack = function(self)
				love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
				love.graphics.setLineWidth(3)
				love.graphics.line(self.trackX, self.trackY, self.trackX, self.trackY + self.trackHeight)
				love.graphics.setLineWidth(1)
			end,
				
			drawThumb = function(self)
				if not self.getValue then return end
				
				local value = self.getValue()
				local thumbY = self:valueToY(value)
				
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("fill", self.x + self.padding + 2, thumbY - self.thumbHeight/2, self.sliderWidth - 4, self.thumbHeight)
				love.graphics.setColor(COLOR.JET_BLACK)
				love.graphics.rectangle("line", self.x + self.padding + 2, thumbY - self.thumbHeight/2, self.sliderWidth - 4, self.thumbHeight)
			end,
						
			drawLabels = function(self)
				love.graphics.setFont(self.labelFont)
				
				local currentValue = self.getValue and self.getValue() or self.minValue
				local formatString = self.quantize < 0.1 and "%.2f" or "%.1f"
				
				if self.showLabels then
					local numSteps = math.floor((self.maxValue - self.minValue) / self.quantize)
					
					for i = 0, numSteps do
						local value = self.minValue + (i * self.quantize)
						local labelY = self:valueToY(value)
						local label = string.format(formatString, value)
						
						if math.abs(value - currentValue) < 0.01 then
							love.graphics.setColor(COLOR.YELLOW)
						else
							love.graphics.setColor(COLOR.MEDIUM_LIGHT_GREY)
						end
						
						love.graphics.print(label, self.x + self.padding + self.sliderWidth + 15, labelY - 10)
					end
				else
					love.graphics.setColor(COLOR.YELLOW)
					local label = string.format(formatString, currentValue)
					local labelWidth = self.labelFont:getWidth(label)
					local labelX = self.x + (self.width - labelWidth) / 2
					local labelY = self.y + 35
					love.graphics.print(label, labelX, labelY)
				end
			end,
				
			valueToY = function(self, value)
				local normalizedValue = (value - self.minValue) / (self.maxValue - self.minValue)
				return self.trackY + self.trackHeight - (normalizedValue * self.trackHeight)
			end,
			
			yToValue = function(self, y)
				local clampedY = math.max(self.trackY, math.min(y, self.trackY + self.trackHeight))
				local normalizedValue = 1 - ((clampedY - self.trackY) / self.trackHeight)
				local value = self.minValue + (normalizedValue * (self.maxValue - self.minValue))
				
				-- Quantize to increment
				value = math.floor(value / self.quantize + 0.5) * self.quantize
				
				return math.max(self.minValue, math.min(self.maxValue, value))
			end,
			
			handleMousePressed = function(self, mx, my)
				local sliderLeft = self.x + self.padding
				local sliderRight = sliderLeft + self.sliderWidth
				if mx >= sliderLeft and mx <= sliderRight and
				my >= self.y and my <= self.y + self.height then
					self.isDragging = true
					self:updateValue(mx, my)
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				if self.isDragging then
					self.isDragging = false
					return true
				end
			end,
			
			updateValue = function(self, mx, my)
				if not self.setValue then return end
				
				local newValue = self:yToValue(my)
				self.setValue(newValue)
			end,
			
			update = function(self, dt)
				if self.isDragging then
					local mx, my = love.mouse.getPosition()
					self:updateValue(mx, my)
				end
			end,
		}):init()
	end,
}
