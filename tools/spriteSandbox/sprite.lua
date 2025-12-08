local SPRITE_ID = 0

return {
	createAnimations = function(self, animationData)
		local animationObjects = {}
		for name, animDataElement in pairs(animationData) do
			animationObjects[name] = require("tools/spriteSandbox/animation"):create(name, animDataElement)
		end
		return animationObjects
	end,

	createAnimationList = function(self, animations)
		local animationList = {}
		animationList.index = 1
		local n = 1
		for name, animation in pairs(animations) do
			table.insert(animationList, { name = name, animation = animation })
			if animation:isDefault() then animationList.index = n end
			n = n + 1
		end
		return animationList
	end,

	getDefaultAnimation = function(self, animations)
		local animationName
		for name, animation in pairs(animations) do
			if animationName == nil  then animationName = name end
			if animation:isDefault() then animationName = name end
		end
		return animationName, animations[animationName]
	end,

	enhanceWithQuads = function(self, animations, sheetImage)
		for _, animation in pairs(animations) do
			for _, frame in ipairs(animation:frames()) do
				if frame.x then
					frame.QUAD = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, sheetImage:getWidth(), sheetImage:getHeight())
				end
			end
		end
	end,

	create = function(self, path, x, y, noBumpID)
		local data        = require("tools/spriteSandbox/data/" .. path)
		local SHEET_IMAGE = love.graphics.newImage("resources/images/spriteSheets/" .. data.imageName .. ".png")
		SHEET_IMAGE:setFilter("nearest", "nearest")

		local animations = self:createAnimations(data.animations)
		local animationName, currentAnimation = self:getDefaultAnimation(animations)
		local animationList                   = self:createAnimationList(animations)
		self:enhanceWithQuads(animations, SHEET_IMAGE)

		if not noBumpID then
			SPRITE_ID = SPRITE_ID + 1
		end

		local IS_PLAYER = data.player

		return ({
			id       = SPRITE_ID,
			repCount = 0,
			visible  = true,
			xScale   = 1,

			init = function(self)
				self.animations       = animations
				self.currentAnimation = currentAnimation
				self.animationList    = animationList
				self.x, self.y        = x,  y

				return self
			end,

			getID = function(self) return self.id                        end,
			getX  = function(self) return self.x                         end,
			getY  = function(self) return self.y                         end,
			getW  = function(self) return self.currentAnimation:width()  end,
			getH  = function(self) return self.currentAnimation:height() end,

			setX  = function(self, x)     self.x = x                     end,
			setY  = function(self, y)     self.y = y                     end,
			
			draw  = function(self, GRAFX)
				self.currentAnimation:draw(GRAFX, SHEET_IMAGE, self.x, self.y, self.xScale)
			end,

			drawThumbnail = function(self, GRAFX, x, y, sX, sY)
				self.currentAnimation:draw(GRAFX, SHEET_IMAGE, x, y, sX, sY, self.xScale)
			end,

			isInside = function(self, px, py)
				return px >= self.x - self.currentAnimation:offsetX() 
				   and px <= self.x - self.currentAnimation:offsetX() + self.currentAnimation:width()
				   and py >= self.y - self.currentAnimation:offsetY()
				   and py <= self.y - self.currentAnimation:offsetY() + self.currentAnimation:height()
			end,

			update = function(self, dt)
				if not self.frozen then
					self.currentAnimation:update(dt)
					self.deleted = self.deleted or self.currentAnimation:isTerminated()
				end
			end,

			advanceAnimation = function(self)
				self.animationList.index = self.animationList.index + 1
				if self.animationList.index > #self.animationList then
					self.animationList.index = 1
				end
				self:refreshAnimation()
			end,

			refreshAnimation = function(self)
				local anim = self.animationList[self.animationList.index]
				self.currentAnimation = anim.animation
				self.currentAnimation:refresh()
			end,

			isPlayer = function(self) return IS_PLAYER end,

			isForeground = function(self) return self.currentAnimation:isForeground() end,
			
			regressAnimation = function(self)
				self.animationList.index = self.animationList.index - 1
				if self.animationList.index < 1 then
					self.animationList.index = #self.animationList
				end
				self:refreshAnimation()
			end,

			toggleFreeze = function(self) self.frozen = not self.frozen  end,
			flipX        = function(self) self.xScale = self.xScale * -1 end,
				
		}):init()
	end,
}
