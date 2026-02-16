local CHUNKS, SOLIDS

return {
	create = function(self, params)
		return {
			graphics = params.graphics,
			hex = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" },

			chunks = {
				place = function(self, chunkID, x, y, xFlipped)
					for n, chunk in ipairs(self) do
						if chunk.x == x and chunk.y == y then
							chunk.id = chunkID
							chunk.xFlipped = xFlipped
							return
						end
					end

					table.insert(self, { id = chunkID, x = x, y = y, xFlipped = xFlipped })
				end,

				draw = function(self, graphics)
					if CHUNKS then
						graphics:setColor(1, 1, 1)
						for _, chunk in ipairs(self) do
							if chunk.xFlipped then
								CHUNKS:drawAt(graphics, (chunk.x * 256) + 256, chunk.y * 256, chunk.id, -1, 1)
							else
								CHUNKS:drawAt(graphics, chunk.x * 256, chunk.y * 256, chunk.id, 1, 1)
							end
						end
					end
				end,
			},

			objects = {
				place = function(self, obj, x, y)
					table.insert(self, { obj = obj, x = x, y = y })
				end,

				draw = function(self, graphics)
					graphics:setColor(1, 1, 1)
					for _, object in ipairs(self) do
						object.obj:draw(graphics, object.x, object.y, 1, 1)
					end
				end,

				update = function(self, dt)
					for _, object in ipairs(self) do
						object.obj:update(dt)
					end
				end,
			},

			initChunkInfo = function(self, chunkInfo)
				CHUNKS = chunkInfo.chunks
				SOLIDS = chunkInfo.solids
			end,

			draw = function(self)
				self.chunks:draw(self.graphics)
				self.objects:draw(self.graphics)
			end,

			drawCoordinates = function(self)
				local scale = self.graphics:getScale()
				if scale < 0.15 then
					self:drawSuperChunkCoordinates()
				end
				if scale > 0.05 and scale < 2 then
					self:drawChunkCoordinates()
				end 
				if scale > 1 and scale <= 40 then
					self:drawTileCoordinates()
				end
			end,

			handleKeypressed = function(self, key)
				if key == "s" then
					print(self.graphics:getScale())
				end
			end,

			placeChunk = function(self, chunkID, x, y, xFlipped)
				self.chunks:place(chunkID, x, y, xFlipped)
			end,

			placeObject = function(self, obj, x, y)
				self.objects:place(obj, x, y)
			end,

			update = function(self, dt)
				self.objects:update(dt)
			end,

			drawSuperChunkCoordinates = function(self)
				local leftMostX,  topMostY    = self.graphics:screenToImageCoordinates(0, 0)
				local rightMostX, bottomMostY = self.graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

				local alpha = 1 - ((self.graphics:getScale() - 0.05) * 10)
				
				self.graphics:setColor(1, 1, 1, alpha)
				
				local fontSize = math.min(1536, math.max(768, 768 - (topMostY / 3)))
				self.graphics:setFontSize(fontSize)
				
				for x = 0, 15 do
					self.graphics:printf("" .. self.hex[x + 1], x * 256 * 16, math.max(-2400, topMostY), 256 * 16, "center")
				end

				local fontSize = math.min(1536, math.max(768, 768 - (leftMostX / 5)))
				self.graphics:setFontSize(fontSize)
				
				for y = 0, 15 do
					self.graphics:printf("" .. self.hex[y + 1], math.max(-3000, leftMostX), (y * 256 * 16 + (2048 - (fontSize * 0.6))), fontSize * 0.8, "right")
				end

			end,

			drawChunkCoordinates = function(self)
				local leftMostX,  topMostY    = self.graphics:screenToImageCoordinates(0, 0)
				local rightMostX, bottomMostY = self.graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

				leftChunk   = math.floor(leftMostX / 256)
				rightChunk  = math.floor(rightMostX / 256)
				topChunk    = math.floor(topMostY / 256)
				bottomChunk = math.floor(bottomMostY / 256)

				local alpha = (self.graphics:getScale() - 0.05) * 10
				
				if self.graphics:getScale() > 1 then
					alpha = 1 - (self.graphics:getScale() - 1)
				end
				self.graphics:setColor(1, 1, 1, alpha)

				local fontSize = math.min(96, math.max(24 / self.graphics:getScale(), 24 - (leftMostX / 3)))
				self.graphics:setFontSize(fontSize)

				for chunkY = math.max(0, topChunk), math.min(255, bottomChunk) do
					local y = chunkY % 16
					local scy = math.floor(chunkY / 16)
					
					self.graphics:printf(self.hex[scy + 1] .. self.hex[y + 1], math.max(-200, leftMostX), chunkY * 256 + (128 - (fontSize * 0.7)), 1.5 * fontSize, "right")
				end
				
				fontSize = math.min(96, math.max(24 / self.graphics:getScale(), 24 - (topMostY / 2)))
				self.graphics:setFontSize(fontSize)
			
				self.graphics:setColor(0, 0, 0, alpha)
				self.graphics:rectangle("fill", leftMostX, topMostY, rightMostX - leftMostX, self.graphics:getFontHeight())
				self.graphics:setColor(1, 1, 1, alpha)

				for chunkX = math.max(0, leftChunk), math.min(255, rightChunk) do
					local x = chunkX % 16
					local scx = math.floor(chunkX / 16)

					self.graphics:printf(self.hex[scx + 1] .. self.hex[x + 1], chunkX * 256, math.max(-150, topMostY), 256, "center")
				end
			end,

			drawTileCoordinates = function(self)
				local fontWidth = self.graphics:getFontWidth("FFF")
				local leftMostX,  topMostY    = self.graphics:screenToImageCoordinates(0, 0)
				local rightMostX, bottomMostY = self.graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

				leftTile   = math.floor(leftMostX / 16)
				rightTile  = math.floor(rightMostX / 16)
				topTile    = math.floor(topMostY / 16)
				bottomTile = math.floor(bottomMostY / 16)
				
				local alpha = self.graphics:getScale() - 1
				if self.graphics:getScale() > 20 then
					alpha = 1 - ((self.graphics:getScale() - 20) / 20)
				end
				local s = 12 / self.graphics:getScale()
				
				local fontSize = math.max(2, math.min(6, math.max(s, s - (leftMostX / 6))))
				self.graphics:setFontSize(fontSize)
				self.graphics:setColor(1, 1, 1, alpha)
				
				for tileY = math.max(0, topTile), math.min(4095, bottomTile) do
					local y = tileY % 16
					local cy = math.floor(tileY / 16) % 16
					local scy = math.floor(tileY / 256)
					self.graphics:printf(self.hex[scy + 1] .. self.hex[cy + 1] .. self.hex[y + 1], math.max(-16, leftMostX), tileY * 16 + (8 - fontSize / 2), 3 * fontSize, "left")
				end

				local fontSize = math.max(2, math.min(6, math.max(s, s - (topMostY / 3))))
				self.graphics:setFontSize(fontSize)

				self.graphics:setColor(0, 0, 0, alpha)
				self.graphics:rectangle("fill", leftMostX, topMostY, rightMostX - leftMostX, self.graphics:getFontHeight() + 0.5)
				self.graphics:setColor(1, 1, 1, alpha)
				for tileX = math.max(0, leftTile), math.min(4095, rightTile) do
					local x = tileX % 16
					local cx = math.floor(tileX / 16) % 16
					local scx = math.floor(tileX / 256)
					
					self.graphics:printf(self.hex[scx + 1] .. self.hex[cx + 1] .. self.hex[x + 1], tileX * 16, math.max(-9, topMostY), 16, "center")
				end

				
			end,
	
			---------------------- Graphics Object Methods ------------------------

		    moveImage = function(self, deltaX, deltaY)
		        self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
		    	--self.graphics:quantizeXY()
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
