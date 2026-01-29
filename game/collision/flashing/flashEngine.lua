return {
	create = function(self, params)
		return {
			frameCount = params.frameCount or 4,

			active  = false,
			timer   = 0,
			visible = true,

			update = function(self, dt)
				if self.active then
					self.timer = self.timer + (dt * 60)
					if self.timer % (self.frameCount * 2) < self.frameCount then self.visible = true
					else                                                         self.visible = false end
				else
					self.visible = true
				end
			end,

			isVisible   = function(self) return self.visible           end,
			isFlashing  = function(self) return self.active            end,
			toggleFlash = function(self) self.active = not self.active end,
		}
	end,
}
