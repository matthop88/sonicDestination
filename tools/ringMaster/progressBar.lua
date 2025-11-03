local CALLBACK

local FONT_SIZE      = 40
local FONT           = love.graphics.newFont(FONT_SIZE)

return {
	create = function(self, callback, y)
		CALLBACK = callback
		return {
			time = 0,
			progress = 0.0,
			alpha = 0.0,
			
			draw = function(self)
				if self.progress ~= 0 then
					love.graphics.setColor(1, 1, 1, self.alpha)
					love.graphics.setLineWidth(1)
					love.graphics.rectangle("line", 100, 380, 1000, 40)
					for x = 103, 103 + (994 * self.progress) do
						local gValue = 0.5 + math.sin((self.time * 5) + ((x - 103) / 994 * 15)) * 0.5
						love.graphics.setColor(1, 1 - gValue, 0, self.alpha)
						love.graphics.rectangle("fill", x, 382, 1, 36)
					end
					love.graphics.setColor(1, 1, 1, self.alpha)
					love.graphics.setFont(FONT)
					love.graphics.printf("Scanning for Rings...", 0, 330, 1200, "center")
				end
			end,

			update = function(self, dt, callback)
				CALLBACK = CALLBACK or callback
				if CALLBACK then
					self.progress = math.max(self.progress, CALLBACK())
				end
				self.time = self.time + (1 * dt)
				self:updateFade(dt)
			end,

			updateFade = function(self, dt)

				if self.progress == 1 then
					self.alpha = math.max(0, self.alpha - (1 * dt))
				elseif self.progress > 0 then
					self.alpha = math.min(1, self.alpha + (2 * dt))
				end
			end,
		}
	end,
}
