local SOUND_MANAGER  = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if self.active then
					self:setAnimation("animatingRed")
					-- Play some sound here
				end
			end,
		}
	end,
}
