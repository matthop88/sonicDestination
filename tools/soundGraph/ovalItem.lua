return {
	create = function(self, params)
		return {
			color = params.color or { 1, 0, 0 },
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 25,
			notSelectable = params.notSelectable or false,
			pressed = false,

			draw = function(self, graphics)
				if self.pressed then
					graphics:setColor(1, 1, 1)
					graphics:rectangle("fill", self.x, self.y, self.width, self.height)
					
					graphics:setColor(0, 0, 0)
				else
					graphics:setColor(self.color)
				end
				
				local cx = self.x + self.width / 2
				local cy = self.y + self.height / 2
				local rx = self.width / 2 - 5
				local ry = self.height / 2 - 5
				graphics:ellipse("fill", cx, cy, rx, ry)
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
				return "Oval(" .. self.color[1] .. ", " .. self.color[2] .. ", " .. self.color[3] .. ")"
			end,
		}
	end,
}
