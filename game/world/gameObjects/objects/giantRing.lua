local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			scale          = 0.1,
			isArriving     = false,
			isDeparting    = false,
			speed          = 3,
			
			update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                end
                self:updateGiantRingActivity(dt)
				self.sprite.scale.x = self.scale
				self.sprite.scale.y = self.scale
				self:updatePlayer(dt)
            end,

            updateGiantRingActivity = function(self, dt)
            	local active
            	if     self.isDeparting then active = false
            	elseif self.isArriving  then active = true
            	else                         active = GLOBALS:getPlayer():getRingCount() >= 50 end
				
				if   active then self.scale = math.min(1,   self.scale + (dt * self.speed))
				else             self.scale = math.max(0.1, self.scale - (dt * self.speed)) end

				if self.isArriving and self.player then self.player:setScale(self.scale) end

				self.active  = self.scale > 0.1
			end,

			updatePlayer = function(self, dt)
				if self.player and (self.isArriving or self.isDeparting) and not self.player.airDrag and self.player:isGrounded() then
					self.player:setBraking()
					self.player.airDrag = true
				end
			end,

			drawHitBox = function(self)
                local hitBox = self:getHitBox()
                if hitBox then 
                	hitBox:draw(self.graphics, { 1, 0, 0, 0.8 }, 2) 
                end
            end,

            onTerminalCollisionWithPlayer = function(self, player)
				if not self.isArriving and self.active then
					self:setAnimation("giantDissolving")
					SOUND_MANAGER:play("giantRing")
					player:airDragOff()
					local destination = self:getDestination()
					local map = destination.map
					local x   = destination.coordinates.x
					local y   = destination.coordinates.y
					GLOBALS:getWorld():teleport(map, x, y, self, player)
				end
			end,

			getDestination = function(self)
				local destination = self.object.destination
				if #destination > 0 then
					return destination[love.math.random(1, #destination)]
				else
					return destination
				end
			end,

			arrive = function(self, x, y, player)
				self.player = player
				self.isArriving = true
				self:setAnimation("giantSpinning")
				self.x, self.y = x, y
				self.scale = 0.1
				self.player:setScale(0.1)
				self.sprite.scale.x = self.scale
				self.sprite.scale.y = self.scale
				self.speed = 1.5
			end,

			depart = function(self)
				self.isDeparting = true
				self.isArriving  = false
				self.active      = false
			end,

		}
	end,            
}
