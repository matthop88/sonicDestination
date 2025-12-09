local ANIMATION_FACTORY = require("tools/spriteSandbox/animationFactory")

return {
	create = function(self, name, animationData, image)
		local subAnimations = {}
		for _, part in ipairs(animationData.parts) do
			table.insert(subAnimations, ANIMATION_FACTORY:create("parts/", part.name, part.animation))
		end
	
		return {
			name          = name,
			data          = animationData,
			image         = image,
			visible       = true,
			terminated    = false,
			subAnimations = subAnimations,

			draw = function(self, GRAFX, x, y, xScale)
				for _, subAnim in ipairs(self.subAnimations) do
					subAnim:draw(GRAFX, x, y, xScale)
				end
			end,

			drawThumbnail = function(self, GRAFX, x, y, sX, sY, xScale)
				for _, subAnim in ipairs(self.subAnimations) do
					subAnim:drawThumbnail(GRAFX, x, y, sX, sY, xScale)
				end
			end,

			update = function(self, dt)
				for _, subAnim in ipairs(self.subAnimations) do
					subAnim:update(dt)
				end
			end,

			refresh = function(self)
				-- Do nothing
			end,
			
			isDefault    = function(self)    return self.data.isDefault    end,

			width        = function(self)    return self.data.w            end,
			height       = function(self)    return self.data.h            end,

			offsetX      = function(self)    return self.data.offset.x     end,
			offsetY      = function(self)    return self.data.offset.y     end,
			
			synchronized = function(self)    return self.data.synchronized end,
			isForeground = function(self)    return self.data.foreground   end,
			isTerminated = function(self)    return self.terminated        end,
		}
	end,
}
