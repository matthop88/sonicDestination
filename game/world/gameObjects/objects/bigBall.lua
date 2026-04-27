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
                    local deltaX = self.xSpeed * dt
                    local deltaY = self.ySpeed * dt
                    if nearestGroundLevel and nearestGroundLevel < deltaY then
                    	if self.ySpeed > 0 then 
							self.ySpeed = 0
							SOUND_MANAGER:play("thud")
						end
						self:setY(self:getY() + nearestGroundLevel)
					else
						self:setY(self:getY() + deltaY)
                    end
                    local prevX = self.x
                    self:setX(self:getX() + deltaX)
                    self.rotation = self.rotation + (deltaX / 24)
                    self.world:checkCollisions(self)
                end
            end,

            initGravityScanner = function(self)
            	if not self.gravityScanner then
            		self.gravityScanner = requireRelative("collision/sensors/badniks/groundScanner"):create { OWNER = self, GRAPHICS = self.graphics, WORLD = self.world, dx = 24, dy = 24 }
            	end
            end,

            calculateSpeed = function(self, dt)
            	if not self:scanGround() then
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

			getXFlip = function(self)
				return self.xFlip
			end,

		}
	end,            
}
