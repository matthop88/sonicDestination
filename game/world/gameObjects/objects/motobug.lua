return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				self:setAnimation("motobugDying")
			end,
		}
	end,
}
