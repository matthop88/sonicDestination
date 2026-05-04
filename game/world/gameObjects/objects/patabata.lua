local SOUND_MANAGER  = requireRelative("sound/soundManager")
local SCRIPT_REPO    = requireRelative("world/badniks/scripts/lib/scriptRepo")

return {
	create = function(self)
		return {
			script          = SCRIPT_REPO:get("sineWaveBackAndForth"),
			immuneToGravity = true,

			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("dying")
					self:setDead()
					SOUND_MANAGER:playAction("badnikHit")
        			player:reboundIfPossible(self.y, 90)
				end
			end,

			onCollisionWithDangerousToNPCs = function(self, dangerousObject)
				self:setAnimation("dying")
				if dangerousObject.notifyBadnikDeath then
					dangerousObject:notifyBadnikDeath(self)
				end 
				self:setDead()
				SOUND_MANAGER:playAction("badnikHit")
			end,
		}
	end,
}
