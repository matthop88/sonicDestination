local SOUND_MANAGER = requireRelative("sound/soundManager")

local ACCELERATION     = 100
local AIR_ACCELERATION = 5
local MAX_SPEED        = 180

return {
	create = function(self)
		local SENSOR_DX = 10
		local SENSOR_DY = 31

		return {
			rotation = 0,
			vector   = 0,
			colliding = { false, false },
			xFlip    = true,
			player   = nil,
			
			onCollisionWithPlayer = function(self, player)
				player:move(self:getHitBox():calculatePushOnOther(player:getHitBox()), 0)
				if not player:isPushing() or player:getPushing() == self then
					if self.colliding[2] == false then
						if player:getX() < self:getX() then
							self.xFlip = true
						else
							self.xFlip = false
						end
					end
					self.player = player
					self.player:setPushing(self)
					self.colliding = { true, true }
					return true
				end
			end,

			isDangerousToNPCs = function(self)
				return self.xSpeed ~= 0
			end,

			isDangerousTo = function(self, other)
				return math.abs(self.xSpeed - other.xSpeed) > 100 
			end,

			isSolid = function(self)
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
                	self:initGravityScanner()
                	self:calculateSpeed(dt)
                	local nearestGroundLevel = nil
                	if self.ySpeed >= 0 then
                		nearestGroundLevel = self.gravityScanner:findNearestGroundWithin(self.ySpeed * dt)
                	end
                	if nearestGroundLevel == nil then
                		self.ySpeed = self.ySpeed + (787.0 * dt)
                	end
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                    local tempSpeed = self.xSpeed
                    if self.ySpeed == 0 then
                    	if tempSpeed > 0 then tempSpeed = math.max(0, tempSpeed - 30)
                    	else                  tempSpeed = math.min(0, tempSpeed + 30) end
                    end
                    local deltaX = tempSpeed * dt
                    local deltaY = self.ySpeed * dt
                    if nearestGroundLevel and nearestGroundLevel < deltaY then 
						if self.ySpeed > 0 then
							self.ySpeed = -(self.ySpeed / 2.5)
							if math.abs(self.ySpeed) < 5 then self.ySpeed = 0 end
							self:setY(self:getY() + nearestGroundLevel)
							SOUND_MANAGER:play("thud")
						end
					else
						self:setY(self:getY() + deltaY)
                    end
                    local prevX = self.x
                    self:setX(self:getX() + deltaX)
                    self.rotation = self.rotation + (deltaX / 24)
                    self.world:checkCollisions(self)
                    if self.y >= 65536 then self.deleted = true end
                end
            end,

            initGravityScanner = function(self)
            	if not self.gravityScanner then
            		self.gravityScanner = requireRelative("collision/sensors/badniks/groundScanner"):create { OWNER = self, GRAPHICS = self.graphics, WORLD = self.world, dx = -6, dy = 24 }
            	end
            end,

            calculateSpeed = function(self, dt)
            	if not self:scanGround() and not (self.player and self.player:getPushing() == self) and self.ySpeed == 0 then
					self.xSpeed = 0
					self.colliding[1] = false
					self.colliding[2] = false
					if self.player and self.player:getPushing() == self then
						self.player:clearPushing()
						self.player = nil
					end
					return
				end
				if self.colliding[1] then
            		if not self.xFlip then
            			self.xSpeed = math.max(-MAX_SPEED, self.xSpeed - (self:getAcceleration() * dt))
            		else
            			self.xSpeed = math.min(MAX_SPEED, self.xSpeed + (self:getAcceleration() * dt))
            		end
            		self.colliding[1] = false
            	else
            		if not self.xFlip then
            			self.xSpeed = math.min(0, self.xSpeed + (self:getAcceleration() * dt))
            		else
            			self.xSpeed = math.max(0, self.xSpeed - (self:getAcceleration() * dt))
            		end
            		self.colliding[2] = false
            		if self.player and self.player:getPushing() == self then
            			self.player:clearPushing()
            			self.player = nil
            		end
            	end
            end,

			scanGround = function(self)
				if not self.groundScanner then
					self.groundScanner = requireRelative("collision/sensors/badniks/groundScanner"):create { OWNER = self, GRAPHICS = self.graphics, WORLD = self.world, dx = SENSOR_DX, dy = SENSOR_DY }
				end

				return self.groundScanner:scan()
			end,

			getAcceleration = function(self)
				if self.ySpeed == 0 then return ACCELERATION
				else                     return AIR_ACCELERATION end
			end,

			getXFlip = function(self)
				return self.xFlip
			end,

		}
	end,            
}
