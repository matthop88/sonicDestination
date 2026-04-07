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

			draw = function(self, graphics)
				if self.pressed then
					self:drawReversedText(graphics)
				else
					self:drawWhiteText(graphics)
				end
			end,

			drawReversedText = function(self, graphics)
				graphics:setColor(COLORS.PURE_WHITE)
				graphics:rectangle("fill", self.x, self.y, self.width, self.height)
				
				graphics:setColor(COLORS.JET_BLACK)
				self:drawText(graphics)
			end,

			drawWhiteText = function(self, graphics)
				graphics:setColor(COLORS.PURE_WHITE)
				self:drawText(graphics)
			end,

			drawText = function(self, graphics)
				local textY = self.y + (self.height - self.font:getHeight()) / 2
				graphics:setFont(self.font)
				graphics:print(self.text, self.x + 5, textY)
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
