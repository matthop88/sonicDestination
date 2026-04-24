local SOUND_MANAGER  = requireRelative("sound/soundManager")
local SCRIPT_REPO    = requireRelative("world/badniks/scripts/lib/scriptRepo")

return {
	create = function(self)
		local SENSOR_DX = 10
		local SENSOR_DY = 21

		return {
			script   = SCRIPT_REPO:get("pacingBackAndForth"),

			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("motobugDying")
					self:setDead()
					SOUND_MANAGER:play("badnikDeath")
        			player:reboundIfPossible(self.y, 180)
				end
			end,

			onCollisionWithDangerousToNPCs = function(self, dangerousObject)
				if not dangerousObject.isDangerousTo or dangerousObject:isDangerousTo(self) then
					self:setAnimation("motobugDying")
					self:setDead()
					SOUND_MANAGER:play("badnikDeath")
				end
			end,

			onCollisionWithSolid = function(self, solidObject)
				if  (solidObject:getX() < self:getX() and not self.xFlip)
			     or (solidObject:getX() > self:getX() and     self.xFlip) then
			     	self.hitSolid = true
			     	self.xSpeed = 0
			     end
			     self.x = self.x + solidObject:getHitBox():calculatePushOnOther(self:getHitBox())
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
