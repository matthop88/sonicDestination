local SOUND_MANAGER  = requireRelative("sound/soundManager")
local SCRIPT_REPO    = requireRelative("world/badniks/scripts/lib/scriptRepo")
local SCRIPT_ENGINE  = requireRelative("world/badniks/scripts/lib/scriptEngine")

return {
	create = function(self)
		local SENSOR_DX = 10
		local SENSOR_DY = 21

		return {
			script         = SCRIPT_REPO:get("chargingBackAndForth"),
			dangerousSpeed = 175,
			fallingToDeath = false,

			onCollisionWithPlayer = function(self, player)
				if player:isSpinning() then
					self:setAnimation("tamabbohDying")
					self:setDead()
					SOUND_MANAGER:playAction("badnikHit")
        			player:reboundIfPossible(self.y, 180)
				end
			end,

			onCollisionWithDangerousToNPCs = function(self, dangerousObject)
				if not dangerousObject.isDangerousTo or dangerousObject:isDangerousTo(self) then
					self:setAnimation("tamabbohDying")
					if dangerousObject.notifyBadnikDeath then
						dangerousObject:notifyBadnikDeath(self)
					end
					self:setDead()
					SOUND_MANAGER:playAction("badnikHit")
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

			update = function(self, dt)
                if self.active then
                	self:initGravityScanner()
                	local nearestGroundLevel = nil
                	if self.ySpeed >= 0 and not self.fallingToDeath then
                		nearestGroundLevel = self.gravityScanner:findNearestGroundWithin(self.ySpeed * dt)
                		if nearestGroundLevel == nil and self.ySpeed == 0 then
							if not self.gravityScanner:findNearestGroundWithin(8192) then
								self.fallingToDeath = true
								SOUND_MANAGER:playAction("badnikFalling")
							end
						end
                	end
                	if nearestGroundLevel == nil then
                		self.ySpeed = self.ySpeed + (787.0 * dt)
                	end
                    if self.script and self:isAlive() then SCRIPT_ENGINE:execute(dt, self.script, self) end
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                    local deltaY = self.ySpeed * dt
                    if nearestGroundLevel and nearestGroundLevel < deltaY then 
						if self.ySpeed > 0 then
							self:setY(self:getY() + nearestGroundLevel)
							self.ySpeed = 0
						end
					else
						self:setY(self:getY() + deltaY)
                    end
                    self:setX(self:getX() + (self:getXVelocity() * dt))
                    self.hitSolid = false
                    if self.y >= 65536 then self.deleted = true end
                end
            end,

			initGravityScanner = function(self)
            	if not self.gravityScanner then
            		self.gravityScanner = requireRelative("collision/sensors/badniks/groundScanner"):create { OWNER = self, GRAPHICS = self.graphics, WORLD = self.world, dx = -6, dy = 21 }
            	end
            end,

		}
	end,
}
