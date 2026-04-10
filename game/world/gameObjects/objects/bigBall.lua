local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				self:setXSpeed(3)
			end,

		}
	end,            
}
