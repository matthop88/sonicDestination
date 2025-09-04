local TextField = require("tools/lib/components/textField")

return {
	create = function(self)
		local enabled = false

        local ANIMATION_PANE

        local fpsField = TextField:create(600, 118, 168, 48, "FPS: ", function(value) ANIMATION_PANE.fps = value end)
        
		ANIMATION_PANE = {
			spriteData = {},

			index = 1,
			fps   = 10,
			
			draw = function(self)
				if enabled then
					self:drawTranslucentPane()
					self:drawAnimationFrame()
                    fpsField:draw()
				end
			end,

			drawTranslucentPane = function(self)
				love.graphics.setColor(0, 0, 0, 0.5)
				love.graphics.rectangle("fill", 0, 0, 1024, 768)
			end,

			drawAnimationFrame = function(self)
				local scale = 15

				local currentSpriteInfo = self.spriteData[math.floor(self.index)]

				if currentSpriteInfo then
					love.graphics.setColor(1, 1, 1)
					love.graphics.draw(currentSpriteInfo.image, currentSpriteInfo.rect.quad,
						512 - (currentSpriteInfo.rect.offset.x * scale), 374 - (currentSpriteInfo.rect.offset.y * scale),
						0, scale, scale)
				end
			end,

			update = function(self, dt)
				if enabled then
					self.index = self.index + (self.fps * dt)
					if math.floor(self.index) > #self.spriteData then
						self.index = self.index - #self.spriteData
					end
				end
			end,

            keypressed = function(self, key)
                return enabled and fpsField:handleKeypressed(key)
            end,

			enable = function(self)
				enabled = true
			end,

			disable = function(self)
				enabled = false
			end,

			setFPS = function(self, fps)
				self.fps = fps
				fpsField:setValue(fps)
			end,
			
			setSpriteData = function(self, spriteData)
				self.spriteData = spriteData
			end,

		}

        return ANIMATION_PANE
	end,
}
