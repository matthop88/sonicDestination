local SOUND_MANAGER = requireRelative("sound/soundManager")

local ACCELERATION = 100
local MAX_SPEED    = 180

return {
	create = function(self)
		local SENSOR_DX = 15
		local SENSOR_DY = 31

		return {
			rotation = 0,
			vector   = 0,
			colliding = { false, false },
			xFlip    = true,
			
			onCollisionWithPlayer = function(self, player)
				if self.colliding[2] == false then
					if player:getX() < self:getX() then
						self.xFlip = true
					else
						self.xFlip = false
					end
				end
				self.colliding = { true, true }
			end,

			isDangerousToNPCs = function(self)
				return true
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
                    local deltaX = self.xSpeed * dt
                    self:setX(self:getX() + deltaX)
                    self.rotation = self.rotation + (deltaX / 24)
                    self:setY(self:getY() + (self:getYSpeed()    * dt))
                    if self.xSpeed ~= 0 then 
                    	self.world:checkCollisions(self)
                    end
                end
            end,

            calculateSpeed = function(self, dt)
            	if not self:scanGround() then
					self.xSpeed = 0
					self.colliding[2] = false
					return
				end
				if self.colliding[1] then
            		if not self.xFlip then
            			self.xSpeed = math.max(-MAX_SPEED, self.xSpeed - (ACCELERATION * dt))
            		else
            			self.xSpeed = math.min(MAX_SPEED, self.xSpeed + (ACCELERATION * dt))
            		end
            		self.colliding[1] = false
            	else
            		if not self.xFlip then
            			self.xSpeed = math.min(0, self.xSpeed + (ACCELERATION * dt))
            		else
            			self.xSpeed = math.max(0, self.xSpeed - (ACCELERATION * dt))
            		end
            		self.colliding[2] = false
            	end
            end,

			scanGround = function(self)
				if not self.groundScanner then
					self.groundScanner = requireRelative("collision/sensors/badniks/groundScanner"):create { OWNER = self, GRAPHICS = self.graphics, WORLD = self.world, dx = SENSOR_DX, dy = SENSOR_DY }
				end

				return self.groundScanner:scan()
			end,

			getXFlip = function(self)
				return self.xFlip
			end,

		}
	end,            
}
