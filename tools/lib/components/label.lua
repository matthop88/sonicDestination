local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		return {
			x     = params.x,
			y     = params.y,
			w     = params.w,
			h     = params.h or 50,
			label = params.label or "",
			font  = love.graphics.newFont(params.fontSize or 20),
				
			draw = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(self.font)
				
				love.graphics.print(self.label, self.x + 10, self.y + 15)
			end,
		}
	end,
}
