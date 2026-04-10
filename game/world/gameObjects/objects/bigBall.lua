local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			rotation = 0,

			onCollisionWithPlayer = function(self, player)
				self:setXSpeed(-16 * math.pi)
			end,

			draw = function(self) 
                if self.active then
                    self.sprite:drawRotated(self.x, self.y, self.rotation) 
                end
                if self.selectedInVisualizer then
                    self.sprite:drawBorder(self.x, self.y)
                end
            end,

            update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                    local deltaX = self:getXVelocity() * dt
                    self:setX(self:getX() + deltaX)
                    self.rotation = self.rotation + (deltaX / 24)
                    self:setY(self:getY() + (self:getYSpeed()    * dt))
                    
                end
            end,

		}
	end,            
}
