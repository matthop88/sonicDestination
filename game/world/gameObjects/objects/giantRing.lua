return {
	create = function(self)
		return {
			scale         = 0.1,
			
			update = function(self, dt)
				self.super:update(dt)
				self:updateGiantRingActivity(dt)
				self.sprite.scale.x = self.scale
				self.sprite.scale.y = self.scale
			end,

			updateGiantRingActivity = function(self, dt)
				local active       = GLOBALS:getPlayer():getRingCount() >= 50
				
				if   active then self.scale = math.min(1,   self.scale + (dt * 3))
				else             self.scale = math.max(0.1, self.scale - (dt * 3)) end

				self.active       = self.scale > 0.1
				self.super.active = self.active
			end,
		}
	end,            
}
