return {
	create = function(self, params)
		return {
			superChunks = { 
				{ x = 14, y =  0, w =  2 }, 
				{ x = 14, y =  1, w =  2 },
				{ x = 12, y =  2, w =  4 },
				{ x = 14, y =  3, w =  2 },
				{ x =  5, y =  4, w = 11 },
				{ x = 13, y =  8, w =  3 },
				{ x = 11, y =  9, w =  5 },
				{ x = 11, y = 15, w =  5 },
			},
			graphics = params.graphics,
			transparency = require("tools/lib/tweenableValue"):create(0, { speed = 1 }),
			destination  = 0,

			draw = function(self)
				if self.transparency:get() > 0     then self:drawSonic1Blocks() end
				if self.transparency:get() > 8000  then self:drawSonic2Blocks() end
				if self.transparency:get() > 9000  then self:drawSonicCDBlocks() end
				if self.transparency:get() > 10000 then self:drawSonic3Blocks() end
				if self.transparency:get() > 11000 then self:drawSonicAndKnucklesBlocks() end
				if self.transparency:get() > 12000 then self:drawFreeSuperChunks() end
			end,

			handleKeypressed = function(self, key)
				if key == "S" then
					self.destination = self.destination + 1000
					if self.destination > 18000 then
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
				local x = self:drawZone(0, 0, self:getColor(0.227, 0.811, 0.227, 0, -7000), { { w = 40, h = 5 } })
				x = self:drawZone(x + 256, 0, self:getColor(0.227, 0.811, 0.227, -1000, -6000), { { w = 33, h = 6 } })
				x = self:drawZone(x + 256, 0, self:getColor(0.227, 0.811, 0.227, -2000, -5000), { { w = 45, h = 6 } })
			
				-- Marble Zone
				self:drawZone(x + 256, 0, self:getColor(1, 0, 1, -3000, -4000), { { w = 26, h = 6 }, { w = 27, h = 6 }, { w = 28, h = 8 } })
			
				-- Spring Yard Zone
				x = self:drawZone(0, 1792, self:getColor(1, 1, 0, -4000, -3000), { { w = 37, h = 5 }, { w = 43, h = 6 }, { w = 49, h = 7 } })

				-- Labyrinth Zone
				self:drawZone(x + 256, 2304, self:getColor(0, 0.5, 1, -5000, -2000), { { w = 32, h = 8 }, { w = 19, h = 8 }, { w = 35, h = 8 } })
			
				-- Starlight Zone
				x = self:drawZone(0, 3840, self:getColor(0.7, 0.7, 0.7, -6000, -1000), { { w = 34, h = 8 }, { w = 34, h = 7 }, { w = 35, h = 8 } })

				-- Scrapbrain Zone
				x = self:drawZone(x + 256, 4608, self:getColor(0.7, 0, 0, -7000, 0), { { w = 36, h = 8 }, { w = 40, h = 8 }, { w = 23, h = 8 } })
			end,

			drawSonic2Blocks = function(self)
				local x = self:drawZone(0, 7424, self:getColor(0.5, 1, 0.5, -8000), { { w = 44, h = 4 }, { w = 44.5, h = 5 } })
				self:drawZone(x + 256, 7424, self:getColor(1, 0.5, 0.5, -8000), { { w = 41, h = 8 }, { w = 45.5, h = 8 } })

				x = self:drawZone(0, 9728, self:getColor(0.5, 0.5, 1, -8000), { { w = 44, h = 8 }, { w = 46.5, h = 8 }})
				self:drawZone(x, 9728, self:getColor(0.5, 1, 1, -8000), { { w = 42.5, h = 8 }, { w = 56.0, h = 8 }})
			
				x = self:drawZone(0, 12032, self:getColor(1, 1, 0.5, -8000), { { w = 41.5, h = 8 }, { w = 52.0, h = 8 }})
				self:drawZone(x + 256, 12032, self:getColor(1, 0.5, 1, -8000), { { w = 37.0, h = 8 }, { w = 38.0, h = 8 }})

				x = self:drawZone(0, 14336, self:getColor(0.5, 0.7, 0, -8000), { { w = 49, h = 8 }, { w = 46.5, h = 8 }})
				self:drawZone(x + 256, 14336, self:getColor(0.7, 0, 0.5, -8000), { { w = 36, h = 8 }, { w = 32, h = 8 }, { w = 49, h = 8 }})

				self:drawZone(0, 16640, self:getColor(0, 0.5, 0.7, -8000), { { w = 21.5, h = 6 }, { w = 50.5, h = 7 }})
				self:drawZone(0, 18688, self:getColor(0.7, 0.7, 0.7, -8000), { { w = 15, h = 2.5 }})
			end,

			drawSonicCDBlocks = function(self)
				local x = self:drawZone(0, 20480, self:getColor(1, 0.3, 0.3, -9000), { { w = 42, h = 8 }, { w = 42, h = 4 }, { w = 42, h = 4 }, { w = 42, h = 4 }})
				self:drawZone(x + 256, 20480, self:getColor(0.3, 0.3, 1, -9000), { { w = 15, h = 4 }, { w = 15, h = 4 }})
				self:drawZone(11008, 21760, self:getColor(0.3, 1, 0.3, -9000), { { w = 42, h = 4 }, { w = 42, h = 4 }, { w = 42, h = 4 }, { w = 42, h = 4 }})
				
				x = self:drawZone(0, 23040, self:getColor(0.3, 1, 0.7, -9000), { { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6 }})
				self:drawZone(x + 256, 23040, self:getColor(1, 0.7, 0.3, -9000), { { w = 6, h = 6 }, { w = 6, h = 6 }})
				self:drawZone(0, 24832, self:getColor(0.7, 0.3, 0.1, -9000), { { w = 40, h = 6 }, { w = 40, h = 6 }, { w = 40, h = 6 }, { w = 40, h = 6 }})
			
				x = self:drawZone(0, 26424, self:getColor(0.3, 1, 0.0, -9000), { { w = 30, h = 6 }, { w = 30, h = 6 }, { w = 30, h = 6 }, { w = 30, h = 6 }})
				self:drawZone(55296, 20480, self:getColor(0.0, 0.3, 1, -9000), { { w = 15, h = 8 }, { w = 15, h = 8 }})
				self:drawZone(x + 256, 26424, self:getColor(1, 0.3, 0.0, -9000), { { w = 30, h = 8 }, { w = 30, h = 8 }, { w = 30, h = 8 }, { w = 30, h = 8 }})
			
				x = self:drawZone(0, 28672, self:getColor(0.7, 0.0, 0.0, -9000), { { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }})
				self:drawZone(x + 256, 28672, self:getColor(0.0, 0.7, 0.0, -9000), { { w = 16, h = 4 }, { w = 16, h = 4 }})
				self:drawZone(0, 29952, self:getColor(0.0, 0.0, 0.7, -9000), { { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }, { w = 44, h = 4 }})
			
				x = self:drawZone(0, 31232, self:getColor(0.0, 0.7, 0.7, -9000), { { w = 36, h = 8 }, { w = 36, h = 8 }, { w = 36, h = 8 }, { w = 36, h = 8 }})
				x = self:drawZone(x + 256, 31232, self:getColor(0.7, 0.7, 0.0, -9000), { { w = 15, h = 8 }, { w = 15, h = 8 }})
				self:drawZone(x + 256, 29952, self:getColor(0.7, 0.0, 0.7, -9000), { { w = 64, h = 3 } })
				self:drawZone(x + 256, 30956, self:getColor(0.7, 0.7, 0.7, -9000), { { w = 64, h = 3 } })
				self:drawZone(0, 33536, self:getColor(0.5, 0.2, 0.5, -9000), { { w = 37, h = 8 }, { w = 37, h = 8 }, { w = 37, h = 8 }, { w = 37, h = 8 }})
			
				x = self:drawZone(0, 35840, self:getColor(1, 0.5, 0.7, -9000), { { w = 48, h = 6 }, { w = 48, h = 6 }, { w = 48, h = 6, m = 65 }, { w = 48, h = 6, y = -11008 }})
				self:drawZone(0, 37632, self:getColor(0.5, 1, 0.5, -9000), { { w = 48, h = 8 }, { w = 48, h = 8 }, { w = 48, h = 8, m = 54 }, { w = 48, h = 8, y = -4096 }})
			
				x = self:drawZone(0, 39936, self:getColor(0.3, 0.5, 1, -9000), { { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }})
				self:drawZone(x + 256, 39936, self:getColor(0.5, 1, 0.3, -9000), { { w = 16, h = 4 }, { w = 16, h = 4 }})
				self:drawZone(0, 42240, self:getColor(1, 0.3, 0.5, -9000), { { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }, { w = 32, h = 8 }})
			
			end,

			drawSonic3Blocks = function(self)
				local x = self:drawZone(0, 44544, self:getColor(0.3, 1, 0.3, -10000), { { w = 46.125, h = 6.5, m = 48 }, { w = 60, h = 10, m = 64 }})
				self:drawZone(x + 256, 44544, self:getColor(0.3, 0.3, 1, -10000), { { w = 56, h = 12 }, { w = 72, h = 12 }})

				x = self:drawZone(0, 47360, self:getColor(1, 0.3, 0.3, -10000), { { w = 48, h = 16, y = -896 }, { w = 64, h = 12.5 }})
				self:drawZone(x + 256, 47360, self:getColor(1, 0.3, 1, -10000), { { w = 56, h = 12.5, y = 512 }, { w = 76, h = 12.5, y = 512 }})
			
				x = self:drawZone(0, 50688, self:getColor(0.3, 1, 1, -10000), { { w = 112.6875, h = 8 } })
				self:drawZone(x + 256, 51200, self:getColor(0.3, 1, 1, -10000), { { w = 64, h = 12 }})
				self:drawZone(0, 54528, self:getColor(1, 1, 0.3, -10000), { { w = 64, h = 12, y = -1536, m = 112.6875 }, { w = 68.5, h = 12 }})
			end,

			drawSonicAndKnucklesBlocks = function(self)
				self:drawZone(16640, 54528, self:getColor(0.6, 0.3, 1, -11000), { { w = 48, h = 12, y = -1536, m = 117 }, { w = 56.5, h = 12 }})
				self:drawZone(46000, 51200, self:getColor(0.3, 1, 0.6, -11000), { { w = 69, h = 12.5 }})
				local x = self:drawZone(0, 56192, self:getColor(0.3, 1, 0.6, -11000), { { w = 85.5, h = 8 }})
				self:drawZone(x + 256, 56192, self:getColor(0.6, 1, 0.3, -11000), { { w = 16, h = 7 }})
				x = self:drawZone(0, 58368, self:getColor(1, 0.6, 0.3, -11000), { { w = 70, h = 11.5 }, { w = 72, h = 10.5 }})
				self:drawZone(x + 256, 57856, self:getColor(0.6, 1, 0.3, -11000), { { w = 46, h = 12 }, { w = 64, h = 12 }})
				x = self:drawZone(0, 61440, self:getColor(1, 1, 0.3, -11000), { { w = 26, h = 12 }})
				x = self:drawZone(x + 256, 61440, self:getColor(1, 0.3, 1, -11000), { { w = 27, h = 16 }, { w = 3.5, h = 1.5 }})
				self:drawZone(x + 256, 61440, self:getColor(0.6, 0, 0, -11000), { { w = 56.5, h = 12.5 }, { w = 56, h = 14, y = -256 }})
				self:drawZone(x - 128, 64895, self:getColor(1, 0, 0, -11000), { { w = 116, h = 2 }})
			end,

			drawFreeSuperChunks = function(self)
				local chunkNum = 1
				for _, sc in ipairs(self.superChunks) do
					for i = 1, sc.w do
						self.graphics:setColor(0.9, 0.9, 0.9, (self.transparency:get() - 12000) / 1000)
						local x = ((sc.x + (i - 1)) * 16 * 256) + 512
						local y = (sc.y * 16 * 256) + 512
						self.graphics:rectangle("fill", x, y, 3072, 3072)
						self.graphics:setColor(0, 0, 0)
						self.graphics:setFontSize(1024)
						self.graphics:printf("" .. chunkNum, x, y + 768, 3072, "center")
						chunkNum = chunkNum + 1
					end
				end
			end,

			drawZone = function(self, x, y, c, zoneInfo)
				self.graphics:setColor(c)
				for _, zone in ipairs(zoneInfo) do
					local zoneY = y
					if zone.y then zoneY = y + zone.y end
					self.graphics:rectangle("fill", x, zoneY, zone.w * 256, zone.h * 256)
					if zone.m then x = x + (zone.m * 256) + 256
					else           x = x + (zone.w * 256) + 256 end
				end
				return x
			end,

			getColor = function(self, r, g, b, d, k)
				k = k or 0
				local t = self.transparency:get()
				if t > 13000 then
					local p = math.max(0, math.min(t + d - 6000, 1000) / 1000)
					local rp = 1 - p
					return { (r * p) + (0.5 * rp), (g * p) + (0.5 * rp), (b * p) + (0.5 * rp) }
				elseif t > 7000 and t + d + k > 1000 then
					local p  = math.max(0, math.min(t + d + k - 1000, 1000) / 1000)
					local rp = 1 - p
					return { (0.5 * p) + (r * rp), (0.5 * p) + (g * rp), (0.5 * p) + (b * rp) }
				end

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
