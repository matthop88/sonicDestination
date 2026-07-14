return {
	create = function(self)
		return {
			player = nil,
			
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
				return (self.y - self:getH() / 2) - 3
			end,
		}
	end,
}
