return {
	create = function(self)
		return {
			player = nil,
			dipLevel = 0,
			origY = 0,

			onCreation = function(self)
				self.origY = self.y
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
            			if self.dipLevel < 15 then
	                		self.dipLevel = math.min(15, self.dipLevel + (50 * dt))
	                		self.player:landOn(self)
	                	end
	                else
	                	if self.dipLevel > 0 then
	                		self.dipLevel = math.max(0, self.dipLevel - (50 * dt))
	                	end
	                end
                end
                self.y = self.origY + math.max(0, self.dipLevel - 5)
                self.sprite:update(dt)
                self:updateHitBox(dt)
                self.deleted = self.sprite.deleted
            end,
            
            isPlatform = function(self)
				return true
			end,
		}
	end,
}
