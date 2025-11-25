local SPRITE_ID = 0

return {
	createAnimationList = function(self, animations)
		local animationList = {}
		animationList.index = 1
		local n = 1
		for name, animation in pairs(animations) do
			table.insert(animationList, { name = name, animation = animation })
			if animation.isDefault then animationList.index = n end
			n = n + 1
		end
		return animationList
	end,

	getDefaultAnimation = function(self, animations)
		local animationName
		for name, animation in pairs(animations) do
			if animationName == nil then animationName = name end
			if animation.isDefault  then animationName = name end
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
		local animationList                   = self:createAnimationList(data.animations)
		self:enhanceWithQuads(data.animations, SHEET_IMAGE)

		SPRITE_ID = SPRITE_ID + 1

		return ({
			id   = SPRITE_ID,

			init = function(self)
				self.animations       = data.animations
				self.currentAnimation = currentAnimation
				self.animationList    = animationList
				local syncName = nil
				if self.currentAnimation.synchronized then
					syncName = animationName
				end
				self.currentFrame     = require("tools/spriteSandbox/frame"):create(currentAnimation, syncName)
				self.x, self.y        = x,  y

				return self
			end,

			getID = function(self) return self.id                 end,
			getX  = function(self) return self.x                  end,
			getY  = function(self) return self.y                  end,
			getW  = function(self) return self.currentAnimation.w end,
			getH  = function(self) return self.currentAnimation.h end,

			draw  = function(self, GRAFX)
				local frame = self.currentFrame:get()
				
				GRAFX:setColor(1, 1, 1)
				GRAFX:draw(SHEET_IMAGE, frame.QUAD, self.x - frame.offset.x, self.y - frame.offset.y, 0, 1, 1)
			end,

			isInside = function(self, px, py)
				return px >= self.x - self.currentAnimation.offset.x 
				   and px <= self.x - self.currentAnimation.offset.x + self.currentAnimation.w
				   and py >= self.y - self.currentAnimation.offset.y
				   and py <= self.y - self.currentAnimation.offset.y + self.currentAnimation.h
			end,

			update = function(self, dt)
				self.currentFrame:update(dt)
			end,

			advanceAnimation = function(self)
				self.animationList.index = self.animationList.index + 1
				if self.animationList.index > #self.animationList then
					self.animationList.index = 1
				end
				self:updateAnimation()
			end,

			updateAnimation = function(self)
				local anim = self.animationList[self.animationList.index]
				self.currentAnimation = anim.animation
				local syncName = nil
				if self.currentAnimation.synchronized then syncName = anim.name end
				self.currentFrame = require("tools/spriteSandbox/frame"):create(self.currentAnimation, syncName)
			end,

			regressAnimation = function(self)
				self.animationList.index = self.animationList.index - 1
				if self.animationList.index < 1 then
					self.animationList.index = #self.animationList
				end
				self:updateAnimation()
			end,
				

		}):init()
	end,
}
