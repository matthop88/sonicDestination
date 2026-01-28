return {
	create = function(self, dx, dy)
		return {
			dx = dx,
			dy = dy,

			getDx = function(self, xFlip)
				if xFlip then return  self.dx
				else          return -self.dx end
			end,

			draw = function(self, GRAFX, x, y, xFlip)
				GRAFX:setColor(0.5, 1, 0, 0.7)
				GRAFX:rectangle("fill", x + self:getDx(xFlip) - 2, y + self.dy - 2, 4, 4)
			end,

			scan = function(self, x, y, world, xFlip)
				local solid = world:getSolidAt(x + self:getDx(xFlip), y + self.dy)
				if solid then
					solid.redAlpha = 1
				end
			end,
		}
	end,
}
