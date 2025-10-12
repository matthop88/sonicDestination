local TILES_BUILDER = require("tools/chunkDoctor/tilesBuilder")

return {
	create = function(self, chunksDataPath)
        self.chunksData = dofile(chunksDataPath)
        local tilesImgPath = "resources/zones/tiles/" .. self.chunksData.tilesImageName .. ".png"
        
        self.tiles = TILES_BUILDER:create(tilesImgPath)

        return self
	end,

    draw = function(self, chunkID, x, y, scale)
        scale = scale or 1
        local chunk = self.chunksData[chunkID]
        
        for _, row in ipairs(chunk) do
            self:drawRow(row, x, y, scale)
            y = y + (16 * scale)
        end
    end,

    drawRow = function(self, row, x, y, scale)
        for n, tileID in ipairs(row) do
            self.tiles:draw(x, y, tileID, scale)
            x = x + (16 * scale)
        end
    end,

	getNumChunks = function(self)
        return #self.chunksData
    end,
}


