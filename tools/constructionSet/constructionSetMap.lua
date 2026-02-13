return {
	create = function(self, params)
		return {
			graphics = params.graphics,
			hex = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" },

			draw = function(self)
				local scale = self.graphics:getScale()
				if scale < 0.25 then
					self:drawSuperChunkCoordinates()
				end
				if scale > 0.05 and scale <= 5 then
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

			update = function(self, dt)
				-- Do nothing
			end,

			drawSuperChunkCoordinates = function(self)
				local alpha = 1 - ((self.graphics:getScale() - 0.05) * 5)
				
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
				local leftMostX,  topMostY    = self.graphics:screenToImageCoordinates(0, 0)
				local rightMostX, bottomMostY = self.graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

				leftChunk   = math.floor(leftMostX / 256)
				rightChunk  = math.floor(rightMostX / 256)
				topChunk    = math.floor(topMostY / 256)
				bottomChunk = math.floor(bottomMostY / 256)

				local alpha = (self.graphics:getScale() - 0.05) * 10
				if self.graphics:getScale() > 1 then
					alpha = 1 - ((self.graphics:getScale() - 1) / 4)
				end

				self.graphics:setColor(1, 1, 1, alpha)
				self.graphics:setFontSize(96)

				for chunkX = math.max(0, leftChunk), math.min(255, rightChunk) do
					local x = chunkX % 16
					local scx = math.floor(chunkX / 16)
					self.graphics:printf(self.hex[scx + 1] .. self.hex[x + 1], chunkX * 256, -150, 256, "center")
				end

				for chunkY = math.max(0, topChunk), math.min(255, bottomChunk) do
					local y = chunkY % 16
					local scy = math.floor(chunkY / 16)
					self.graphics:printf(self.hex[scy + 1] .. self.hex[y + 1], -200, chunkY * 256 + 60, 150, "right")
				end

			end,

			drawTileCoordinates = function(self)
				local leftMostX,  topMostY    = self.graphics:screenToImageCoordinates(0, 0)
				local rightMostX, bottomMostY = self.graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

				leftTile   = math.floor(leftMostX / 16)
				rightTile  = math.floor(rightMostX / 16)
				topTile    = math.floor(topMostY / 16)
				bottomTile = math.floor(bottomMostY / 16)
				
				local alpha = self.graphics:getScale() - 1
				
				self.graphics:setColor(1, 1, 1, alpha)
				self.graphics:setFontSize(6)

				for tileX = math.max(0, leftTile), math.min(4095, rightTile) do
					local x = tileX % 16
					local cx = math.floor(tileX / 16) % 16
					local scx = math.floor(tileX / 256)
					
					self.graphics:printf(self.hex[scx + 1] .. self.hex[cx + 1] .. self.hex[x + 1], tileX * 16, -9, 16, "center")
				end

				for tileY = math.max(0, topTile), math.min(4095, bottomTile) do
					local y = tileY % 16
					local cy = math.floor(tileY / 16) % 16
					local scy = math.floor(tileY / 256)
					self.graphics:printf(self.hex[scy + 1] .. self.hex[cy + 1] .. self.hex[y + 1], -20, tileY * 16 + 5, 16, "right")
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
