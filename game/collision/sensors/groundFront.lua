local WORLD

return {
	init = function(self, params)
		WORLD    = params.WORLD
		
		return {
			owner     = params.OWNER,
			graphics  = params.GRAPHICS,
			x         = nil,
			y         = nil,
			visible   = false,
			hlCounter = 0,
			hlSolid   = nil,

			draw = function(self)
				if self.visible then
					local xOffset = 9
					if self.owner:isFacingLeft() then xOffset = xOffset * -1 end

					self.graphics:setColor(0.13, 0.93, 0.19)
					self.graphics:line(self.x, self.y - 20, self.x, self.y)
					self.graphics:setColor(1,    1,    1)
					self.graphics:line(self.x, self.y -  1, self.x, self.y)
					if self.hlSolid and self.hlCounter > 0 then WORLD:drawSolidAt(self.hlSolid.x, self.hlSolid.y, { 1, 1, 0, self.hlCounter }) end
				end
			end,

			update = function(self, dt)
				local xOffset = 9
				if self.owner:isFacingLeft() then xOffset = xOffset * -1 end
				self.x = self.owner:getX() + xOffset
				self.y = self.owner:getY() + 20
				self:scan(dt)
				self.hlCounter = math.max(self.hlCounter - (dt * 3), 0)
			end,

			scan = function(self, dt)
				if self:scanForFallingOffPlatformEdge() then
					self.owner:fallOff()
				end
				self:scanForPlatforms()
				WORLD:refreshGroundLevel()
				local rayLength = (self.owner.velocity.y * dt) + 16
				if rayLength > 0 then
					local scanY = 1
					while rayLength > 0 do
						if WORLD:getSolidAt(self.x, self.y + scanY) == 1 then
							WORLD.GROUND_LEVEL = (math.floor((self.y + scanY) / 16) * 16) - 21
							self.hlSolid = { x = math.floor(self.x / 16) * 16, y = math.floor((self.y + scanY) / 16) * 16 }
							self.hlCounter = 1
							break
						else
							rayLength = rayLength - 16
							scanY = scanY + 16
						end
					end
				end
			end,

			scanForFallingOffPlatformEdge = function(self)
				if self.owner.standingOn then
					if self.owner:isFacingLeft() then
						return self.x < self.owner.standingOn:getLeftEdge()
					elseif self.owner:isFacingRight() then
						return self.x > self.owner.standingOn:getRightEdge()
					end
				end
				return false
			end,

			isWithinXBoundsOf = function(self, platform)
				if self.owner:isFacingLeft() then
					return self.x >= platform:getLeftEdge()
				elseif self.owner:isFacingRight() then
					return self.x <= platform:getRightEdge()
				end
				return false
			end,

			scanForPlatforms = function(self, dt)
				if not self.owner.standingOn and self.owner.velocity.y > 0 then
					WORLD.platforms:forEach(function(platform)
						local hitBox = platform:getHitBox()
                		if hitBox and hitBox:intersects(self.owner:getHitBox()) and self.owner.position.y < platform.y and self:isWithinXBoundsOf(platform) then
							self.owner:landOn(platform)
							return true
						end
					end)
            	end
			end,

			toggleShow = function(self) self.visible = not self.visible end,
		}
	end,
}
