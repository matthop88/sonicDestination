return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("motobugDying")
				end
			end,
		}
	end,
}
