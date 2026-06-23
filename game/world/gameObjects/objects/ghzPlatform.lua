return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if player.isStandingOn ~= self then player:landOn(self) end
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
