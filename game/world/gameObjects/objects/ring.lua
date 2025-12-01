return {
	create = function(self)
		return {
			onTerminalCollisionWithPlayer = function(self, player)
				self:setAnimation("dissolving")
				player:collectRing(1)
			end,
		}
	end,
}
