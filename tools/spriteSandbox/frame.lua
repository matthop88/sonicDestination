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
			frameNumber  = 1,
			animation    = animation,
			creationTime = love.timer.getTime(),

			update = function(self, dt)
				local time = love.timer.getTime() - self.creationTime
				self.frameNumber = (math.floor(time * self.animation.fps) % #self.animation) + 1
			end,

			get = function(self)
				return self.animation[math.floor(self.frameNumber)]
			end,
		}
	end,
}
