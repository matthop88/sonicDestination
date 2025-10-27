local WORLD

return {
	init = function(self, params)
		WORLD    = params.WORLD
		
		return {
			owner    = params.OWNER,
			graphics = params.GRAPHICS,
			x        = nil,
			y        = nil,
			visible  = false,

			draw = function(self)
				if self.visible then
					local xOffset = 9
					if self.owner:isFacingLeft() then xOffset = xOffset * -1 end

					self.graphics:setColor(0.13, 0.93, 0.19)
					self.graphics:line(self.x, self.y - 20, self.x, self.y)
					self.graphics:setColor(1,    1,    1)
					self.graphics:line(self.x, self.y -  1, self.x, self.y)
				end
			end,

			update = function(self, dt)
				local xOffset = 9
				if self.owner:isFacingLeft() then xOffset = xOffset * -1 end
				self.x = self.owner:getX() + xOffset
				self.y = self.owner:getY() + 20
				self:scan()
			end,

			scan = function(self)
				if WORLD:getSolidAt(self.x, self.y + 1) == 1 then
					self.owner.GROUND_LEVEL = (math.floor(self.y / 16) * 16) - 20
				else
					self.owner.GROUND_LEVEL = 1262
				end
			end,

			toggleShow = function(self) self.visible = not self.visible end,
		}
	end,
}
