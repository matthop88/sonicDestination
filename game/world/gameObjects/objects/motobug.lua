local SOUND_MANAGER  = requireRelative("sound/soundManager")
local SCRIPT_REPO    = requireRelative("world/badniks/scripts/lib/scriptRepo")

return {
	create = function(self)
		return {
			script   = SCRIPT_REPO:get("pacingBackAndForth"),

			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("motobugDying")
					SOUND_MANAGER:play("badnikDeath")
        			player:reboundIfPossible(self.y, 180)
				end
			end,
		}
	end,
}
