return {
	create = function(self, path, x, y)
		local data     = require("tools/spriteSandbox/data/" .. path)
		local sheetImg = love.graphics.newImage("resources/images/spriteSheets/" .. data.imageName .. ".png")
		sheetImg:setFilter("nearest", "nearest")

		local currentAnimation
		for _, animation in pairs(data.animations) do
			if currentAnimation == nil then currentAnimation = animation end
			if animation.isDefault     then currentAnimation = animation end

			for _, frame in ipairs(animation) do
				frame.QUAD = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, sheetImg:getWidth(), sheetImg:getHeight())
			end
		end

		return ({
			init = function(self)
				self.animations       = data.animations
				self.currentAnimation = currentAnimation
				self.currentFrame     = 1

				return self
			end,

			draw = function(self)
				local frame = self.currentAnimation[self.currentFrame]

				love.graphics.setColor(1, 1, 1)
				love.graphics.draw(sheetImg, frame.QUAD, x, y, 0, 1, 1)
			end,
		}):init()
	end,
}
