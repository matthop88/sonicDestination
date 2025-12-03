local MAP_PATH    = relativePath("resources/zones/maps/scdPtp1Map.lua")
local CHUNKS_PATH = relativePath("resources/zones/chunks/scdPtpChunks.lua")

local MAP_DATA    = dofile(MAP_PATH)
local CHUNKS_IMG
local CHUNKS_DATA
local SOLIDS
local CHUNKS
return {
    showSolids = false,

    init = function(self, params)
        self.pageWidth  = #MAP_DATA[1] * 256
        self.pageHeight = #MAP_DATA    * 256
        self.graphics   = params.GRAPHICS

        CHUNKS_IMG, CHUNKS_DATA = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
        SOLIDS                  = requireRelative("world/terrain/solidsBuilder"):create(CHUNKS_DATA)
        CHUNKS                  = requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG)
        
        return self
    end,

    draw = function(self)
		self:drawBackground()
		self:drawTerrain()
    end,

	drawBackground = function(self)
        self.graphics:setColor(0, 0, 0)
		self.graphics:rectangle("fill", self.graphics:calculateViewport())
	end,

	drawTerrain = function(self)
        for rowNum, row in ipairs(MAP_DATA) do
            for colNum, chunkID in ipairs(row) do
                CHUNKS:draw(self.graphics, rowNum, colNum, chunkID)
                if self.showSolids then SOLIDS:draw(self.graphics, rowNum, colNum, chunkID) end
            end
        end
        self.graphics:setColor(1, 1, 1)
	end,

    getTileIDAt = function(self, x, y)
        local chunk = self:getChunkAt(x, y)
        if    chunk == nil then return nil
        else                    return self:getTileIDForChunkAt(chunk, x, y), chunk.chunkID end
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

    getTileIDForChunkAt = function(self, chunk, x, y)
        local xInChunk, yInChunk = self:screenToChunkCoordinates(x, y)
        return chunk[yInChunk][xInChunk]
    end,

    getSolidAt = function(self, x, y)
        local chunkID = self:getChunkIDAt(x, y)
        if chunkID == nil then return nil
        else
            local xInChunk, yInChunk = self:screenToChunkCoordinates(x, y)
            return SOLIDS:getSolidAt(chunkID, xInChunk, yInChunk)
        end
    end,

    screenToChunkCoordinates = function(self, x, y)
        local xInChunk, yInChunk = x % 256, y % 256
        return math.floor(xInChunk / 16) + 1, math.floor(yInChunk / 16) + 1
    end,

    refresh = function(self)
        self:init({ GRAPHICS = self.graphics })
    end,

    toggleShowSolids = function(self)
        self.showSolids = not self.showSolids
    end,

	getObjectsDataName = function(self)
		return MAP_DATA.objectsDataName
	end,
}
