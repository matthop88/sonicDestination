local TILES_BUILDER = require("tools/chunkDoctor/tilesBuilder")

return {
	create = function(self, tilesImageName)
        local tilesImgPath = "resources/zones/tiles/" .. tilesImageName .. ".png"
        
        self.tiles = TILES_BUILDER:create(tilesImgPath)

        return self
	end,

    draw = function(self, chunk, x, y, graphics, gridSize)
        self:drawRows(chunk, x, y, graphics, gridSize)
    end,

    drawRows = function(self, chunk, x, y, graphics, gridSize)
        for _, row in ipairs(chunk) do
            self:drawRow(row, x, y, graphics, gridSize)
            y = y + 16
        end
    end,

    drawSolids = function(self, chunk, x, y, graphics, gridSize)
        for _, row in ipairs(chunk) do
            self:drawSolidsForRow(row, x, y, graphics, gridSize)
            y = y + 16
        end
    end,

    drawTile = function(self, tileID, chunkX, chunkY, x, y, scale, graphics, color)
        self.tiles:draw(x + (chunkX * 16), y + (chunkY * 16), tileID, graphics, nil, scale, color)
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

}
