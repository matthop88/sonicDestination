local SOUND_MANAGER = requireRelative("sound/soundManager")

local ACCELERATION = 100
local MAX_SPEED    = 180

return {
	create = function(self)
		return {
			rotation = 0,
			vector   = 0,
			colliding = { false, false },

			onCollisionWithPlayer = function(self, player)
				if self.colliding[2] == false then
					if player:getX() < self:getX() then
						self.vector = -1
					else
						self.vector = 1
					end
				end
				self.colliding = { true, true }
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
            	if self.colliding[1] then
            		if self.vector == -1 then
            			self.xSpeed = math.max(-MAX_SPEED, self.xSpeed - (ACCELERATION * dt))
            		else
            			self.xSpeed = math.min(MAX_SPEED, self.xSpeed + (ACCELERATION * dt))
            		end
            		self.colliding[1] = false
            	else
            		if self.vector == -1 then
            			self.xSpeed = math.min(0, self.xSpeed + (ACCELERATION * dt))
            		else
            			self.xSpeed = math.max(0, self.xSpeed - (ACCELERATION * dt))
            		end
            		if self.xSpeed == 0 then self.vector = 0 end
            		self.colliding[2] = false
            	end
            end,

		}
	end,            
}
