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
				self.currentFrame     = 1

				return self
			end,

			draw = function(self)
				local frame = self:getCurrentFrame()
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.draw(SHEET_IMAGE, frame.QUAD, x - frame.offset.x, y - frame.offset.y, 0, 1, 1)
			end,

			getCurrentFrame = function(self)
				return self.currentAnimation[math.floor(self.currentFrame)]
			end,

			update = function(self, dt)
				self:updateFrame(dt)
			end,

			updateFrame = function(self, dt)
				self.currentFrame = self.currentFrame + ((self.currentAnimation.fps) * dt)
				if self.currentFrame >= #self.currentAnimation + 1 then
					self.currentFrame = self.currentFrame - #self.currentAnimation
				end
			end,

		}):init()
	end,
}
