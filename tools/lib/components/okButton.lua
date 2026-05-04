local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		local buttonFontSize = params.fontSize or 16
		local buttonFont     = love.graphics.newFont(buttonFontSize)

		return {
			x = params.x,
			y = params.y,
			width = params.width or 100,
			height = params.height or 40,
			hovered = false,
			cornerRadius = 10,
			
			draw = function(self)
				if self.hovered then
					love.graphics.setColor(COLOR.MEDIUM_GREY)
				else
					love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
				end
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
				
				love.graphics.setFont(buttonFont)
				love.graphics.printf("OK", self.x, self.y + 10, self.width, "center")
			end,
			
			update = function(self, mx, my)
				self.hovered = self:containsPoint(mx, my)
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
		}
	end,
}
