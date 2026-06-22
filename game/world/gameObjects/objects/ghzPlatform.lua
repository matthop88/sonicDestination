return {
	create = function(self)
		return {
			onCollisionWithPlayer = function(self, player)
				print("Platform collided with player")
			end,
		}
	end,
}
