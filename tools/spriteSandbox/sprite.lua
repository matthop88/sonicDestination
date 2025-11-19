return {
	getDefaultAnimation = function(self, animations)
		local animationName
		for name, animation in pairs(animations) do
			if animationName == nil then animationName = name end
			if animation.isDefault     then animationName = name end
		end
		return animationName, animations[animationName]
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

		local animationName, currentAnimation = self:getDefaultAnimation(data.animations)
		self:enhanceWithQuads(data.animations, SHEET_IMAGE)

		return ({
			init = function(self)
				self.animations       = data.animations
				self.currentAnimation = currentAnimation
				local syncName = nil
				if self.currentAnimation.synchronized then
					syncName = animationName
				end
				self.currentFrame     = require("tools/spriteSandbox/frame"):create(currentAnimation, syncName)
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
