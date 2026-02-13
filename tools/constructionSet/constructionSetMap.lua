return {
	create = function(self, params)
		return {
			graphics = params.graphics,
			hex = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" },

			draw = function(self)
				if self.graphics:getScale() < 0.15 then
					self:drawSuperChunkCoordinates()
				end
				if self.graphics:getScale() > 0.05 then
					self:drawChunkCoordinates()
				end 
			end,

			handleKeypressed = function(self, key)
				if key == "s" then
					print(self.graphics:getScale())
				end
			end,

			update = function(self, dt)
				-- Do nothing
			end,

			drawSuperChunkCoordinates = function(self)
				local alpha = 1 - ((self.graphics:getScale() - 0.05) * 10)
				
				self.graphics:setColor(1, 1, 1, alpha)
				self.graphics:setFontSize(1536)
				
				for x = 0, 15 do
					self.graphics:printf("" .. self.hex[x + 1], x * 256 * 16, -2400, 256 * 16, "center")
				end

				for y = 0, 15 do
					self.graphics:printf("" .. self.hex[y + 1], -3200, (y * 256 * 16 + 1184), 2000, "right")
				end

			end,

			drawChunkCoordinates = function(self)
				local alpha = (self.graphics:getScale() - 0.05) * 10
				
				self.graphics:setColor(1, 1, 1, alpha)
				self.graphics:setFontSize(96)

				for x = 0, 15 do
					self.graphics:printf("0" .. self.hex[x + 1], x * 256, -150, 256, "center")
				end

				for y = 0, 15 do
					self.graphics:printf("0" .. self.hex[y + 1], -200, (y * 256 + 60), 150, "right")
				end

			end,
	
			---------------------- Graphics Object Methods ------------------------

		    moveImage = function(self, deltaX, deltaY)
		        self.graphics:moveImage(math.floor(deltaX / self.graphics:getScale()), math.floor(deltaY / self.graphics:getScale()))
		    end,

		    screenToImageCoordinates = function(self, screenX, screenY)
		        return self.graphics:screenToImageCoordinates(screenX, screenY)
		    end,

		    imageToScreenCoordinates = function(self, imageX, imageY)
		        return self.graphics:imageToScreenCoordinates(imageX, imageY)
		    end,

		    adjustScaleGeometrically = function(self, deltaScale)
		        self.graphics:adjustScaleGeometrically(deltaScale)
		    end,

		    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
		        self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
		    end,
		}
	end,

}
