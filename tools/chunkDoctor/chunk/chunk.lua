local CHUNK_MODEL
local CHUNK_ARTIST

return {
	create = function(self, chunksDataPath)
        CHUNK_MODEL  = require("tools/chunkDoctor/chunk/chunkModel"):create(chunksDataPath)
        CHUNK_ARTIST = require("tools/chunkDoctor/chunk/chunkArtist"):create(CHUNK_MODEL:getTilesImageName())

        return self
	end,

    draw = function(self, chunkID, x, y, graphics, gridSize)
        local chunk = CHUNK_MODEL:getChunk(chunkID)
        
        CHUNK_ARTIST:draw(chunk, x, y, graphics, gridSize)
    end,

    drawSolids = function(self, chunkID, x, y, graphics, gridSize)
        local chunk = CHUNK_MODEL:getChunk(chunkID)

        CHUNK_ARTIST:drawSolids(chunk, x, y, graphics, gridSize)
    end,

    getTileID = function(self, chunkID, chunkX, chunkY)
        return CHUNK_MODEL:getTileID(chunkID, chunkX, chunkY)
    end,

    setTileID = function(self, tileID, chunkID, chunkX, chunkY)
        CHUNK_MODEL:setTileID(tileID, chunkID, chunkX, chunkY)
    end,

    drawTile = function(self, chunkID, chunkX, chunkY, x, y, scale, graphics, color)
        local tileID = self:getTileID(chunkID, chunkX, chunkY)
        if tileID ~= nil then
            CHUNK_ARTIST:drawTile(tileID, chunkX, chunkY, x, y, scale, graphics, color)
        end
    end,

    drawTileAt = function(self, tileID, x, y, graphics, scale, color)
        CHUNK_ARTIST:drawTileAt(tileID, x, y, graphics, scale, color)
    end,

    toggleSolidAt = function(self, chunkID, tileX, tileY)
        return CHUNK_MODEL:toggleSolidAt(chunkID, tileX, tileY)
    end,

    getSolidValueAt = function(self, chunkID, tileX, tileY)
        return CHUNK_MODEL:getSolidValueAt(chunkID, tileX, tileY)
    end,

    setSolidValueAt = function(self, chunkID, tileX, tileY, value)
        CHUNK_MODEL:setSolidValueAt(chunkID, tileX, tileY, value)
    end,

	getNumChunks = function(self)
        return CHUNK_MODEL:getNumChunks()
    end,

    saveChunkData = function(self, chunkFilename)
        CHUNK_MODEL:saveChunkData(chunkFilename)
    end,

    encodeChunkData = function(self)
        CHUNK_MODEL:encodeChunkData()
    end,

}
