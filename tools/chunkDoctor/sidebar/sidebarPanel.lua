local SIDEBAR_GRAFX    = require("tools/lib/graphics"):create()

local CHUNK_ARTIST

local chunkID        = 2
local sidebarY       = require("tools/lib/tweenableValue"):create(0, { speed = 4 })
local gridSize       = require("tools/lib/tweenableValue"):create(0, { speed = 8 })

local CHUNKS         = {}
local SIDEBAR_CHUNK
local STICKY_MOUSE

local SOLIDS_MODE = false

SIDEBAR_GRAFX:setScale(1)

return {
    init = function(self, chunkArtist, stickyMouse)
        CHUNK_ARTIST = chunkArtist
        STICKY_MOUSE = stickyMouse
        
        sidebarY:set(self:getSidebarYForChunk(2))

        SIDEBAR_CHUNK = require("tools/chunkDoctor/sidebar/sidebarChunk"):init(CHUNK_ARTIST, SIDEBAR_GRAFX, gridSize, STICKY_MOUSE)

        for i = 1, CHUNK_ARTIST:getNumChunks() do
            table.insert(CHUNKS, SIDEBAR_CHUNK:create(i))
        end

        CHUNKS[1].alternateY = (#CHUNKS * 264) + 272
        CHUNKS[2].alternateY = (#CHUNKS * 264) + 536
        CHUNKS[#CHUNKS    ].alternateY =  8
        CHUNKS[#CHUNKS - 1].alternateY = -256

        return self
    end,

    draw = function(self)
        for _, chunk in ipairs(CHUNKS) do chunk:draw()            end
        for _, chunk in ipairs(CHUNKS) do chunk:drawHighlitTile() end

        if not SOLIDS_MODE then STICKY_MOUSE:draw() end
    end,

    update = function(self, dt)
        sidebarY:update(dt)
        gridSize:update(dt)
        self:updateSidebar(dt)
        
        for _, chunk in ipairs(CHUNKS) do chunk:update(dt) end

        self:updateChunkCandidate(love.mouse.getPosition())
        if self:getChunkSelected() then gridSize:setDestination(100)
        else                            gridSize:setDestination(0)   end

        local anyTileHighlighted = self:isAnyTileHighlighted()
        if not SOLIDS_MODE then STICKY_MOUSE:setVisible(not anyTileHighlighted) end
        if self:isHighlightedTileSelected() then
            STICKY_MOUSE:setTransparency(0.9)
        elseif anyTileHighlighted then
            STICKY_MOUSE:setTransparency(0.2)
        elseif STICKY_MOUSE:getTransparency() ~= 0.4 then
            STICKY_MOUSE:setTransparency(0.9)
        end

    end,

    updateSidebar = function(self, dt)
        if     sidebarY:get() == self:getSidebarYForChunk(#CHUNKS + 1) then
            sidebarY:set(self:getSidebarYForChunk(1))
        elseif sidebarY:get() == self:getSidebarYForChunk(0) then
            sidebarY:set(self:getSidebarYForChunk(#CHUNKS))
        end
        SIDEBAR_GRAFX:setY(sidebarY:get())
    end,

    getSidebarYForChunk = function(self, chunkNum)
        return -(chunkNum - 1) * 264
    end,

    updateChunkCandidate = function(self, mX, mY)
        local chunkID = self:getChunkCandidate(mX, mY)
        self:unhighlightAllChunks()
        
        if chunkID ~= nil then CHUNKS[chunkID].highlighted = true end
    end,

    getChunkCandidate = function(self, mX, mY)
        local chunk = self:calculateChunkCandidate(mX, mY)
        if     chunk == nil    then return nil
        elseif chunk < 1       then return chunk + #CHUNKS
        elseif chunk > #CHUNKS then return chunk - #CHUNKS
        else                   return chunk            end
    end,

    calculateChunkCandidate = function(self, mX, mY)
        if mX >= 760 and mX <= 1016 then
            if     mY >= 272 and mY <= 528 then return chunkID
            elseif mY >= 8   and mY <= 264 then return chunkID - 1
            elseif mY >= 536 and mY <= 792 then return chunkID + 1 end
        end
    end,

    getChunkSelected = function(self)
        for _, chunk in ipairs(CHUNKS) do
            if chunk.selected then return chunk end
        end
    end,

    isAnyTileHighlighted = function(self)
        for _, chunk in ipairs(CHUNKS) do
            if chunk.selected and chunk.highlighted then return true end
        end
    end,

    isHighlightedTileSelected = function(self)
        for _, chunk in ipairs(CHUNKS) do
            if chunk:isHighlightedTileSelected() then return true end
        end
        return false
    end,

    handleKeypressed = function(self, key)
        if     key == "up"         then self:prevChunk()
        elseif key == "down"       then self:nextChunk()
        elseif key == "escape"     then self:unselectAllChunks() 
        end
    end,

    walkSelectedTile = function(self, deltaX, deltaY)
        local chunkSelected = self:getChunkSelected()
        if chunkSelected then
            chunkSelected:walkSelectedTile(deltaX, deltaY)
        end
    end,

    prevChunk = function(self)
        if not sidebarY:inFlux() then
            chunkID = chunkID - 1
            if chunkID < 1 then 
                chunkID = #CHUNKS
                self:moveSidebarYToChunk(0)
            else
                self:moveSidebarYToChunk(chunkID)
            end
        end
    end,

    moveSidebarYToChunk = function(self, chunkNum)
        sidebarY:setDestination(self:getSidebarYForChunk(chunkNum))
    end,

    nextChunk = function(self)
        if not sidebarY:inFlux() then
            chunkID = chunkID + 1
            if chunkID > #CHUNKS then
                chunkID = 1
                self:moveSidebarYToChunk(#CHUNKS + 1)
            else
                self:moveSidebarYToChunk(chunkID)
            end
        end
    end,

    unselectAllChunks = function(self)
        for _, chunk in ipairs(CHUNKS) do chunk:select(false) end
    end,

    unhighlightAllChunks = function(self)
        for _, chunk in ipairs(CHUNKS) do chunk.highlighted = false end
    end,

    handleMousepressed = function(self, mx, my)
        self:unselectAllChunks()
        for _, chunk in ipairs(CHUNKS) do 
            if chunk.highlighted then chunk:handleMousepressed(mx, my) end
        end
    end,

    handleKeyreleased  = function(self, key) sidebarY.speed = 4   end,
    onKeyRepeat        = function()          sidebarY.speed = 12  end,

    toggleSolidsMode   = function(self) 
        SOLIDS_MODE = not SOLIDS_MODE   
        if SOLIDS_MODE == true then self:unselectAllChunks() end  
        for _, chunk in ipairs(CHUNKS) do chunk:toggleSolidsMode() end
    end,

}
