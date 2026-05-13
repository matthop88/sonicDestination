local SOUND_MANAGER  = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				if self.active and not self.triggered then
					self:setAnimation("animatingRed")
					SOUND_MANAGER:playAction("lampPost")
					self.postLampTimer = 15
					self.triggered = true
				end
			end,

			update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self.deleted = self.sprite.deleted
                    self:updateHitBox(dt)
                    if self.postLampTimer then
                    	self.postLampTimer = self.postLampTimer - (60 * dt)
                    	if self.postLampTimer < 0 then
                    		SOUND_MANAGER:playAction("postLamp")
							self.postLampTimer = nil
						end
					end
                end
            end,
		}
	end,
}
