local MAIN_CHUNK
local CHUNK_ARTIST

local chunkID    = 1
local mainChunkY = require("tools/lib/tweenableValue"):create(0, { speed = 4 })

return {
    init = function(self, chunkArtist, stickyMouse, sidebarPanel)
        CHUNK_ARTIST  = chunkArtist
        MAIN_CHUNK    = require("tools/chunkDoctor/mainPanel/mainChunk"):init(chunkArtist, mainChunkY, stickyMouse, sidebarPanel)
        
        return self
    end,

    draw = function(self)
        MAIN_CHUNK:draw()
    end,

    update = function(self, dt)
        mainChunkY:update(dt)
        
        if mainChunkY:get() == self:getMainYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
            mainChunkY:set(self:getMainYForChunk(1))
        elseif mainChunkY:get() == self:getMainYForChunk(0) then
            mainChunkY:set(self:getMainYForChunk(CHUNK_ARTIST:getNumChunks()))
        end
        
        MAIN_CHUNK:update(dt, chunkID)
    end,

    handleKeypressed = function(self, key)
        if     key == "up"     then self:prevChunk()
        elseif key == "down"   then self:nextChunk()  
        else                        MAIN_CHUNK:handleKeypressed(key) end
    end,

    handleKeyreleased = function(self, key) mainChunkY.speed = 4  end,

    handleMousepressed = function(self, mx, my)
        MAIN_CHUNK:handleMousepressed(mx, my, chunkID)
    end,

    handleMousereleased = function(self, mx, my)
        MAIN_CHUNK:handleMousereleased(mx, my)
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

    getMainYForChunk = function(self, chunkNum) return -(chunkNum - 1) * 400 end,
    onKeyRepeat      = function()               mainChunkY.speed = 12        end,

    undo             = function(self)           MAIN_CHUNK:undo()            end,
    redo             = function(self)           MAIN_CHUNK:redo()            end,
}
