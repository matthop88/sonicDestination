return {
	create = function(self, chunksDataPath)
        self.chunksData = dofile(chunksDataPath)
        
        return self
	end,

	getChunk = function(self, chunkID)
		return self.chunksData[chunkID]
	end,

	getTilesImageName = function(self)
		return self.chunksData.tilesImageName
	end,

    getTileID = function(self, chunkID, chunkX, chunkY)
        local chunk = self.chunksData[chunkID]
        
        local tileRow = chunk[chunkY + 1]
        if tileRow ~= nil then
            local tileID  = tileRow[chunkX + 1]

            return tileID
        end
    end,

    setTileID = function(self, tileID, chunkID, chunkX, chunkY)
        local chunk = self.chunksData[chunkID]
        
        local tileRow = chunk[chunkY + 1]
        if tileRow ~= nil and chunkX < 16 then
            tileRow[chunkX + 1] = tileID
        end
    end,

    toggleSolidAt = function(self, chunkID, tileX, tileY)
        local chunk = self.chunksData[chunkID]
        local row = chunk[tileY]
        if row.S == nil then row.S = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, } end
        row.S[tileX] = 1 - row.S[tileX]
        return row.S[tileX]
    end,

    getSolidValueAt = function(self, chunkID, tileX, tileY)
        local chunk = self.chunksData[chunkID]
        local row = chunk[tileY]
        if row.S ~= nil then return row.S[tileX] end
    end,

    setSolidValueAt = function(self, chunkID, tileX, tileY, value)
        local chunk = self.chunksData[chunkID]
        local row = chunk[tileY]
        if row.S == nil then row.S = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, } end
        row.S[tileX] = value
    end,

	getNumChunks = function(self)
        return #self.chunksData
    end,

    saveChunkData = function(self, chunkFilename)
        love.filesystem.createDirectory("resources/zones/chunks")
        love.filesystem.write("resources/zones/chunks/" .. chunkFilename .. ".lua", self:encodeChunkData())
    end,

    encodeChunkData = function(self)
        local chunkEncoder = require("tools/lib/map/chunkEncoder")
        return chunkEncoder:encode(self.chunksData)
    end,
}
