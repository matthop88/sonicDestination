local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 60,
			title = params.title or "Slider",
			minValue = params.minValue or 0,
			maxValue = params.maxValue or 1,
			quantize = params.quantize or 0.1,
			titleFontSize = params.titleFontSize or 16,
			labelFontSize = params.labelFontSize or 16,
			getValue = params.getValue,
			setValue = params.setValue,
			isDragging = false,
				
		init = function(self)
			self.padding = 10
			self.sliderHeight = 20
			self.trackX = self.x + 90
			self.trackY = self.y + self.height / 2
			self.trackWidth = self.width - 150
			self.thumbWidth = 12
			self.titleFont = love.graphics.newFont(self.titleFontSize)
			self.labelFont = love.graphics.newFont(self.labelFontSize)
			return self
		end,
			
			draw = function(self)
				self:drawTitle()
				self:drawTrack()
				self:drawThumb()
				self:drawLabel()
			end,
					
			drawTitle = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(self.titleFont)
				local titleY = self.y + (self.height - self.titleFont:getHeight()) / 2
				love.graphics.print(self.title, self.x + 5, titleY)
			end,
				
			drawTrack = function(self)
				love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
				love.graphics.setLineWidth(3)
				love.graphics.line(self.trackX, self.trackY, self.trackX + self.trackWidth, self.trackY)
				love.graphics.setLineWidth(1)
			end,
				
			drawThumb = function(self)
				if not self.getValue then return end
				
				local value = self.getValue()
				local thumbX = self:valueToX(value)
				
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("fill", thumbX - self.thumbWidth/2, self.trackY - self.sliderHeight/2, self.thumbWidth, self.sliderHeight)
				love.graphics.setColor(COLOR.JET_BLACK)
				love.graphics.rectangle("line", thumbX - self.thumbWidth/2, self.trackY - self.sliderHeight/2, self.thumbWidth, self.sliderHeight)
			end,
						
			drawLabel = function(self)
				love.graphics.setFont(self.labelFont)
				
				local currentValue = self.getValue and self.getValue() or self.minValue
				local formatString = self.quantize < 0.1 and "%.2f" or "%.1f"
				
				love.graphics.setColor(COLOR.YELLOW)
				local label = string.format(formatString, currentValue)
				local labelY = self.y + (self.height - self.labelFont:getHeight()) / 2
				local labelX = self.x + self.width - 40
				love.graphics.print(label, labelX, labelY)
			end,
				
			valueToX = function(self, value)
				local normalizedValue = (value - self.minValue) / (self.maxValue - self.minValue)
				return self.trackX + (normalizedValue * self.trackWidth)
			end,
			
			xToValue = function(self, x)
				local clampedX = math.max(self.trackX, math.min(x, self.trackX + self.trackWidth))
				local normalizedValue = (clampedX - self.trackX) / self.trackWidth
				local value = self.minValue + (normalizedValue * (self.maxValue - self.minValue))
				
				-- Quantize to increment
				value = math.floor(value / self.quantize + 0.5) * self.quantize
				
				return math.max(self.minValue, math.min(self.maxValue, value))
			end,
			
			handleMousePressed = function(self, mx, my)
				local sliderTop = self.trackY - self.sliderHeight
				local sliderBottom = self.trackY + self.sliderHeight
				if mx >= self.trackX and mx <= self.trackX + self.trackWidth and
				my >= sliderTop and my <= sliderBottom then
					self.isDragging = true
					self:updateValue(mx, my)
					return true
				end
				return false
			end,
			
			handleMouseReleased = function(self)
				self.isDragging = false
			end,
			
			updateValue = function(self, mx, my)
				if not self.setValue then return end
				
				local newValue = self:xToValue(mx)
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
