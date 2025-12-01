return {
	create = function(self)
		return {
			update = function(self, dt)
				self.super:update(dt)
				self:updateGiantRingActivity(dt)
			end,

			updateGiantRingActivity = function(self, dt)
				self.active = GLOBALS:getPlayer():getRingCount() >= 50
			end,
		}
	end,            
}
