return {
	create = function(self, params)
		return {
			frameCount = params.frameCount or 4,
			duration   = params.duration   or 120,

			active  = false,
			timer   = 0,
			visible = true,

			update = function(self, dt)
				self.visible = true
				if self.timer >= self.duration then
					self.timer = 0
					self.active = false
				end
				if self.active then
					self.timer = self.timer + (dt * 60)
					if self.timer % (self.frameCount * 2) < self.frameCount then self.visible = true
					else                                                         self.visible = false end
				end
			end,

			isVisible   = function(self) return self.visible           end,
			isFlashing  = function(self) return self.active            end,
			setFlashing = function(self) self.active = true            end,
		}
	end,
}
