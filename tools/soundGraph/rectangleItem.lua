return {
	create = function(self, params)
		return {
			color = params.color or { 0, 1, 0 },
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 25,
			notSelectable = params.notSelectable or false,
			pressed = false,

			draw = function(self)
				if self.pressed then
					love.graphics.setColor(1, 1, 1)
					love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
					
					love.graphics.setColor(0, 0, 0)
				else
					love.graphics.setColor(self.color)
				end
				
				love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width - 10, self.height - 10)
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
				return "Rectangle(" .. self.color[1] .. ", " .. self.color[2] .. ", " .. self.color[3] .. ")"
			end,
		}
	end,
}
