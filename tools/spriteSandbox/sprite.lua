return {
	create = function(self, path, x, y)
		return ({
			init = function(self)
				self.data     = require("tools/spriteSandbox/data/" .. path)
				self.sheetImg = love.graphics.newImage("resources/images/spriteSheets/" .. self.data.imageName .. ".png")
				self.sheetImg:setFilter("nearest", "nearest")

				return self
			end,

			draw = function(self)
				love.graphics.setColor(1, 1, 1)
				love.graphics.draw(self.sheetImg, 0, 0)
			end,
		}):init()
	end,
}
