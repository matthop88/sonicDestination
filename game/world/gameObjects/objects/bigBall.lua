local SOUND_MANAGER = requireRelative("sound/soundManager")

local ACCELERATION = 100
local MAX_SPEED    = 180

return {
	create = function(self)
		return {
			rotation = 0,
			vector   = 0,
			colliding = false,

			onCollisionWithPlayer = function(self, player)
				self.colliding = true
				if player:getX() < self:getX() then
					self.vector = -1
				else
					self.vector = 1
				end
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
                	self:calculateSpeed(dt)
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                    local deltaX = self:getXVelocity() * dt
                    self:setX(self:getX() + deltaX)
                    self.rotation = self.rotation + (deltaX / 24)
                    self:setY(self:getY() + (self:getYSpeed()    * dt))
                    
                end
            end,

            calculateSpeed = function(self, dt)
            	if self.colliding then
            		if self.vector == -1 then
            			self.xSpeed = math.max(-MAX_SPEED, self.xSpeed - (ACCELERATION * dt))
            		else
            			self.xSpeed = math.min(MAX_SPEED, self.xSpeed + (ACCELERATION * dt))
            		end
            	else
            		if self.vector == -1 then
            			self.xSpeed = math.min(0, self.xSpeed + (ACCELERATION * dt))
            		else
            			self.xSpeed = math.max(0, self.xSpeed - (ACCELERATION * dt))
            		end
            	end
            	self.colliding = false
            end,

		}
	end,            
}
