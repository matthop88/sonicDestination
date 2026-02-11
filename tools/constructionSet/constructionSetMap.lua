return {
	create = function(self, params)
		return {
			graphics = params.graphics,

			draw = function(self)
				self:drawSonic1Blocks()
			end,

			drawSonic1Blocks = function(self)
				-- Green Hill Zone
				self.graphics:setColor(1, 0.5, 0.5)
				self.graphics:rectangle("fill", 0, 0, (40 * 256), (5 * 256))

				self.graphics:rectangle("fill", (41 * 256), 0, (33 * 256), (6 * 256))

				self.graphics:rectangle("fill", (75 * 256), 0, (45 * 256), (6 * 256))
			end,


			---------------------- Graphics Object Methods ------------------------

		    moveImage = function(self, deltaX, deltaY)
		        self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
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
