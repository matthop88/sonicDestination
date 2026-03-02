local MAP_DATA
local CHUNKS_DATA
local SOLIDS
local CHUNKS
local CHUNK_FACTORY = requireRelative("world/terrain/chunkFactory")

return {
    showSolids = false,
    
    init = function(self, params)
        
        self.map    = params.map
        
        local MAP_PATH    = relativePath("resources/zones/maps/"   .. self.map)
        if _LOADED then _LOADED[MAP_PATH] = nil end
        MAP_DATA    = require(MAP_PATH)

        self.pageWidth  = #MAP_DATA[1] * 256
        self.pageHeight = #MAP_DATA    * 256
        self.graphics   = params.GRAPHICS

        return self
    end,

    initChunks = function(self)
        CHUNKS_DATA = CHUNK_FACTORY:getData(MAP_DATA.chunksDataName)
        SOLIDS      = CHUNK_FACTORY:getSolids(MAP_DATA.chunksDataName)
        CHUNKS      = CHUNK_FACTORY:getChunks(MAP_DATA.chunksDataName)
    end,
        
    draw = function(self)
		self:drawBackground()
		self:drawTerrain()
    end,

    update = function(self, dt)
        -- do nothing
    end,

	drawBackground = function(self)
        self.graphics:setColor(0, 0.57, 1.0)
		self.graphics:rectangle("fill", self.graphics:calculateViewport())
	end,

	drawTerrain = function(self)
        self.graphics:setColor(1, 1, 1)
        for _, row in ipairs(MAP_DATA) do
            for colNum, chunkInfo in ipairs(row.data) do
                self:drawChunk(row.row, colNum, chunkInfo)
            end
        end
        self.graphics:setColor(1, 1, 1)
	end,

    drawChunk = function(self, rowNum, colNum, chunkInfo)
        if self:isXFlipped(chunkInfo) then
            self:drawXFlippedChunk(rowNum, colNum, chunkInfo[2])
        else
            self:drawVanillaChunk(rowNum, colNum, chunkInfo)
        end
    end,

    isXFlipped = function(self, chunkInfo)
        return type(chunkInfo) == "table" and chunkInfo[1] == "XFLIP"
    end,

    drawVanillaChunk = function(self, rowNum, colNum, chunkID)
        if not CHUNKS then self:initChunks() end
        CHUNKS:draw(self.graphics, rowNum, colNum, chunkID)
        if self.showSolids then 
            SOLIDS:draw(self.graphics, rowNum, colNum, chunkID) 
        end
    end,

    drawXFlippedChunk = function(self, rowNum, colNum, chunkID)
        if not CHUNKS then self:initChunks() end
        CHUNKS:xFlippedDraw(self.graphics, rowNum, colNum, chunkID)
        if self.showSolids then
            SOLIDS:xFlippedDraw(self.graphics, rowNum, colNum, chunkID)
        end
    end,

    drawSolidAt = function(self, x, y, color)
        self.graphics:setColor(color)
        self.graphics:setLineWidth(4)
        
        self.graphics:line(x, y + 2, x + 16, y + 2)
    end,

    getTileIDAt = function(self, x, y)
        local chunk = self:getChunkAt(x, y)
        if    chunk == nil then return nil
        else                    return self:getTileIDForChunkAt(chunk, x, y), chunk.chunkID end
    end,

    getChunkAt = function(self, x, y)
        if not CHUNKS_DATA then self:initChunks() end
        local chunkID = self:getChunkIDAt(x, y)
        if    chunkID == nil then return nil
        else                      return CHUNKS_DATA[chunkID] end
    end,

    getChunkIDAt = function(self, x, y)
        local mapX, mapY = self:screenToMapCoordinates(x, y)
        local mapRow = MAP_DATA[mapY] or { data = {} }
        return mapRow.data[mapX]
    end,

    screenToMapCoordinates = function(self, x, y)
        return math.floor(x / 256) + 1, math.floor(y / 256) + 1
    end,

    getTileIDForChunkAt = function(self, chunk, x, y)
        local xInChunk, yInChunk = self:screenToChunkCoordinates(x, y)
        return chunk[yInChunk][xInChunk]
    end,

    getSolidAt = function(self, x, y)
        if not SOLIDS then self:initChunks() end
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
        self:init { GRAPHICS = self.graphics, map = self.map }
    end,

    toggleShowSolids = function(self)
        self.showSolids = not self.showSolids
    end,

	getObjectsDataName = function(self)
		return MAP_DATA.objectsDataName or "ghz1Objects"
	end,
}
