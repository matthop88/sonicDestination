return {
	getDefaultAnimation = function(self, animations)
		local currentAnimation
		for _, animation in pairs(animations) do
			if currentAnimation == nil then currentAnimation = animation end
			if animation.isDefault     then currentAnimation = animation end
		end
		return currentAnimation
	end,

	enhanceWithQuads = function(self, animations, sheetImage)
		for _, animation in pairs(animations) do
			for _, frame in ipairs(animation) do
				frame.QUAD = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, sheetImage:getWidth(), sheetImage:getHeight())
			end
		end
	end,

	create = function(self, path, x, y)
		local data        = require("tools/spriteSandbox/data/" .. path)
		local SHEET_IMAGE = love.graphics.newImage("resources/images/spriteSheets/" .. data.imageName .. ".png")
		SHEET_IMAGE:setFilter("nearest", "nearest")

		local currentAnimation = self:getDefaultAnimation(data.animations)
		self:enhanceWithQuads(data.animations, SHEET_IMAGE)

		return ({
			init = function(self)
				self.animations       = data.animations
				self.currentAnimation = currentAnimation
				self.currentFrame     = require("tools/spriteSandbox/frame"):create(currentAnimation)
				self.x, self.y        = x,  y

				return self
			end,

			draw = function(self, GRAFX)
				local frame = self.currentFrame:get()
				
				GRAFX:setColor(1, 1, 1)
				GRAFX:draw(SHEET_IMAGE, frame.QUAD, self.x - frame.offset.x, self.y - frame.offset.y, 0, 1, 1)
			end,

			update = function(self, dt)
				self.currentFrame:update(dt)
			end,

		}):init()
	end,
}
