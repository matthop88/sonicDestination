return {
	create = function(self, bgData)
		local bgChunksImage = self:loadImage(bgData.chunksImageName)
		local highestChunkIndex = self:calculateHighestChunkIndex(bgData.slices)
		local chunks = self:createChunks { image = bgChunksImage, numChunks = highestChunkIndex, slices = bgData.slices }

		return {
			chunks = chunks,

			drawChunk = function(self, chunkIndex, x, y)
				-- Drawing code goes here
			end,
		}
	end,

	loadImage = function(self, chunksImageName)
		return nil
	end,

	calculateHighestChunkIndex = function(self, slices)
		return 0
	end,

	createChunks = function(self, params)
		return {}
	end,
}
