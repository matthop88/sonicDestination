local MAIN_GRAFX                  = require("tools/lib/graphics"):create()
local CHUNK_ARTIST

local chunkID    = 1
local mainChunkY = require("tools/lib/tweenableValue"):create(0, { speed = 4 })
local gridSize   = require("tools/lib/tweenableValue"):create(0, { speed = 4 }),

MAIN_GRAFX:setScale(2)

return {
    init = function(self, chunkArtist)
        CHUNK_ARTIST = chunkArtist
        return self
    end,

    draw = function(self)
        for i = 1, CHUNK_ARTIST:getNumChunks() do
            self:renderChunk(i, ((i - 1) * 400) + 72)
        end
        self:renderChunk(1, (CHUNK_ARTIST:getNumChunks() * 400) + 72)
        self:renderChunk(CHUNK_ARTIST:getNumChunks(), -328)
    end,

    update = function(self, dt)
        mainChunkY:update(dt)
        gridSize:update(dt)

        if     mainChunkY:get() == self:getMainYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
            mainChunkY:set(self:getMainYForChunk(1))
        elseif mainChunkY:get() == self:getMainYForChunk(0) then
            mainChunkY:set(self:getMainYForChunk(CHUNK_ARTIST:getNumChunks()))
        end
        MAIN_GRAFX:setY(mainChunkY:get())
    end,

    handleKeypressed = function(self, key)
        if key == "up" then
            self:prevChunk()
        elseif key == "down" then
            self:nextChunk()
        elseif key == "space" then
            self:toggleGridMode()
        end
    end,

    handleKeyreleased = function(self, key)
        mainChunkY.speed = 4
    end,

    renderChunk = function(self, chunkNum, y)
        if y + MAIN_GRAFX:getY() < 400 and y + MAIN_GRAFX:getY() > -256 then        
            MAIN_GRAFX:setColor(1, 1, 1)
            MAIN_GRAFX:setFontSize(32)
            CHUNK_ARTIST:draw(chunkNum, 65, y, MAIN_GRAFX, gridSize:get() / 100)
            MAIN_GRAFX:printf("" .. chunkNum, 15, y + 112, 50, "center")
        end
    end,

    prevChunk = function(self)
        if not mainChunkY:inFlux() then
            chunkID = chunkID - 1
            if chunkID < 1 then 
                chunkID = CHUNK_ARTIST:getNumChunks() 
                self:moveMainYToChunk(0)
            else
                self:moveMainYToChunk(chunkID)
            end
        end
    end,

    nextChunk = function(self)
        if not mainChunkY:inFlux() then
            chunkID = chunkID + 1
            if chunkID > CHUNK_ARTIST:getNumChunks() then
                chunkID = 1
                self:moveMainYToChunk(CHUNK_ARTIST:getNumChunks() + 1)
            else
                self:moveMainYToChunk(chunkID)
            end
        end
    end,

    toggleGridMode = function(self)
        if gridSize:get() == 0 then gridSize:setDestination(200)
        else                        gridSize:setDestination(0)  end
    end,
        
    moveMainYToChunk = function(self, chunkNum)
        mainChunkY:setDestination(self:getMainYForChunk(chunkNum))
    end,

    getMainYForChunk = function(self, chunkNum)
        return -(chunkNum - 1) * 400
    end,

    onKeyRepeat = function() 
        mainChunkY.speed = 12 
    end,
}
