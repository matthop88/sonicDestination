local WORLD

local SENSOR_COLOR = { 0.5, 1, 0, 0.7 }

return {
	create = function(self, params)
		WORLD    = params.WORLD
		
		return {
			owner     = params.OWNER,
			graphics  = params.GRAPHICS,
			dx        = params.dx,
			dy        = params.dy,
			visible   = false,
			hlCounter = 0,
			hlSolid   = nil,

			getX  = function(self) return self.owner:getX() + self:getDx() end,
			getY  = function(self) return self.owner:getY() + self:getDy() end,

			getDx = function(self)
				if self.owner:getXFlip() then return  self.dx
				else                          return -self.dx end
			end,

			getDy = function(self) return self.dy                          end,

			draw = function(self)
				if self.visible then
					GRAFX:setColor(SENSOR_COLOR)
					GRAFX:rectangle("fill", self:getX() - 2, self:getY() - 2, 4, 4)

					if self.hlSolid and self.hlCounter > 0 then
						WORLD:drawSolidAt(self.hlSolid.x, self.hlSolid.y, { 1, 0, 0, self.hlCounter })
					end
				end
			end,

			scan = function(self)
				local solid = WORLD:getSolidAt(self:getX(), self:getY())
				if solid == 1 then
					if self.visible then
						self.hlSolid = { x = math.floor(self:getX() / 16) * 16, y = math.floor(self:getY() / 16) * 16 }
						self.hlCounter = 1
					end
					return true
				end
			end,

			update = function(self, dt)
				self.hlCounter = math.max(self.hlCounter - (dt * 3), 0)
			end,

			toggleShow = function(self) self.visible = not self.visible end,
		}
	end,
}
