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
        
        self:drawRows(chunk, x, y, graphics, gridSize)
    end,

    drawRows = function(self, chunk, x, y, graphics, gridSize)
        for _, row in ipairs(chunk) do
            self:drawRow(row, x, y, graphics, gridSize)
            y = y + 16
        end
    end,

    drawSolids = function(self, chunkID, x, y, graphics, gridSize)
        local chunk = self.chunksData[chunkID]
        for _, row in ipairs(chunk) do
            self:drawSolidsForRow(row, x, y, graphics, gridSize)
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

    setTileID = function(self, tileID, chunkID, chunkX, chunkY)
        local chunk = self.chunksData[chunkID]
        
        local tileRow = chunk[chunkY + 1]
        if tileRow ~= nil then
            tileRow[chunkX + 1] = tileID
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

    drawSolidsForRow = function(self, row, x, y, graphics, gridSize)
        for n, tileID in ipairs(row) do
            if row.S ~= nil and row.S[n] == 1 then
                graphics:setLineWidth(2)
                graphics:line(x, y + 16, x + 16, y + 16)
            end
            x = x + 16
        end
    end,

    toggleSolidAt = function(self, chunkID, tileX, tileY)
        local chunk = self.chunksData[chunkID]
        local row = chunk[tileY]
        if row.S == nil then row.S = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, } end
        row.S[tileX] = 1 - row.S[tileX]
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
