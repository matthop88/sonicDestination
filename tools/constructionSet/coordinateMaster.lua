return {
	hex = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" },

	drawCoordinates = function(self, graphics)
		local scale = graphics:getScale()
		
		if scale < 0.15                 then self:drawSuperChunkCoordinates(graphics) end
		if scale > 0.05 and scale < 2   then self:drawChunkCoordinates(graphics)      end 
		if scale > 1    and scale <= 40 then self:drawTileCoordinates(graphics)       end
	end,

	drawSuperChunkCoordinates = function(self, graphics)
		local leftMostX,  topMostY    = graphics:screenToImageCoordinates(0, 0)
		local rightMostX, bottomMostY = graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

		local alpha = 1 - ((graphics:getScale() - 0.05) * 10)
		
		graphics:setColor(1, 1, 1, alpha)
		
		local fontSize = math.min(1536, math.max(768, 768 - (topMostY / 3)))
		graphics:setFontSize(fontSize)
		
		for x = 0, 15 do
			graphics:printf("" .. self.hex[x + 1], x * 256 * 16, math.max(-2400, topMostY), 256 * 16, "center")
		end

		local fontSize = math.min(1536, math.max(768, 768 - (leftMostX / 5)))
		graphics:setFontSize(fontSize)
		
		for y = 0, 15 do
			graphics:printf("" .. self.hex[y + 1], math.max(-3000, leftMostX), (y * 256 * 16 + (2048 - (fontSize * 0.6))), fontSize * 0.8, "right")
		end
	end,

	drawChunkCoordinates = function(self, graphics)
		local leftMostX,  topMostY    = graphics:screenToImageCoordinates(0, 0)
		local rightMostX, bottomMostY = graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

		leftChunk   = math.floor(leftMostX / 256)
		rightChunk  = math.floor(rightMostX / 256)
		topChunk    = math.floor(topMostY / 256)
		bottomChunk = math.floor(bottomMostY / 256)

		local alpha = (graphics:getScale() - 0.05) * 10
		
		if graphics:getScale() > 1 then
			alpha = 1 - (graphics:getScale() - 1)
		end
		graphics:setColor(1, 1, 1, alpha)

		local fontSize = math.min(96, math.max(24 / graphics:getScale(), 24 - (leftMostX / 3)))
		graphics:setFontSize(fontSize)

		for chunkY = math.max(0, topChunk), math.min(255, bottomChunk) do
			local y = chunkY % 16
			local scy = math.floor(chunkY / 16)
			
			graphics:printf(self.hex[scy + 1] .. self.hex[y + 1], math.max(-200, leftMostX), chunkY * 256 + (128 - (fontSize * 0.7)), 1.5 * fontSize, "right")
		end
		
		fontSize = math.min(96, math.max(24 / graphics:getScale(), 24 - (topMostY / 2)))
		graphics:setFontSize(fontSize)
	
		graphics:setColor(0, 0, 0, alpha)
		graphics:rectangle("fill", leftMostX, topMostY, rightMostX - leftMostX, graphics:getFontHeight())
		graphics:setColor(1, 1, 1, alpha)

		for chunkX = math.max(0, leftChunk), math.min(255, rightChunk) do
			local x = chunkX % 16
			local scx = math.floor(chunkX / 16)

			graphics:printf(self.hex[scx + 1] .. self.hex[x + 1], chunkX * 256, math.max(-150, topMostY), 256, "center")
		end
	end,

	drawTileCoordinates = function(self, graphics)
		local fontWidth = graphics:getFontWidth("FFF")
		local leftMostX,  topMostY    = graphics:screenToImageCoordinates(0, 0)
		local rightMostX, bottomMostY = graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

		leftTile   = math.floor(leftMostX / 16)
		rightTile  = math.floor(rightMostX / 16)
		topTile    = math.floor(topMostY / 16)
		bottomTile = math.floor(bottomMostY / 16)
		
		local alpha = graphics:getScale() - 1
		if graphics:getScale() > 20 then
			alpha = 1 - ((graphics:getScale() - 20) / 20)
		end
		local s = 12 / graphics:getScale()
		
		local fontSize = math.max(2, math.min(6, math.max(s, s - (leftMostX / 6))))
		graphics:setFontSize(fontSize)
		graphics:setColor(1, 1, 1, alpha)
		
		for tileY = math.max(0, topTile), math.min(4095, bottomTile) do
			local y = tileY % 16
			local cy = math.floor(tileY / 16) % 16
			local scy = math.floor(tileY / 256)
			graphics:printf(self.hex[scy + 1] .. self.hex[cy + 1] .. self.hex[y + 1], math.max(-16, leftMostX), tileY * 16 + (8 - fontSize / 2), 3 * fontSize, "left")
		end

		local fontSize = math.max(2, math.min(6, math.max(s, s - (topMostY / 3))))
		graphics:setFontSize(fontSize)

		graphics:setColor(0, 0, 0, alpha)
		graphics:rectangle("fill", leftMostX, topMostY, rightMostX - leftMostX, graphics:getFontHeight() + 0.5)
		graphics:setColor(1, 1, 1, alpha)

		for tileX = math.max(0, leftTile), math.min(4095, rightTile) do
			local x = tileX % 16
			local cx = math.floor(tileX / 16) % 16
			local scx = math.floor(tileX / 256)
			
			graphics:printf(self.hex[scx + 1] .. self.hex[cx + 1] .. self.hex[x + 1], tileX * 16, math.max(-9, topMostY), 16, "center")
		end	
	end,
}
