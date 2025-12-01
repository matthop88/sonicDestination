return {
	create = function(self)
		return {
			onTerminalCollisionWithPlayer = function(self, player)
				self:setAnimation("dissolving")
				player:collectRings(1)
			end,
		}
	end,
}
