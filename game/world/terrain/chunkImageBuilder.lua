local TILES_BUILDER = requireRelative("terrain/tilesBuilder")

return {
	create = function(self, chunksDataPath)
        local chunksData = dofile(chunksDataPath)
        local tilesImgPath = relativePath("resources/zones/tiles/" .. chunksData.tilesImageName .. ".png")
        
        local tiles = TILES_BUILDER:create(tilesImgPath)

        local chunksImg = self:renderChunks(chunksData, tiles)
        chunksImg:setFilter("nearest", "nearest")

        return chunksImg, chunksData
	end,

    renderChunks = function(self, chunksData, tiles)
        local width, height = self:calculateImageDimensions(chunksData)
        local imageBuffer = love.graphics.newCanvas(width, height)

        love.graphics.setCanvas(imageBuffer)
        self:drawChunks(chunksData, tiles)
        love.graphics.setCanvas()     

        return imageBuffer
    end,

    calculateImageDimensions = function(self, chunksData)
        local widthInChunks  = math.min(#chunksData, 9)
        local heightInChunks = math.floor((#chunksData - 1) / 9) + 1

        return widthInChunks * 256, heightInChunks * 256
    end,

    drawChunks = function(self, chunksData, tiles)
        local x, y = 0, 0
        for n, chunk in ipairs(chunksData) do
            x = ((n - 1) % 9) * 256
            y = math.floor((n - 1) / 9) * 256
            self:drawChunk(chunk, x, y, tiles)
        end
    end,

    drawChunk = function(self, chunk, x, y, tiles)
        for _, row in ipairs(chunk) do
            self:drawRow(row, x, y, tiles)
            y = y + 16
        end
    end,

    drawRow = function(self, row, x, y, tiles)
        for n, tileID in ipairs(row) do
            tiles:draw(x, y, tileID)
            x = x + 16 
        end
    end,
}
