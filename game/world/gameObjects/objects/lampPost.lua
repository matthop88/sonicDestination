local SOUND_MANAGER  = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if self.active and not self.triggered then
					self:setAnimation("animatingRed")
					SOUND_MANAGER:playAction("lampPost")
					self.triggered = true
				end
			end,
		}
	end,
}
