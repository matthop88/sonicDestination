return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if player.isStandingOn ~= self and player.velocity.y > 0 and player.position.y < self.y then 
					player:landOn(self) 
				end
			end,

			getLeftEdge = function(self)
				return self.x - self:getW() / 2
			end,

			getRightEdge = function(self)
				return self.x + self:getW() / 2
			end,
		}
	end,
}
