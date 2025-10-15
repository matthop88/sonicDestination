local MAIN_GRAFX                  = require("tools/lib/graphics"):create()
local CHUNK_ARTIST

local chunkID    = 1
local mainChunkY = require("tools/lib/tweenableValue"):create(0, { speed = 4 })
local gridSize   = require("tools/lib/tweenableValue"):create(0, { speed = 6 })

local selectedTile = nil

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

        if self:isPtInsideChunk(love.mouse.getPosition()) then gridSize:setDestination(150)
        else                                                   gridSize:setDestination(0)   end
        
        if not self:drawSelectedTile() then self:drawCurrentTileHighlight() end
    end,

    update = function(self, dt)
        mainChunkY:update(dt)
        gridSize:update(dt)

        if mainChunkY:get() == self:getMainYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
            mainChunkY:set(self:getMainYForChunk(1))
        elseif mainChunkY:get() == self:getMainYForChunk(0) then
            mainChunkY:set(self:getMainYForChunk(CHUNK_ARTIST:getNumChunks()))
        end
        MAIN_GRAFX:setY(mainChunkY:get())

        if love.mouse.isDown(1) and love.keyboard.isDown("lshift", "rshift") then
            self:updateSelectedTile()
        end
    end,

    handleKeypressed = function(self, key)
        if     key == "up"   then self:prevChunk()
        elseif key == "down" then self:nextChunk()  end
    end,

    handleKeyreleased = function(self, key) mainChunkY.speed = 4  end,

    handleMousepressed = function(self, mx, my)
        self:updateSelectedTile()
    end,

    handleMousereleased = function(self, mx, my)
        selectedTile = nil
    end,

    updateSelectedTile = function(self)
        local tileX, tileY = self:getTargetedTileXY()
        if tileX == nil then
            selectedTile = nil
        else
            selectedTile = { x = tileX, y = tileY }
        end
    end,

    renderChunk = function(self, chunkNum, y)
        if y + MAIN_GRAFX:getY() < 400 and y + MAIN_GRAFX:getY() > -256 then        
            MAIN_GRAFX:setColor(1, 1, 1)
            MAIN_GRAFX:setFontSize(32)
            CHUNK_ARTIST:draw(chunkNum, 65, y, MAIN_GRAFX, gridSize:get() / 100)
            MAIN_GRAFX:printf("" .. chunkNum, 15, y + 112, 50, "center")
        end
    end,

    drawSelectedTile = function(self)
        if selectedTile ~= nil then
            MAIN_GRAFX:setColor(1, 1, 1, 0.8)
            MAIN_GRAFX:rectangle("fill", (selectedTile.x * 16) + 63, (selectedTile.y * 16) + 70 - mainChunkY:get(), 20, 20)
            return true
        end
    end,

    drawCurrentTileHighlight = function(self)
        if not mainChunkY:inFlux() then
            local tileX, tileY = self:getTargetedTileXY()
            if tileX ~= nil then
                MAIN_GRAFX:setColor(1, 1, 0)
                MAIN_GRAFX:setLineWidth(3)
                MAIN_GRAFX:rectangle("line", (tileX * 16) + 64, (tileY * 16) + 71 - mainChunkY:get(), 18, 18)
            end
        end
    end,

    getTargetedTileXY = function(self)
        local mx, my = love.mouse.getPosition()

        if self:isPtInsideChunk(mx, my) then
            local tileX = math.floor((mx - 130) / 32)
            local tileY = math.floor((my - 144) / 32)
            return tileX, tileY
        end
           
    end,

    isPtInsideChunk = function(self, px, py)
        return px >= 130 and px <= 642 and py >= 144 and py <= 656
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
}
