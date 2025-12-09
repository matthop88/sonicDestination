local ANIMATION_FACTORY = require("tools/spriteSandbox/animationFactory")

return {
	enhanceWithQuads = function(self, animationData, image)
		for _, frame in ipairs(animationData) do
			if frame.x then
				frame.QUAD = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, image:getWidth(), image:getHeight())
			end
		end
	end,

	create = function(self, name, animationData, image)
		local subAnimations = {}
		if animationData.parts then
			for _, part in ipairs(animationData.parts) do
				table.insert(subAnimations, ANIMATION_FACTORY:create("parts/", part.name, part.animation))
			end
		end

		self:enhanceWithQuads(animationData, image)

		local syncName = nil
		if animationData.synchronized then syncName = name end
		local currentFrame = require("tools/spriteSandbox/frame"):create(animationData, syncName)
			
		return {
			name          = name,
			data          = animationData,
			image         = image,
			currentFrame  = currentFrame,
			repCount      = 0,
			visible       = true,
			terminated    = false,
			subAnimations = subAnimations,

			draw = function(self, GRAFX, x, y, xScale)
				if #self.subAnimations > 0 then
					for _, subAnim in ipairs(self.subAnimations) do
						subAnim:draw(GRAFX, x, y, xScale)
					end
				else
					local frame = self.currentFrame:get()
					if frame.QUAD then
						GRAFX:setColor(1, 1, 1)
						GRAFX:draw(self.image, frame.QUAD, x - (frame.offset.x * xScale), y - frame.offset.y, 0, xScale, 1)
					end
				end
			end,

			drawThumbnail = function(self, GRAFX, x, y, sX, sY, xScale)
				if #self.subAnimations > 0 then
					for _, subAnim in ipairs(self.subAnimations) do
						subAnim:drawThumbnail(GRAFX, x, y, sX, sY, xScale)
					end
				else
					local frame = self.currentFrame:getFirst()
					if frame.QUAD then
						GRAFX:draw(self.image, frame.QUAD, x - (frame.offset.x * sX * xScale), y - (frame.offset.y * sY), 0, sX * xScale, sY)
					end
				end
			end,

			update = function(self, dt)
				if #self.subAnimations > 0 then
					for _, subAnim in ipairs(self.subAnimations) do
						subAnim:update(dt)
					end
				else
					self.currentFrame:update(dt)
					if self.currentFrame:isRolledOver() then
						self.repCount = self.repCount + 1
						if self:reps() and self.repCount >= self:reps() then self.terminated = true end
					end
				end
			end,

			refresh = function(self)
				local syncName = nil
				if self:synchronized() then syncName = self.name end
				self.repCount = 0
				self.visible = true
				self.currentFrame = require("tools/spriteSandbox/frame"):create(self.data, syncName)
			end,
			

			isDefault    = function(self)    return self.data.isDefault    end,

			frames       = function(self)    return self.data              end,

			width        = function(self)    return self.data.w            end,
			height       = function(self)    return self.data.h            end,

			offsetX      = function(self)    return self.data.offset.x     end,
			offsetY      = function(self)    return self.data.offset.y     end,
			
			reps         = function(self)    return self.data.reps         end,
			synchronized = function(self)    return self.data.synchronized end,
			
			isForeground = function(self)    
				return self.data.foreground or self.currentFrame:isForeground()   
			end,

			isTerminated = function(self)    return self.terminated        end,
		}
	end,
}
