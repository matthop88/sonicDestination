local SIDEBAR_GRAFX    = require("tools/lib/graphics"):create()

local CHUNK_ARTIST

local chunkID        = 2
local mainChunkY     =  require("tools/lib/tweenableValue"):create(0, { speed = 4 })
local gridSize       = require("tools/lib/tweenableValue"):create(0, { speed = 8 })
local chunkSelected  = nil
local chunkCandidate = nil

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

        self:highlightCandidateChunk()
        self:decorateSelectedChunk()
    end,

    highlightCandidateChunk = function(self)
        if chunkCandidate ~= nil then
            SIDEBAR_GRAFX:setColor(1, 1, 0)
            SIDEBAR_GRAFX:setLineWidth(3)
            SIDEBAR_GRAFX:rectangle("line", 759, ((chunkCandidate - 1) * 264) + 271, 258, 258)
        end
    end,

    decorateSelectedChunk = function(self)
        if chunkSelected ~= nil then
            SIDEBAR_GRAFX:setColor(1, 1, 1, 0.5)
            SIDEBAR_GRAFX:rectangle("fill", 756, ((chunkSelected - 1) * 264) + 268, 264, 264)
            SIDEBAR_GRAFX:setColor(1, 1, 1)
            SIDEBAR_GRAFX:setLineWidth(3)
            SIDEBAR_GRAFX:rectangle("line", 759, ((chunkSelected - 1) * 264) + 271, 258, 258)

        end
    end,

    isPtInsideChunk = function(self, px, py)
        return px >= 130 and px <= 642 and py >= 144 and py <= 656
    end,

    update = function(self, dt)
        mainChunkY:update(dt)
        gridSize:update(dt)
        if     mainChunkY:get() == self:getMainYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
            mainChunkY:set(self:getMainYForChunk(1))
        elseif mainChunkY:get() == self:getMainYForChunk(0) then
            mainChunkY:set(self:getMainYForChunk(CHUNK_ARTIST:getNumChunks()))
        end
        SIDEBAR_GRAFX:setY(mainChunkY:get())

        chunkCandidate = self:getChunkCandidate(love.mouse.getPosition())
        if chunkSelected == nil then gridSize:setDestination(0)
        else                         gridSize:setDestination(100) end

    end,

    handleMousepressed = function(self, mx, my)
        chunkSelected = chunkCandidate
    end,

    getChunkCandidate = function(self, mX, mY)
        local chunk = self:calculateChunkCandidate(mX, mY)
        if     chunk == nil                        then return nil
        elseif chunk < 1                           then return chunk + CHUNK_ARTIST:getNumChunks()
        elseif chunk > CHUNK_ARTIST:getNumChunks() then return chunk - CHUNK_ARTIST:getNumChunks() 
        else                                            return chunk                               end
    end,

    calculateChunkCandidate = function(self, mX, mY)
        if mX >= 760 and mX <= 1016 then
            if     mY >= 272 and mY <= 528 then return chunkID
            elseif mY >= 8   and mY <= 264 then return chunkID - 1
            elseif mY >= 536 and mY <= 792 then return chunkID + 1 end
        end
    end,

    handleKeypressed = function(self, key)
        if key == "up" then
            self:prevChunk()
        elseif key == "down" then
            self:nextChunk()
        end
    end,

    handleKeyreleased = function(self, key)
        mainChunkY.speed = 4
    end,

    renderChunk = function(self, chunkNum, y)
        if y + SIDEBAR_GRAFX:getY() < 800 and y + SIDEBAR_GRAFX:getY() > -256 then        
            SIDEBAR_GRAFX:setColor(1, 1, 1)
            SIDEBAR_GRAFX:setFontSize(32)
            if chunkNum == chunkSelected then CHUNK_ARTIST:draw(chunkNum, 760, y, SIDEBAR_GRAFX, gridSize:get() / 100)
            else                              CHUNK_ARTIST:draw(chunkNum, 760, y, SIDEBAR_GRAFX, 0)                 end
            SIDEBAR_GRAFX:printf("" .. chunkNum, 710, y + 112, 50, "center")
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
