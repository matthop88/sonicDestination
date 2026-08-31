local TILES_BUILDER = dofile(relativePath("world/terrain/tilesBuilder.lua"))

return {
	create = function(self, bgData)
		local chunksData   = dofile(relativePath("resources/zones/backgrounds/" .. bgData.chunksName .. ".lua"))
        local tilesImgPath = relativePath("resources/images/backgrounds/" .. chunksData.tilesImageName .. ".png")
        local tiles        = TILES_BUILDER:create(tilesImgPath)

        local altTiles     = nil
        if bgData.altTiles then
        	altTiles = dofile(relativePath("resources/zones/backgrounds/" .. bgData.altTiles .. ".lua"))
       	end

       	chunksData.altChunkMap  = {}

        self:augmentChunksWithAltTiles(chunksData, altTiles)

		local chunksImage = self:renderChunks(chunksData, tiles)
		chunksImage:setFilter("nearest", "nearest")

		return self:createChunks(chunksImage, chunksData, tiles.tilesImg)
	end,

	renderChunks = function(self, chunksData, tiles)
        local width, height = self:calculateImageDimensions(chunksData)
        local imageBuffer = love.graphics.newCanvas(width, height)

        love.graphics.setCanvas(imageBuffer)
        self:drawChunks(chunksData, tiles)
        love.graphics.setCanvas()     

        return imageBuffer
    end,

    augmentChunksWithAltTiles = function(self, chunksData, altTiles)
    	if altTiles then
    		for n, chunk in ipairs(chunksData) do
	    		local extraChunks = 0
	    		for _, row in ipairs(chunk) do
	    			for _, tile in ipairs(row) do
	    				if altTiles[tile] then
	    					extraChunks = math.max(extraChunks, #altTiles[tile])
	    				end
	    			end
	    		end
	    		local altChunks = {}
	    		for i = 1, extraChunks do
    				local newChunk = { chunkID = #chunksData + 1, height = chunk.height }
    				for j = 1, chunk.height do
    					table.insert(newChunk, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, })
    				end
    				for r, row in ipairs(chunk) do
    					for t, tile in ipairs(row) do
    						if altTiles[tile] then
    							local altTile = altTiles[tile][i]
    							if altTile then
    								newChunk[r][t] = altTile
    							end
    						end
    					end
    				end
    				table.insert(chunksData, newChunk)
    				table.insert(altChunks, newChunk.chunkID)
    			end
    			if #altChunks > 0 then
    				chunksData.altChunkMap[chunk.chunkID] = altChunks
    			end
	    	end
	    end
	end,

    calculateImageDimensions = function(self, chunksData)
        local widthInChunks  = math.min(#chunksData, 9)
        local maxHeight = 0
        local chunkIndexInRow = 1
        local heightInTiles = 0

        for n, chunk in ipairs(chunksData) do
        	maxHeight = math.max(maxHeight, chunk.height)
        	chunkIndexInRow = chunkIndexInRow + 1
        	if chunkIndexInRow > 9 then
        		chunkIndexInRow = 1
        		heightInTiles = heightInTiles + maxHeight
        		maxHeight = 0
        	end
        end
        heightInTiles = heightInTiles + maxHeight
        
        return widthInChunks * 256, heightInTiles * 16
    end,

    drawChunks = function(self, chunksData, tiles)
        local x, y = 0, 0
        local heightInTiles = 0
        for n, chunk in ipairs(chunksData) do
            x = ((n - 1) % 9) * 256
            if x == 0 then
            	y = y + (heightInTiles * 16)
            	heightInTiles = 0
            end
            self:drawChunk(chunk, x, y, tiles)
            heightInTiles = math.max(heightInTiles, chunk.height)
        end
    end,

    drawChunk = function(self, chunk, x, y, tiles)
    	for _, row in ipairs(chunk) do
            self:drawRow(row, x, y, tiles)
            y = y + 16
        end
    end,

    drawRow = function(self, row, x, y, tiles)
        for n, tileID in ipairs(row) do
        	tiles:draw(x, y, tileID)
            x = x + 16 
        end
    end,

    createChunks = function(self, chunksImage, chunksData, tilesImage)
        local x, y = 0, 0
        local heightInTiles = 0
        for n, chunk in ipairs(chunksData) do
            x = ((n - 1) % 9) * 256
            if x == 0 then
            	y = y + (heightInTiles * 16)
            	heightInTiles = 0
            end
            chunk.quad = love.graphics.newQuad(x, y, 256, chunk.height * 16, chunksImage:getWidth(), chunksImage:getHeight())
            chunk.q = { x = x, y = y, w = 256, h = chunk.height * 16 }
            heightInTiles = math.max(heightInTiles, chunk.height)
        end

        local chunksImageData = chunksImage:newImageData()
        chunksImageData:encode("png", "tempBGChunks.png")

        chunksData.image = chunksImage
        chunksData.drawChunk = function(self, graphics, chunkIndex, x, y, colors)
	      	graphics:setColor(1, 1, 1)
			local chunk = self[chunkIndex]
			graphics:draw(self.image, chunk.quad, x, y, 0, 1, 1)
			local altChunks = self.altChunkMap[chunkIndex] or {}
			altIndex = 1
			for _, c in ipairs(altChunks) do
				local chunk = self[c]
				graphics:setColor(colors[altIndex])
				graphics:draw(self.image, chunk.quad, x, y, 0, 1, 1)
				altIndex = altIndex + 1
				if altIndex > #colors then altIndex = 1 end
			end
		end

        chunksData.drawSlice = function(self, graphics, chunkIndex, x, y, slice)
            graphics:setColor(1, 1, 1)
            local chunk = self[chunkIndex]
            if slice.quad == nil then
                slice.quad = love.graphics.newQuad(chunk.q.x, chunk.q.y + slice.sliceY, chunk.q.w, 1, self.image:getWidth(), self.image:getHeight())
            end
                    
            graphics:draw(self.image, slice.quad, x, y, 0, 1, 1)
        end

        return chunksData
    end,
}
