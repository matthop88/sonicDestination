return {
	create = function(self)
		return ({
			init = function(self)
				return self
			end,

			update = function(self, mapDataFilename, chunkDataFilename)
				local mapData = self:loadMapData(mapDataFilename)
				self:modifyMapData(mapData, chunkDataFilename)
				self:saveMapData(mapData, mapDataFilename)
			end,

			loadMapData = function(self, mapDataFilename)
				return require("resources/zones/maps/" .. mapDataFilename)
			end,

			modifyMapData = function(self, mapData, chunkDataFilename)
				mapData.chunksDataName = chunkDataFilename
			end,

			saveMapData = function(self, mapData, mapDataFilename)
				love.filesystem.createDirectory("resources/zones/maps")
				love.filesystem.write("resources/zones/maps/" .. mapDataFilename .. ".lua", self:encodeMapData(mapData))
			end,

			encodeMapData = function(self, mapData)
				local mapEncoder = require("tools/lib/map/mapEncoder")
				return mapEncoder:encode(mapData)
			end,

		}):init()
	end,
}
