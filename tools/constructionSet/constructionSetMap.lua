return {
	create = function(self, params)
		return {
			graphics = params.graphics,
			transparency = require("tools/lib/tweenableValue"):create(0, { speed = 1 }),
			destination  = 0,

			draw = function(self)
				self:drawSonic1Blocks()
			end,

			handleKeypressed = function(self, key)
				if key == "S" then
					self.destination = self.destination + 1000
					if self.destination > 6000 then
						self.destination = 0
					end
					self.transparency:setDestination(self.destination)
				end
			end,

			update = function(self, dt)
				self.transparency:update(dt)
			end,

			drawSonic1Blocks = function(self)
				-- Green Hill Zone
				local x = self:drawZone(0, 0, self:getColor(1, 0.5, 0.5, 0), { { w = 40, h = 5 }, { w = 33, h = 6 }, { w = 45, h = 6 } })
			
				-- Marble Zone
				self:drawZone(x + 256, 0, self:getColor(1, 0, 1, -1000), { { w = 26, h = 6 }, { w = 27, h = 6 }, { w = 28, h = 8 } })
			
				-- Spring Yard Zone
				x = self:drawZone(0, 1792, self:getColor(1, 1, 0, -2000), { { w = 37, h = 5 }, { w = 43, h = 6 }, { w = 49, h = 7 } })

				-- Labyrinth Zone
				self:drawZone(x + 256, 2304, self:getColor(0, 0.5, 1, -3000), { { w = 32, h = 8 }, { w = 19, h = 8 }, { w = 35, h = 8 } })
			
				-- Starlight Zone
				x = self:drawZone(0, 3840, self:getColor(0.7, 0.7, 0.7, -4000), { { w = 34, h = 8 }, { w = 34, h = 7 }, { w = 35, h = 8 } })

				-- Scrapbrain Zone
				x = self:drawZone(x + 256, 4608, self:getColor(0.7, 0, 0, -5000), { { w = 36, h = 8 }, { w = 40, h = 8 }, { w = 23, h = 8 } })
			end,

			drawZone = function(self, x, y, c, zoneInfo)
				self.graphics:setColor(c)
				for _, zone in ipairs(zoneInfo) do
					self.graphics:rectangle("fill", x, y, zone.w * 256, zone.h * 256)
					x = x + (zone.w * 256) + 256
				end
				return x
			end,

			getColor = function(self, r, g, b, d)
				return { r, g, b, (self.transparency:get() + d) / 1000 }
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
