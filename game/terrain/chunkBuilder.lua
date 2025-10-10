return {
	create = function(self, chunkDataPath)
		-- ignore chunkDataPath... for now
		local chunksImgPath = relativePath("resources/zones/chunks/ghzChunks_IMG.png")

		local chunksImg     = love.graphics.newImage(chunksImgPath)
		chunksImg:setFilter("nearest", "nearest")

		return chunksImg
	end,
}
