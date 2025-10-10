local CHUNKS = {
    init = function(self, chunksImg)
    	self.chunksImg = chunksImg

        local chunkCount = self:calculateChunkCount()
        for i = 1, chunkCount do
            local chunkX = ((i - 1) % 9)           * 256
            local chunkY = math.floor((i - 1) / 9) * 256
            
            table.insert(self, love.graphics.newQuad(chunkX, chunkY, 256, 256, self.chunksImg:getWidth(), self.chunksImg:getHeight()))
        end

        return self
    end,

    calculateChunkCount = function(self)
        local width, height = self.chunksImg:getWidth(), self.chunksImg:getHeight()

        return math.floor(width / 256) * math.floor(height / 256)
    end,

    get = function(self, chunkID)
    	return self[chunkID]
    end,

    draw = function(self, graphics, rowNum, colNum, chunkID)
    	local y = (rowNum - 1) * 256
        local x = (colNum - 1) * 256

		y = y - 384
		
        graphics:setColor(1, 1, 1)
    	graphics:draw(self.chunksImg, self:get(chunkID), x, y, 0, 1, 1)
	end,

}

return {
	create = function(self, chunkDataPath)
		-- ignore chunkDataPath... for now
		local chunksImgPath = relativePath("resources/zones/chunks/ghzChunks_IMG.png")

		local chunksImg     = love.graphics.newImage(chunksImgPath)
		chunksImg:setFilter("nearest", "nearest")

		return CHUNKS:init(chunksImg)
	end,
}
