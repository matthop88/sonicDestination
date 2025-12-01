return {
	create = function(self)
		return {
			update = function(self, dt)
				self.super:update(dt)
				self:updateGiantRingActivity(dt)
			end,

			updateGiantRingActivity = function(self, dt)
				print("Updating Giant Ring Activity...")
			end,

		}
	end,
                
}
