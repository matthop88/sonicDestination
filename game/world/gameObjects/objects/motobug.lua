return {
	create = function(self)
		return {
			onTerminalCollisionWithPlayer = function(self, player)
				self:setAnimation("motobugDying")
			end,
		}
	end,
}
