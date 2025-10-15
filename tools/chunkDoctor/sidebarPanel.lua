local SIDEBAR_GRAFX    = require("tools/lib/graphics"):create()

local CHUNK_ARTIST

local chunkID        = 2
local sidebarY       =  require("tools/lib/tweenableValue"):create(0, { speed = 4 })
local gridSize       = require("tools/lib/tweenableValue"):create(0, { speed = 8 })
local chunkSelected  = nil
local chunkCandidate = nil
local tileCandidate  = nil

SIDEBAR_GRAFX:setScale(1)

return {
    init = function(self, chunkArtist)
        CHUNK_ARTIST = chunkArtist
        sidebarY:set(self:getSidebarYForChunk(2))
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
        self:highlightCandidateTile()
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

    highlightCandidateTile = function(self)
        if tileCandidate ~= nil and chunkSelected ~= nil then
            local y = self:getYForChunk(chunkSelected)
            
            SIDEBAR_GRAFX:setColor(1, 1, 0)
            SIDEBAR_GRAFX:setLineWidth(3)
            SIDEBAR_GRAFX:rectangle("line", (tileCandidate.x * 16) + 759, (tileCandidate.y * 16) + y - 1, 18, 18)
        end
    end,

    update = function(self, dt)
        sidebarY:update(dt)
        gridSize:update(dt)
        if     sidebarY:get() == self:getSidebarYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
            sidebarY:set(self:geSidebarYForChunk(1))
        elseif sidebarY:get() == self:getSidebarYForChunk(0) then
            sidebarY:set(self:getSidebarYForChunk(CHUNK_ARTIST:getNumChunks()))
        end
        SIDEBAR_GRAFX:setY(sidebarY:get())

        chunkCandidate = self:getChunkCandidate(love.mouse.getPosition())
        tileCandidate  = self:getTileCandidate(love.mouse.getPosition())
        if chunkSelected == nil then 
            gridSize:setDestination(0)
        else                         
            gridSize:setDestination(100)
            if not self:isChunkOnscreen(chunkSelected) then
                chunkSelected = nil
            end
        end

    end,

    getTileCandidate = function(self, mx, my)
        if chunkSelected ~= nil then
            local y      = self:getYForChunk(chunkSelected)
            local sY     = y + sidebarY:get()
            local mx, my = love.mouse.getPosition()
            if mx >= 760 and mx <= 1012 and my >= sY and my <= sY + 256 then
                local tileX = math.floor((mx - 760) / 16)
                local tileY = math.floor((my - sY)  / 16)
                return { x = tileX, y = tileY }
            end
        end
    end,

    isChunkOnscreen = function(self, chunkNum)
        local y = ((chunkNum - 1) * 264) + 272

        return y + SIDEBAR_GRAFX:getY() < 800 and y + SIDEBAR_GRAFX:getY() > -256
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
        if     key == "up"     then self:prevChunk()
        elseif key == "down"   then self:nextChunk()
        elseif key == "escape" then chunkSelected = nil end
    end,

    handleKeyreleased = function(self, key)
        sidebarY.speed = 4
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
        if not sidebarY:inFlux() then
            chunkID = chunkID - 1
            if chunkID < 1 then 
                chunkID = CHUNK_ARTIST:getNumChunks() 
                self:moveSidebarYToChunk(0)
            else
                self:moveSidebarYToChunk(chunkID)
            end
        end
    end,

    nextChunk = function(self)
        if not sidebarY:inFlux() then
            chunkID = chunkID + 1
            if chunkID > CHUNK_ARTIST:getNumChunks() then
                chunkID = 1
                self:moveSidebarYToChunk(CHUNK_ARTIST:getNumChunks() + 1)
            else
                self:moveSidebarYToChunk(chunkID)
            end
        end
    end,

    moveSidebarYToChunk = function(self, chunkNum)
        sidebarY:setDestination(self:getSidebarYForChunk(chunkNum))
    end,

    getSidebarYForChunk = function(self, chunkNum)
        return -(chunkNum - 1) * 264
    end,

    getYForChunk = function(self, chunkNum)
        return ((chunkNum - 1) * 264) + 272
    end,

    onKeyRepeat = function() 
        sidebarY.speed = 12 
    end,
}
