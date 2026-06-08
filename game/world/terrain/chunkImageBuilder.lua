local TILES_BUILDER = requireRelative("world/terrain/tilesBuilder")

return {
	create = function(self, chunksDataPath)
        local chunksData   = dofile(chunksDataPath)
        local tilesImgPath = relativePath("resources/zones/tiles/" .. chunksData.tilesImageName .. ".png")
        local tiles        = TILES_BUILDER:create(tilesImgPath)

        local altTiles     = nil
        if chunksData.altTilesName then
            print("Alt tiles found")
            altTiles = dofile(relativePath("resources/zones/tiles/" .. chunksData.altTilesName .. ".lua"))
        end

        self:augmentChunksWithAltTiles(chunksData, altTiles)

        local chunksImg = self:renderChunks(chunksData, tiles)
        chunksImg:setFilter("nearest", "nearest")

        if chunksData.altChunkMap then
            local chunksImageData = chunksImg:newImageData()
            chunksImageData:encode("png", "tempChunks.png")
        end

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

    augmentChunksWithAltTiles = function(self, chunksData, altTiles)
        if altTiles then
            chunksData.altChunkMap = {}

            for n, chunk in ipairs(chunksData) do
                local extraChunks = 0
                for _, row in ipairs(chunk) do
                    for _, tile in ipairs(row) do
                        if altTiles[tile] then
                            extraChunks = math.max(extraChunks, #altTiles[tile])
                        end
                    end
                end
                local altChunks = {}
                for i = 1, extraChunks do
                    local newChunk = { chunkID = #chunksData + 1, }
                    for j = 1, 16 do
                        table.insert(newChunk, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, })
                    end
                    for r, row in ipairs(chunk) do
                        for t, tile in ipairs(row) do
                            if altTiles[tile] then
                                local altTile = altTiles[tile][i]
                                if altTile then
                                    newChunk[r][t] = altTile
                                end
                            end
                        end
                    end
                    table.insert(chunksData, newChunk)
                    table.insert(altChunks, newChunk.chunkID)
                end
                if #altChunks > 0 then
                    chunksData.altChunkMap[chunk.chunkID] = altChunks
                end
            end
        end
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
