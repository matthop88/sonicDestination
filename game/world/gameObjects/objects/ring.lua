return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				self:setAnimation("dissolving")
				player:collectRings(1)
			end,
		}
	end,
}
