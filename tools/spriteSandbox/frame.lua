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
			rolledOver   = false,
			
			update = function(self, dt)
				local time = love.timer.getTime() - self.creationTime
				local prevFrameNumber = self.frameNumber
				self.frameNumber = (math.floor(time * self.animation.fps) % #self.animation) + 1
				if self.frameNumber < prevFrameNumber then self.rolledOver = true end
			end,

			get = function(self)
				return self.animation[math.floor(self.frameNumber)]
			end,

			isRolledOver = function(self)
				if self.rolledOver then
					self.rolledOver = false
					return true
				end
			end,

			getFirst     = function(self) return self.animation[1]     end,
			isForeground = function(self) 
				if #self.animation > 0 then return self:get().foreground end
			end,
		}
	end,
}
