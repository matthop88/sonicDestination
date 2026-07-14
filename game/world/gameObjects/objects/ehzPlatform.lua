return {
	create = function(self)
		return {
			player = nil,
			dipLevel = 0,
			origY = 0,

			onCreation = function(self)
				self.origY = self.y
			end,

			onCollisionWithPlayer = function(self, player)
				if player.standingOn ~= self and player.velocity.y > 0 and player.position.y < self.y then 
					player:landOn(self) 
					self.player = player
				end
			end,

			getLeftEdge = function(self)
				return self.x - self:getW() / 2
			end,

			getRightEdge = function(self)
				return self.x + self:getW() / 2
			end,

			getTop = function(self)
				return self.y - self:getH() / 2
			end,

			update = function(self, dt)
            	if self.player then
            		if self.player.standingOn == self then
            			if self.dipLevel < 25 then
	                		self.dipLevel = math.min(25, self.dipLevel + (100 * dt))
	                		self.player:landOn(self)
	                	end
	                else
	                	if self.dipLevel > 0 then
	                		self.dipLevel = math.max(0, self.dipLevel - (100 * dt))
	                	end
	                end
                end
                self.y = self.origY + math.max(0, self.dipLevel - 10)
                self.sprite:update(dt)
                self:updateHitBox(dt)
                self.deleted = self.sprite.deleted
            end,
		}
	end,
}
