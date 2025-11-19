return {
	create = function(self, animation)
		return {
			frameNumber = 1,
			animation   = animation,

			update = function(self, dt)
				self.frameNumber = self.frameNumber + ((self.animation.fps) * dt)
				if self.frameNumber >= #self.animation + 1 then
					self.frameNumber = self.frameNumber - #self.animation
				end
			end,

			get = function(self)
				return self.animation[math.floor(self.frameNumber)]
			end,
		}
	end,
}
