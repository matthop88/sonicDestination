return {
	create = function(self, params)
		return {
			graphics = params.graphics,
			transparency = require("tools/lib/tweenableValue"):create(0, { speed = 1 }),
			destination  = 0,

			draw = function(self)
				self:drawSonic1Blocks()
				self:drawSonic2Blocks()
				self:drawSonicCDBlocks()
			end,

			handleKeypressed = function(self, key)
				if key == "S" then
					self.destination = self.destination + 1000
					if self.destination > 8000 then
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

			drawSonic2Blocks = function(self)
				local x = self:drawZone(0, 8192, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 44, h = 4 }, { w = 44.5, h = 5 } })
				self:drawZone(x + 256, 8192, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 41, h = 8 }, { w = 45.5, h = 8 } })

				local x = self:drawZone(0, 10496, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 44, h = 8 }, { w = 46.5, h = 8 }})
				self:drawZone(x + 256, 10496, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 42.5, h = 8 }, { w = 56.0, h = 8 }})
			
				local x = self:drawZone(0, 12800, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 41.5, h = 8 }, { w = 52.0, h = 8 }})
				self:drawZone(x + 256, 12800, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 37.0, h = 8 }, { w = 38.0, h = 8 }})

				local x = self:drawZone(0, 15104, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 49, h = 8 }, { w = 46.5, h = 8 }})
				self:drawZone(x + 256, 15104, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 36, h = 8 }, { w = 32, h = 8 }, { w = 49, h = 8 }})

				self:drawZone(0, 17408, self:getColor(0.5, 0.5, 0.5, -6000), { { w = 21.5, h = 6 }, { w = 50.5, h = 7 }, { w = 15, h = 2.5 }})
			end,

			drawSonicCDBlocks = function(self)
				local x = self:drawZone(0, 20480, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 42, h = 8 }, { w = 42, h = 4 }, { w = 42, h = 4 }, { w = 42, h = 4 }})
				self:drawZone(x + 256, 20480, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 15, h = 4 }, { w = 15, h = 4 }})
				self:drawZone(11008, 22016, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 42, h = 4 }, { w = 42, h = 4 }, { w = 42, h = 4 }, { w = 42, h = 4 }})
				
				local x = self:drawZone(0, 23296, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6 }})
				self:drawZone(x + 256, 23296, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 6, h = 6 }, { w = 6, h = 6 }})
				self:drawZone(0, 25088, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 40, h = 6 }, { w = 40, h = 6 }, { w = 40, h = 6 }, { w = 40, h = 6 }})
			
				local x = self:drawZone(0, 26880, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 30, h = 6 }, { w = 30, h = 6 }, { w = 30, h = 6 }, { w = 30, h = 6 }})
				self:drawZone(54528, 20480, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 15, h = 8 }, { w = 15, h = 8 }})
				self:drawZone(x + 256, 26880, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 30, h = 8 }, { w = 30, h = 8 }, { w = 30, h = 8 }, { w = 30, h = 8 }})
			
				local x = self:drawZone(0, 28672, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }})
				self:drawZone(x + 256, 28672, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 16, h = 4 }, { w = 16, h = 4 }})
				self:drawZone(0, 29952, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }})
			
				local x = self:drawZone(0, 31232, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 36, h = 8 }, { w = 36, h = 8 }, { w = 36, h = 8 }, { w = 36, h = 8 }})
				x = self:drawZone(x + 256, 31232, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 15, h = 8 }, { w = 15, h = 8 }})
				self:drawZone(x + 256, 31232, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 64, h = 3 } })
				self:drawZone(x + 256, 32256, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 64, h = 3 } })
				self:drawZone(0, 33536, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 37, h = 8 }, { w = 37, h = 8 }, { w = 37, h = 8 }, { w = 37, h = 8 }})
			
				local x = self:drawZone(0, 35840, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6 }})
				self:drawZone(0, 37632, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 48, h = 8 }, { w = 48, h = 8 }, { w = 48, h = 8 }, { w = 48, h = 8 }})
			
				local x = self:drawZone(0, 39936, self:getColor(0.3, 0.3, 0.3, -7000), { { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }})
				self:drawZone(x + 256, 39936, self:getColor(0.7, 0.7, 0.7, -7000), { { w = 16, h = 4 }, { w = 16, h = 4 }})
				self:drawZone(0, 42240, self:getColor(0.2, 0.2, 0.2, -7000), { { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }})
			
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
