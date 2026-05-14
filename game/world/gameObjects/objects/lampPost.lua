local SOUND_MANAGER  = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if self.active and not self.triggered then
					self:setAnimation("animatingRed")
					SOUND_MANAGER:playAction("lampPost")
					self.postLampTimer = 30
					self.triggered = true
					self.lastRecordedTime = self.world:getTime()
					self.lastRecordedPlayerPosition = { x = player:getX(), y = player:getY() }
					self.world:setLastTriggeredLampPost(self)
				end
			end,

			onCreation = function(self)
				if self.world.lastTriggeredLampPost and self.id == self.world.lastTriggeredLampPost.id then
					self:setTriggered()
				end
			end,

			createSpheres = function(self)
				self.spheres = { radius = 0, radOffset = 0, alpha = 0.03 }
			end,

			setTriggered = function(self)
				self:setAnimation("standingRed")
				self.triggered = true
			end,

			draw = function(self) 
                if self.active then
                    self.sprite:draw(self.x, self.y) 
                end
                if self.selectedInVisualizer then
                    self.sprite:drawBorder(self.x, self.y)
                end
                if self.spheres then
                	for i = 0, 16 do
						local rad = ((math.pi * 2 * i) / 16)
						local radius = self.spheres.radius
						local x = self.x + (math.cos(rad + self.spheres.radOffset) * radius)
						local y = self.y + (math.sin(rad + self.spheres.radOffset) * radius) - 24
                		self.graphics:setColor(1, 1, self.spheres.alpha / 2, math.min(0.7, self.spheres.alpha * 3))
                		self.graphics:circle("fill", x, y, math.max(6, radius / 3))
                	end
                end
            end,

			update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self.deleted = self.sprite.deleted
                    self:updateHitBox(dt)
                    if self.postLampTimer then
                    	local oldPostLampTimer = self.postLampTimer
                    	self.postLampTimer = self.postLampTimer - (60 * dt)
                    	if self.postLampTimer < 15 and oldPostLampTimer >= 15 then
                    		self:createSpheres()
						elseif self.postLampTimer < 0 then
							SOUND_MANAGER:playAction("postLamp")
							self.postLampTimer = nil
						end
					end
					if self.spheres then
						self.spheres.radOffset = self.spheres.radOffset + (20 * dt)
						if self.spheres.radOffset > (2 * math.pi) then self.spheres.radOffset = self.spheres.radOffset - (2 * math.pi) end
						self.spheres.radius = self.spheres.radius + (math.max(self.spheres.radius, 1) * 15 * dt)
						self.spheres.alpha = self.spheres.alpha + (self.spheres.alpha * 8 * dt)
						if self.spheres.radius > 500 then
							self.spheres = nil
						end
					end
                end
            end,
		}
	end,
}
