local TILES_BUILDER = require("tools/chunkDoctor/tilesBuilder")

return {
	create = function(self, chunksDataPath)
        self.chunksData = dofile(chunksDataPath)
        local tilesImgPath = "resources/zones/tiles/" .. self.chunksData.tilesImageName .. ".png"
        
        self.tiles = TILES_BUILDER:create(tilesImgPath)

        return self
	end,

    draw = function(self, chunkID, x, y, graphics, gridSize)
        local chunk = self.chunksData[chunkID]
        
        for _, row in ipairs(chunk) do
            self:drawRow(row, x, y, graphics, gridSize)
            y = y + 16
        end
    end,

    getTileID = function(self, chunkID, chunkX, chunkY)
        local chunk = self.chunksData[chunkID]
        
        local tileRow = chunk[chunkY + 1]
        if tileRow ~= nil then
            local tileID  = tileRow[chunkX + 1]

            return tileID
        end
    end,

    drawTile = function(self, chunkID, chunkX, chunkY, x, y, scale, graphics, color)
        local tileID = self:getTileID(chunkID, chunkX, chunkY)
        if tileID ~= nil then
            self.tiles:draw(x + (chunkX * 16), y + (chunkY * 16), tileID, graphics, nil, scale, color)
        end
    end,

    drawTileAt = function(self, tileID, x, y, graphics, scale, color)
        self.tiles:draw(x, y, tileID, graphics, nil, scale, color)
    end,

    drawRow = function(self, row, x, y, graphics, gridSize)
        for n, tileID in ipairs(row) do
            self.tiles:draw(x, y, tileID, graphics, gridSize)
            x = x + 16
        end
    end,

	getNumChunks = function(self)
        return #self.chunksData
    end,
}
