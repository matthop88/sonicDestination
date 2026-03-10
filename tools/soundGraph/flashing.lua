return {
	create = function(self, params)
		return {
			flashCount = params.flashCount or 2,
			flashDuration = params.flashDuration or 0.15,
			
			active = false,
			timer = 0,
			currentCount = 0,
			state = false,

			start = function(self)
				self.active = true
				self.timer = 0
				self.currentCount = 0
				self.state = true
			end,

			update = function(self, dt)
				if not self.active then return end
				
				self.timer = self.timer + dt
				if self.timer >= self.flashDuration then
					self.timer = 0
					self.state = not self.state
					if self.state then
						self.currentCount = self.currentCount + 1
						if self.currentCount >= self.flashCount then
							self:stop()
						end
					end
				end
			end,

			stop = function(self)
				self.active = false
				self.currentCount = 0
				self.state = false
			end,

			isFlashing = function(self)
				return self.active and self.state
			end,

			isActive = function(self)
				return self.active
			end,
		}
	end,
}
