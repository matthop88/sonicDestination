
local CHUNKS_IMAGE = love.graphics.newImage(relativePath("resources/zones/chunks/ghzChunks_IMG.png"))
local MAP_DATA     = requireRelative("resources/zones/maps/ghz1Map")

CHUNKS_IMAGE:setFilter("nearest", "nearest")


local CHUNKS       = ({
    init = function(self)
        local chunkCount = self:calculateChunkCount()
        for i = 1, chunkCount do
            local chunkX = ((i - 1) % 9)           * 256
            local chunkY = math.floor((i - 1) / 9) * 256
            
            table.insert(self, love.graphics.newQuad(chunkX, chunkY, 256, 256, CHUNKS_IMAGE:getWidth(), CHUNKS_IMAGE:getHeight()))
        end

        return self
    end,

    calculateChunkCount = function(self)
        local width, height = CHUNKS_IMAGE:getWidth(), CHUNKS_IMAGE:getHeight()

        return math.floor(width / 256) * math.floor(height / 256)
    end,

    get = function(self, chunkID)
    	return self[chunkID]
    end,

}):init()


return {
    init = function(self, params)
        self.pageWidth  = #MAP_DATA[1] * 256
        self.pageHeight = #MAP_DATA    * 256
        self.graphics   = params.GRAPHICS

        return self
    end,

    draw = function(self)
        for rowNum, row in ipairs(MAP_DATA) do
            for colNum, chunkID in ipairs(row) do
                self:drawChunk(rowNum, colNum, chunkID)
            end
        end
    end,

    drawChunk = function(self, rowNum, colNum, chunkID)
    	local y = (rowNum - 1) * 256
        local x = (colNum - 1) * 256

		y = y - 384
		
        self.graphics:setColor(1, 1, 1)
    	self.graphics:draw(CHUNKS_IMAGE, CHUNKS:get(chunkID), x, y, 0, 1, 1)
	end,
}
