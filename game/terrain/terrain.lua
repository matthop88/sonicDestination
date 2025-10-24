local MAP_PATH    = relativePath("resources/zones/maps/ghz1Map.lua")
local CHUNKS_PATH = relativePath("resources/zones/chunks/ghzChunks.lua")

local MAP_DATA    = dofile(MAP_PATH)
local CHUNKS_IMG
local CHUNKS_DATA
local SOLIDS
local CHUNKS
return {
    init = function(self, params)
        self.pageWidth  = #MAP_DATA[1] * 256
        self.pageHeight = #MAP_DATA    * 256
        self.graphics   = params.GRAPHICS

        CHUNKS_IMG, CHUNKS_DATA = requireRelative("terrain/chunkImageBuilder"):create(CHUNKS_PATH)
        SOLIDS                  = requireRelative("terrain/solidsBuilder"):create(CHUNKS_DATA)
        CHUNKS                  = requireRelative("terrain/chunksBuilder"):create(CHUNKS_IMG)
        
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
                SOLIDS:draw(self.graphics, rowNum, colNum, chunkID)
            end
        end
        self.graphics:setColor(1, 1, 1)
	end,

    getChunkAt = function(self, x, y)
        local chunkID = self:getChunkIDAt(x, y)
        if    chunkID == nil then return nil
        else                      return CHUNKS_DATA[chunkID] end
    end,

    getChunkIDAt = function(self, x, y)
        local mapX, mapY = self:screenToMapCoordinates(x, y)
        local mapRow = MAP_DATA[mapY] or {}
        return mapRow[mapX]
    end,

    screenToMapCoordinates = function(self, x, y)
        return math.floor(x / 256) + 1, math.floor(y / 256) + 1
    end,

    refresh = function(self)
        self:init({ GRAPHICS = self.graphics })
    end,
}
