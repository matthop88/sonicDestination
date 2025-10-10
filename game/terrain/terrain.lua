local CHUNK_BUILDER = requireRelative("terrain/chunkBuilder")

local MAP_PATH      = relativePath("resources/zones/maps/ghz1Map.lua")
local CHUNKS_PATH   = relativePath("resources/zones/chunks/ghzChunks.lua")

local MAP_DATA      = dofile(MAP_PATH)
local CHUNKS        = CHUNK_BUILDER:create(CHUNKS_PATH)

return {
    init = function(self, params)
        self.pageWidth  = #MAP_DATA[1] * 256
        self.pageHeight = #MAP_DATA    * 256
        self.graphics   = params.GRAPHICS

        return self
    end,

    draw = function(self)
		self:drawBackground()
		self:drawTerrain()
    end,

	drawBackground = function(self)
        local viewportRect = self.graphics:calculateViewportRect()
		self.graphics:setColor(0, 0, 0)
		self.graphics:rectangle("fill", viewportRect.x, viewportRect.y, viewportRect.w, viewportRect.h)
	end,

	drawTerrain = function(self)
		for rowNum, row in ipairs(MAP_DATA) do
            for colNum, chunkID in ipairs(row) do
                CHUNKS:draw(self.graphics, rowNum, colNum, chunkID)
            end
        end
	end,
}
