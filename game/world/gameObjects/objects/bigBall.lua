local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
	create = function(self)
		return {
			rotation = 0,
			acceleration = -150,
			colliding = false,

			onCollisionWithPlayer = function(self, player)
				self.colliding = true
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
                	if self.colliding then
                		self.xSpeed = self.xSpeed + (self.acceleration * dt)
                	else
                		self.xSpeed = math.min(0, self.xSpeed - (self.acceleration * dt))
                	end
                	self.colliding = false
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
