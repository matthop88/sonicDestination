local WORLD

return {
	init = function(self, params)
		WORLD    = params.WORLD
		
		return {
			owner    = params.OWNER,
			graphics = params.GRAPHICS,
		}
	end,

	draw = function(self)
		self.graphics:setColor(0.13, 0.93, 0.19)
		self.graphics:line(self.owner:getX() + 15, self.owner:getY(), self.owner:getX() + 15, self.owner:getY() + 20)
	end,
}
