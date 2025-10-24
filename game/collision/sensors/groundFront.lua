local WORLD

return {
	init = function(self, params)
		WORLD    = params.WORLD
		
		return {
			owner    = params.OWNER,
			graphics = params.GRAPHICS,
			x        = nil,
			y        = nil,

			draw = function(self)
				local xOffset = 9
				if self.owner:isFacingLeft() then xOffset = xOffset * -1 end

				self.graphics:setColor(0.13, 0.93, 0.19)
				self.graphics:line(self.x, self.y - 20, self.x, self.y)
				self.graphics:setColor(1,    1,    1)
				self.graphics:line(self.x, self.y -  1, self.x, self.y)
			end,

			update = function(self, dt)
				local xOffset = 9
				if self.owner:isFacingLeft() then xOffset = xOffset * -1 end
				self.x = self.owner:getX() + xOffset
				self.y = self.owner:getY() + 20
			end,

			scan = function(self)
			end,
		}
	end,
}
