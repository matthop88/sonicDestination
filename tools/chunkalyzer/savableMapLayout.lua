return {
	create = function(self, mapChunks)
		return ({
			mapChunks = mapChunks,
			
			init = function(self)
				self.width, self.height = self:calculateMapDimensions()

				print("Creating a Map Layout of dimensions " .. self.width .. "x" .. self.height .. "...")
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

			save = function(self, mapFilename, chunksImageName)
				self:createMapData()
				self:saveMapData(mapFilename, chunksImageName)
			end,

			createMapData = function(self)
				self.mapData = {}

				for i = 1, self.height do table.insert(self.mapData, {}) end
				
				local currentRow = {}

				for n, c in ipairs(self.mapChunks) do
					local rowNum = math.floor((n - 1) / self.width) + 1
					table.insert(currentRow, c.id)
					if #currentRow == self.width then
						self.mapData[rowNum] = currentRow
						currentRow = {}
					end
				end
			end,

			saveMapData = function(self, mapFilename, chunksImageName)
				love.filesystem.createDirectory("resources/zones/maps")
				love.filesystem.write("resources/zones/maps/" .. mapFilename .. ".lua", self:encodeMapData(chunksImageName))
			end,

			encodeMapData = function(self, chunksImageName)
				self.mapData.chunksImageName = chunksImageName
				local mapEncoder = require("tools/lib/map/mapEncoder")
				return mapEncoder:encode(self.mapData)
			end,

		}):init()
	end,
}
