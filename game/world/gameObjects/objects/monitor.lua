return {
	create = function(self)
		return {
			player = nil,

			onCollisionWithPlayer = function(self, player)
				if player.velocity.y == 0 then
					player:move(self:getHitBox():calculatePushOnOther(player:getHitBox()), 0)
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
				return true
			end,
		}
	end,
}
