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

			save = function(self, mapFilename)
				self:createMapData()
				self:saveMapData(mapFilename)
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

			saveMapData = function(self, mapFilename)
				love.filesystem.createDirectory("resources/zones/maps")
				love.filesystem.write("resources/zones/maps/" .. mapFilename .. ".lua", self:encodeMapData())
			end,

			encodeMapData = function(self)
				serializedData = "return {\n"
				for _, row in ipairs(self.mapData) do
					local rowString = "  { "
					for _, chunkID in ipairs(row) do
						rowString = rowString .. (string.rep(" ", 3 - string.len("" .. chunkID))) .. chunkID .. ", "
					end
					serializedData = serializedData .. rowString .. "},\n"
				end
				return serializedData .. "}\n"
			end,

		}):init()
	end,
}
