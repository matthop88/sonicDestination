local FRAME_REPOSITORY = {}

return {
	create = function(self, animation, syncName)
		if syncName ~= nil then
			if not FRAME_REPOSITORY[syncName] then
				FRAME_REPOSITORY[syncName] = self:createIntern(animation)
			end
			return FRAME_REPOSITORY[syncName]
		else
			return self:createIntern(animation)
		end
	end,

	createIntern = function(self, animation)
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
