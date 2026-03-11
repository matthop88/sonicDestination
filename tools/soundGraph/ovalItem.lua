return {
	create = function(self, params)
		return {
			color = params.color or { 1, 0, 0 },
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 25,
			pressed = false,

			draw = function(self)
				if self.pressed then
					love.graphics.setColor(1, 1, 1)
					love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
					
					love.graphics.setColor(0, 0, 0)
				else
					love.graphics.setColor(self.color)
				end
				
				local cx = self.x + self.width / 2
				local cy = self.y + self.height / 2
				local rx = self.width / 2 - 5
				local ry = self.height / 2 - 5
				love.graphics.ellipse("fill", cx, cy, rx, ry)
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
