local SIDEBAR_GRAFX    = require("tools/lib/graphics"):create()

local CHUNK_ARTIST

local chunkID    = 2
local mainChunkY =  require("tools/lib/tweenableValue"):create(0, { speed = 4 })

SIDEBAR_GRAFX:setScale(1)

return {
    init = function(self, chunkArtist)
        CHUNK_ARTIST = chunkArtist
        mainChunkY:set(self:getMainYForChunk(2))
        return self
    end,

    draw = function(self)
        for i = 1, CHUNK_ARTIST:getNumChunks() do
            self:renderChunk(i, ((i - 1) * 264) + 272)
        end
        self:renderChunk(1, (CHUNK_ARTIST:getNumChunks() * 264) + 272)
        self:renderChunk(CHUNK_ARTIST:getNumChunks(), 8)
        self:renderChunk(2, (CHUNK_ARTIST:getNumChunks() * 264) + 536)
        self:renderChunk(CHUNK_ARTIST:getNumChunks() - 1, -256)
    end,

    update = function(self, dt)
        mainChunkY:update(dt)
        if     mainChunkY:get() == self:getMainYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
            mainChunkY:set(self:getMainYForChunk(1))
        elseif mainChunkY:get() == self:getMainYForChunk(0) then
            mainChunkY:set(self:getMainYForChunk(CHUNK_ARTIST:getNumChunks()))
        end
        SIDEBAR_GRAFX:setY(mainChunkY:get())
        CHUNK_ARTIST:update(dt)
    end,

    handleKeypressed = function(self, key)
        if key == "up" then
            self:prevChunk()
        elseif key == "down" then
            self:nextChunk()
        elseif key == "space" then
            CHUNK_ARTIST:toggleMode()
        end
    end,

    handleKeyreleased = function(self, key)
        mainChunkY.speed = 4
    end,

    renderChunk = function(self, chunkNum, y)
        if y + SIDEBAR_GRAFX:getY() < 800 and y + SIDEBAR_GRAFX:getY() > -256 then        
            SIDEBAR_GRAFX:setColor(1, 1, 1)
            SIDEBAR_GRAFX:setFontSize(32)
            CHUNK_ARTIST:draw(chunkNum, 750, y, SIDEBAR_GRAFX)
            SIDEBAR_GRAFX:printf("" .. chunkNum, 700, y + 112, 50, "center")
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

    moveMainYToChunk = function(self, chunkNum)
        mainChunkY:setDestination(self:getMainYForChunk(chunkNum))
    end,

    getMainYForChunk = function(self, chunkNum)
        return -(chunkNum - 1) * 264
    end,

    onKeyRepeat = function() 
        mainChunkY.speed = 12 
    end,
}
