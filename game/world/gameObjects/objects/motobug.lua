local SOUND_MANAGER  = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("motobugDying")
					SOUND_MANAGER:play("badnikDeath")
        			player:reboundIfPossible(self.y)
				end
			end,
		}
	end,
}
