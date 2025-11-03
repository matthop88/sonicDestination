local CALLBACK

local FONT_SIZE      = 40
local FONT           = love.graphics.newFont(FONT_SIZE)

return {
	create = function(self, callback)
		CALLBACK = callback
		return {
			progress = 0.0,

			draw = function(self)
				if self.progress ~= 0 then
					love.graphics.setColor(1, 1, 1)
					love.graphics.setLineWidth(1)
					love.graphics.rectangle("line", 100, 380, 1000, 40)
					love.graphics.setColor(1, 1, 0)
					love.graphics.rectangle("fill", 103, 382, 994 * self.progress, 36)
					love.graphics.setColor(1, 1, 1)
					love.graphics.setFont(FONT)
					love.graphics.printf("Scanning for Rings...", 0, 330, 1200, "center")
				end
			end,

			update = function(self, dt, callback)
				CALLBACK = CALLBACK or callback
				if CALLBACK then
					self.progress = CALLBACK()
				end
			end,
		}
	end,
}
