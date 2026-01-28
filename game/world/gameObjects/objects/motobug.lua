local SOUND_MANAGER  = requireRelative("sound/soundManager")
local SCRIPT_REPO    = requireRelative("world/badniks/scripts/lib/scriptRepo")

return {
	create = function(self)
		local SENSOR_DX = 10
		local SENSOR_DY = 20

		return {
			script   = SCRIPT_REPO:get("pacingBackAndForth"),

			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("motobugDying")
					SOUND_MANAGER:play("badnikDeath")
        			player:reboundIfPossible(self.y, 180)
				end
			end,

			scanGround = function(self)
				if not self.groundScanner then
					self.groundScanner = requireRelative("collision/sensors/badniks/groundScanner"):create { OWNER = self, GRAPHICS = self.graphics, WORLD = self.world, dx = SENSOR_DX, dy = SENSOR_DY }
				end

				return self.groundScanner:scan()
			end,

		}
	end,
}
