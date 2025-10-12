local TILES_BUILDER = require("tools/chunkDoctor/tilesBuilder")

return {
	create = function(self, chunksDataPath)
        self.chunksData = dofile(chunksDataPath)
        local tilesImgPath = "resources/zones/tiles/" .. self.chunksData.tilesImageName .. ".png"
        
        self.tiles = TILES_BUILDER:create(tilesImgPath)

        return self
	end,

    draw = function(self, chunkID, x, y)
        local chunk = self.chunksData[chunkID]
        
        for _, row in ipairs(chunk) do
            self:drawRow(row, x, y)
            y = y + 16
        end
    end,

    drawRow = function(self, row, x, y)
        for n, tileID in ipairs(row) do
            self.tiles:draw(x, y, tileID)
            x = x + 16 
        end
    end,

	getNumChunks = function(self)
        return #self.chunksData
    end,
}


