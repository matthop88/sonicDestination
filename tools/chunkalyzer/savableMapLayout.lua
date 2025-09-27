return {
	create = function(self, mapChunks)
		return ({
			mapChunks = mapChunks,
			
			init = function(self)
				local width, height = self:calculateMapDimensions()

				print("Creating a Map Layout of dimensions " .. width .. "x" .. height .. "...")
				return self
			end,

			calculateMapDimensions = function(self)
				local maxChunkX, maxChunkY = 0, 0

				for _, c in ipairs(self.mapChunks) do
					maxChunkX = math.max(maxChunkX, c.mapX)
					maxChunkY = math.max(maxChunkY, c.mapY)
				end

				return math.floor(maxChunkX / 256) + 1, math.floor(maxChunkY / 256) + 1
			end,

		}):init()
	end,
}
