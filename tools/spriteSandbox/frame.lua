local FRAME_REPOSITORY = {}

return {
	create = function(self, animation, syncName)
		if syncName ~= nil then
			if not FRAME_REPOSITORY[syncName] then
				FRAME_REPOSITORY[syncName] = self:createIntern(animation, true)
			end
			return FRAME_REPOSITORY[syncName]
		else
			return self:createIntern(animation, false)
		end
	end,

	createIntern = function(self, animation, synchronized)
		return {
			frameNumber  = 1,
			animation    = animation,
			creationTime = love.timer.getTime(),
			rolledOver   = false,
			synchronized = synchronized,
			
			update = function(self, dt)
				if self.synchronized then self:updateSynchronized(dt)
				else                      self:updateUnsynchronized(dt) end
			end,

			updateSynchronized = function(self, dt)
				local time = love.timer.getTime() - self.creationTime
				local prevFrameNumber = self.frameNumber
				self.frameNumber = (math.floor(time * self.animation.fps) % #self.animation) + 1
				if self.frameNumber < prevFrameNumber then self.rolledOver = true end
			end,

			updateUnsynchronized = function(self, dt)
				local prevFrameNumber = self.frameNumber
				self.frameNumber = self.frameNumber + (self.animation.fps * dt)
				if self.frameNumber >= (#self.animation + 1) then
					self.frameNumber = self.frameNumber - #self.animation
					self.rolledOver = true
				end
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

			nextFrame = function(self)
				self.frameNumber = self.frameNumber + 1
				if self.frameNumber >= (#self.animation + 1) then
					self.frameNumber = self.frameNumber - #self.animation
				end
			end,

			prevFrame = function(self)
				self.frameNumber = self.frameNumber - 1
				if self.frameNumber < 1 then
					self.frameNumber = self.frameNumber + #self.animation
				end
			end,

			getFirst     = function(self) return self.animation[1]     end,
			isForeground = function(self) return self:get().foreground end,
		}
	end,
}
