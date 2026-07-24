return {
	create = function(self)
		return {
			player = nil,
			destroyed = false,

			onCollisionWithPlayer = function(self, player)
				if not self.destroyed then 
					self.player = player
					if player:isSpinning() then
						self:setAnimation("exploding")
						self.destroyed = true
					elseif player.velocity.y == 0 then
						player:move(self:getHitBox():calculatePushOnOther(player:getHitBox()), 0)
						if (player.velocity.x > 0 and player.position.x < self.x) or (player.velocity.x < 0 and player.position.x > self.x) then
							player:setPushing(self)
						end
					end
				end
			end,

			update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                    self:setX(self:getX() + (self:getXVelocity() * dt))
                    self:setY(self:getY() + (self:getYSpeed()    * dt))
                    self.hitSolid = false
                end
            end,

			getLeftEdge = function(self)
				return self.x - self:getW() / 2
			end,

			getRightEdge = function(self)
				return self.x + self:getW() / 2
			end,

			getTop = function(self)
				return (self.y - self:getH() / 2) - 3
			end,

			isPlatform = function(self)
				return not self.destroyed
			end,
		}
	end,
}
