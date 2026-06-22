return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if player.isStandingOn ~= self then player:landOn(self) end
			end,
		}
	end,
}
