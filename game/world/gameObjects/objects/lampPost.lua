local SOUND_MANAGER  = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if self.active then
					self:setAnimation("animatingRed")
					SOUND_MANAGER:playAction("lampPost")
				end
			end,
		}
	end,
}
