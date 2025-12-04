return {
	create = function(self, params)
		return {
			player = params.player,
			world  = params.world,

			getPlayer = function(self)
				return self.player
			end,

			getWorld  = function(self)
				return self.world
			end,
		}
	end,
}
