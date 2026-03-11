return {
	create = function(self, params)
		local COLORS = require("tools/lib/colors")
		
		return {
			text = params.text,
			font = params.font,
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 25,
			notSelectable = params.notSelectable or false,
			pressed = false,

			draw = function(self)
				if self.pressed then
					self:drawReversedText()
				else
					self:drawWhiteText()
				end
			end,

			drawReversedText = function(self)
				love.graphics.setColor(COLORS.PURE_WHITE)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				
				love.graphics.setColor(COLORS.JET_BLACK)
				self:drawText()
			end,

			drawWhiteText = function(self)
				love.graphics.setColor(COLORS.PURE_WHITE)
				self:drawText()
			end,

			drawText = function(self)
				local textY = self.y + (self.height - self.font:getHeight()) / 2
				love.graphics.setFont(self.font)
				love.graphics.print(self.text, self.x + 5, textY)
			end,

			setPressed = function(self, pressed)
				self.pressed = pressed
			end,

			update = function(self, dt)
			end,

			containsPt = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,

			getValue = function(self)
				return self.text
			end,
		}
	end,
}
