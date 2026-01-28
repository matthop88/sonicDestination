return {
	create = function(self, dx, dy)
		return {
			dx = dx,
			dy = dy,

			draw = function(self, GRAFX, x, y)
				GRAFX:setColor(0.5, 1, 0, 0.7)
				GRAFX:rectangle("fill", x + self.dx - 2, y + self.dy - 2, 4, 4)
			end,
		}
	end,
}
