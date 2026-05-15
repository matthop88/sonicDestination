return {
	create = function(self, bgData)
		local bgChunksImage = self:loadImage(bgData.chunksImageName)
		local highestChunkIndex = self:calculateHighestChunkIndex(bgData.slices)
		local chunks = self:createChunks { image = bgChunksImage, numChunks = highestChunkIndex, slices = bgData.slices }

		return {
			chunks = chunks,

			drawChunk = function(self, graphics, chunkIndex, x, y)
				graphics:setColor(1, 1, 1)
				local chunk = self.chunks[chunkIndex]
				graphics:draw(self.chunks.image, chunk.quad, x, y, 0, 1, 1)
			end,
		}
	end,

	loadImage = function(self, chunksImageName)
		local chunksImagePath = relativePath("resources/images/backgrounds/" .. chunksImageName .. ".png")
        local chunksImg = love.graphics.newImage(chunksImagePath)
		chunksImg:setFilter("nearest", "nearest")

		return chunksImg
	end,

	calculateHighestChunkIndex = function(self, slices)
		local highestChunkIndex = 0
		for _, slice in ipairs(slices) do
			for _, chunkIndex in ipairs(slice.chunks) do
				highestChunkIndex = math.max(highestChunkIndex, chunkIndex)
			end
		end
		return highestChunkIndex
	end,

	createChunks = function(self, params)
		local chunks = {}

		local x, y = 0, 0
		
		for i = 1, params.numChunks do
			table.insert(chunks, { x = x, y = y, w = 256, h = 256 })
			x = x + 256
			if x >= 2304 then
				x = 0
				y = y + 256
			end
		end

		for _, slice in ipairs(params.slices) do
			for _, chunkIndex in ipairs(slice.chunks) do
				chunks[chunkIndex].h = slice.h
			end
		end

		for _, chunk in ipairs(chunks) do
			chunk.quad = love.graphics.newQuad(chunk.x, chunk.y, chunk.w, chunk.h, params.image:getWidth(), params.image:getHeight())
		end

		chunks.image = params.image
		return chunks
	end,
}
