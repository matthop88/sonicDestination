local MAP_DATA

local CHUNK_FACTORY = requireRelative("world/terrain/chunkFactory")

local CHUNKS_IMG_NAME = 1
local CHUNK_ID        = 2

return {
    showSolids = false,
    
    init = function(self, params)
        self.mapName   = params.map
        local MAP_PATH = relativePath("resources/zones/maps/"   .. self.mapName)
        
        if _LOADED then _LOADED[MAP_PATH] = nil end
        MAP_DATA = require(MAP_PATH)

        self.map = self:loadMapData()

        self.pageWidth  = #self.map[1] * 256
        self.pageHeight = #self.map    * 256
        self.graphics   = params.GRAPHICS

        return self
    end,

    loadMapData = function(self)
        local chunkFactory = requireRelative("world/terrain/chunkFactory")
        local map = {}
        for i = 1, 256 do table.insert(map, {}) end

        for _, mapRow in ipairs(MAP_DATA) do
            local row = {}
            for _, elt in ipairs(mapRow.data) do
                if type(elt) == "table" then
                    if elt[CHUNKS_IMG_NAME] and elt[CHUNK_ID] then
                        local mapElt = { 
                            CHUNK_IMG_NAME = elt[CHUNKS_IMG_NAME],
                            ID             = elt[CHUNK_ID],
                            XFLIP          = elt.xFlip
                        }
                        table.insert(row, mapElt)
                    else
                        table.insert(row, {})
                    end
                else
                    local mapElt = {
                        CHUNK_IMG_NAME = MAP_DATA.chunksDataName,
                        ID             = elt,
                        XFLIP          = false
                    }
                    table.insert(row, mapElt)
                end

                map[mapRow.row] = row
            end
        end

        return map
    end,

    initChunks = function(self)
        CHUNKS_DATA = CHUNK_FACTORY:getData(MAP_DATA.chunksDataName)
        SOLIDS      = CHUNK_FACTORY:getSolids(MAP_DATA.chunksDataName)
        CHUNKS      = CHUNK_FACTORY:getChunks(MAP_DATA.chunksDataName)
    end,

    initChunk = function(self, chunkInfo)
        chunkInfo.CHUNKS = CHUNK_FACTORY:getChunks(chunkInfo.CHUNK_IMG_NAME)
        chunkInfo.SOLIDS = CHUNK_FACTORY:getSolids(chunkInfo.CHUNK_IMG_NAME)
        chunkInfo.DATA   = CHUNK_FACTORY:getData(chunkInfo.CHUNK_IMG_NAME)
        chunkInfo.CHUNK_IMG_NAME = nil
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
        for rowNum, row in ipairs(self.map) do
            for colNum, chunkInfo in ipairs(row) do
                self:drawChunk(rowNum, colNum, chunkInfo)
            end
        end
        self.graphics:setColor(1, 1, 1)
	end,

    drawChunk = function(self, rowNum, colNum, chunkInfo)
        if chunkInfo.XFLIP then
            self:drawXFlippedChunk(rowNum, colNum, chunkInfo)
        else
            self:drawVanillaChunk(rowNum, colNum, chunkInfo)
        end
    end,

    drawVanillaChunk = function(self, rowNum, colNum, chunkInfo)
        if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
        if chunkInfo.CHUNKS then
            chunkInfo.CHUNKS:draw(self.graphics, rowNum, colNum, chunkInfo.ID)
            if self.showSolids then 
                chunkInfo.SOLIDS:draw(self.graphics, rowNum, colNum, chunkInfo.ID)
            end
        end
    end,

    drawXFlippedChunk = function(self, rowNum, colNum, chunkInfo)
        if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
        if chunkInfo.CHUNKS then
            chunkInfo.CHUNKS:xFlippedDraw(self.graphics, rowNum, colNum, chunkInfo.ID)
            if self.showSolids then
                chunkInfo.SOLIDS:xFlippedDraw(self.graphics, rowNum, colNum, chunkInfo.ID)
            end
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
        local chunkInfo = self:getChunkInfoAt(x, y)
        if     chunkInfo == nil or chunkInfo.ID == nil then 
            return nil
        else
            if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
            return chunkInfo.DATA[chunkInfo.ID]
        end
    end,

    getChunkInfoAt = function(self, x, y)
        local mapX, mapY = self:screenToMapCoordinates(x, y)
        local mapRow = self.map[mapY] or { }
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
        local chunkInfo = self:getChunkInfoAt(x, y)
        if chunkInfo == nil or chunkInfo.ID == nil then 
            return nil
        else
            local xInChunk, yInChunk = self:screenToChunkCoordinates(x, y)
            if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
            return chunkInfo.SOLIDS:getSolidAt(chunkInfo.ID, xInChunk, yInChunk, chunkInfo.XFLIP)
        end
    end,

    screenToChunkCoordinates = function(self, x, y)
        local xInChunk, yInChunk = x % 256, y % 256
        return math.floor(xInChunk / 16) + 1, math.floor(yInChunk / 16) + 1
    end,

    refresh = function(self)
        self:init { GRAPHICS = self.graphics, map = self.mapName }
    end,

    toggleShowSolids = function(self)
        self.showSolids = not self.showSolids
    end,

	getObjectsDataName = function(self)
		return MAP_DATA.objectsDataName or "ghz1Objects"
	end,
}
                        local mapElt = { 
                            CHUNK_IMG_NAME = elt[CHUNKS_IMG_NAME],
                            ID             = elt[CHUNK_ID],
                            XFLIP          = elt.xFlip
                        }
                        table.insert(row, mapElt)
                    else
                        table.insert(row, {})
                    end
                else
                    local mapElt = {
                        CHUNK_IMG_NAME = MAP_DATA.chunksDataName,
                        ID             = elt,
                        XFLIP          = false
                    }
                    table.insert(row, mapElt)
                end

                map[mapRow.row] = row
            end
        end

        return map
    end,

    initChunks = function(self)
        CHUNKS_DATA = CHUNK_FACTORY:getData(MAP_DATA.chunksDataName)
        SOLIDS      = CHUNK_FACTORY:getSolids(MAP_DATA.chunksDataName)
        CHUNKS      = CHUNK_FACTORY:getChunks(MAP_DATA.chunksDataName)
    end,

    initChunk = function(self, chunkInfo)
        chunkInfo.CHUNKS = CHUNK_FACTORY:getChunks(chunkInfo.CHUNK_IMG_NAME)
        chunkInfo.SOLIDS = CHUNK_FACTORY:getSolids(chunkInfo.CHUNK_IMG_NAME)
        chunkInfo.DATA   = CHUNK_FACTORY:getData(chunkInfo.CHUNK_IMG_NAME)
        chunkInfo.CHUNK_IMG_NAME = nil
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
        for rowNum, row in ipairs(self.map) do
            for colNum, chunkInfo in ipairs(row) do
                self:drawChunk(rowNum, colNum, chunkInfo)
            end
        end
        self.graphics:setColor(1, 1, 1)
	end,

    drawChunk = function(self, rowNum, colNum, chunkInfo)
        if chunkInfo.XFLIP then
            self:drawXFlippedChunk(rowNum, colNum, chunkInfo)
        else
            self:drawVanillaChunk(rowNum, colNum, chunkInfo)
        end
    end,

    drawVanillaChunk = function(self, rowNum, colNum, chunkInfo)
        if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
        if chunkInfo.CHUNKS then
            chunkInfo.CHUNKS:draw(self.graphics, rowNum, colNum, chunkInfo.ID)
            if self.showSolids then 
                chunkInfo.SOLIDS:draw(self.graphics, rowNum, colNum, chunkInfo.ID)
            end
        end
    end,

    drawXFlippedChunk = function(self, rowNum, colNum, chunkInfo)
        if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
        if chunkInfo.CHUNKS then
            chunkInfo.CHUNKS:xFlippedDraw(self.graphics, rowNum, colNum, chunkInfo.ID)
            if self.showSolids then
                chunkInfo.SOLIDS:xFlippedDraw(self.graphics, rowNum, colNum, chunkInfo.ID)
            end
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
        local chunkInfo = self:getChunkInfoAt(x, y)
        if     chunkInfo == nil or chunkInfo.ID == nil then 
            return nil
        else
            if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
            return chunkInfo.DATA[chunkInfo.ID]
        end
    end,

    getChunkInfoAt = function(self, x, y)
        local mapX, mapY = self:screenToMapCoordinates(x, y)
        local mapRow = self.map[mapY] or { }
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
        local chunkInfo = self:getChunkInfoAt(x, y)
        if chunkInfo == nil or chunkInfo.ID == nil then 
            return nil
        else
            local xInChunk, yInChunk = self:screenToChunkCoordinates(x, y)
            if chunkInfo.CHUNK_IMG_NAME then self:initChunk(chunkInfo) end
            return chunkInfo.SOLIDS:getSolidAt(chunkInfo.ID, xInChunk, yInChunk)
        end
    end,

    screenToChunkCoordinates = function(self, x, y)
        local xInChunk, yInChunk = x % 256, y % 256
        return math.floor(xInChunk / 16) + 1, math.floor(yInChunk / 16) + 1
    end,

    refresh = function(self)
        self:init { GRAPHICS = self.graphics, map = self.mapName }
    end,

    toggleShowSolids = function(self)
        self.showSolids = not self.showSolids
    end,

	getObjectsDataName = function(self)
		return MAP_DATA.objectsDataName or "ghz1Objects"
	end,
}
