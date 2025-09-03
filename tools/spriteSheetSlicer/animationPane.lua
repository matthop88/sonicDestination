return {
	create = function(self)
		local enabled = false

		return {
			spriteData = {},

			index = 1,
			fps   = 10,
			
			draw = function(self)
				if enabled then
					self:drawTranslucentPane()
					self:drawAnimationFrame()
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
					self.index = self.index + (60 / self.fps * dt)
					if math.floor(self.index) > #self.spriteData then
						self.index = self.index - #self.spriteData
					end
				end
			end,

			enable = function(self)
				enabled = true
			end,

			disable = function(self)
				enabled = false
			end,

			setSpriteData = function(self, spriteData)
				self.spriteData = spriteData
			end,

		}
	end,
}
