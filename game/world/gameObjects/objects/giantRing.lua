local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			scale          = 0.1,
			
			update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                end
                self:updateGiantRingActivity(dt)
				self.sprite.scale.x = self.scale
				self.sprite.scale.y = self.scale
            end,

            updateGiantRingActivity = function(self, dt)
				local active = GLOBALS:getPlayer():getRingCount() >= 50
				
				if   active then self.scale = math.min(1,   self.scale + (dt * 3))
				else             self.scale = math.max(0.1, self.scale - (dt * 3)) end

				self.active  = self.scale > 0.1
			end,

			drawHitBox = function(self)
                local hitBox = self:getHitBox()
                if hitBox then 
                	hitBox:draw(self.graphics, { 1, 0, 0, 0.8 }, 2) 
                end
            end,

            onTerminalCollisionWithPlayer = function(self, player)
				self:setAnimation("giantDissolving")
				player:deactivate()
				SOUND_MANAGER:play("giantRing")
				GLOBALS:getWorld():teleport()
			end,
		}
	end,            
}
