return {
	create = function(self, chunkRepo)
		return ({
			chunkRepo = chunkRepo,
			
			init = function(self)
				return self
			end,

			save = function(self, chunkFilename,  tilesImageName)
				self:createChunkData()
				self:saveChunkData(chunkFilename, tilesImageName)
			end,

			createChunkData = function(self)
				self.chunkData = {}

				for chunkID, chunk in ipairs(self.chunkRepo) do
					
					local data = { chunkID = chunkID }	
					table.insert(self.chunkData, data)

					local chunkRow

					for n, tile in ipairs(chunk.tiles) do
						if (n - 1) % 16 == 0 then
							chunkRow = {}
							table.insert(data, chunkRow)
						end

						table.insert(chunkRow, tile.tileID)
					end
				end
			end,

			saveChunkData = function(self, chunkFilename, tilesImageName)
				love.filesystem.createDirectory("resources/zones/chunks")
				love.filesystem.write("resources/zones/chunks/" .. chunkFilename .. ".lua", self:encodeChunkData(tilesImageName))
			end,

			encodeChunkData = function(self, tilesImageName)
				self.chunkData.tilesImageName = tilesImageName
				local chunkEncoder = require("tools/lib/map/chunkEncoder")
				return chunkEncoder:encode(self.chunkData)
			end,

		}):init()
	end,
}
