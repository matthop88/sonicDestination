--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local MAIN_GRAFX                  = require("tools/lib/graphics"):create()
local SIDEBAR_GRAFX               = require("tools/lib/graphics"):create()

local CHUNKS_DATA_PATH = "resources/zones/chunks/" .. __PARAMS["chunkDataIn"] .. ".lua"
local CHUNK_ARTIST     = require("tools/chunkDoctor/chunkArtist"):create(CHUNKS_DATA_PATH)

local chunkID    = 1
local mainChunkY =  require("tools/lib/tweenableValue"):create(0, { speed = 4 })

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunk Doctor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

MAIN_GRAFX:setScale(2)



--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    for i = 1, CHUNK_ARTIST:getNumChunks() do
        CHUNK_ARTIST:draw(i, 100, ((i - 1) * 400) + 72, MAIN_GRAFX)
    end
    CHUNK_ARTIST:draw(1, 100, (CHUNK_ARTIST:getNumChunks() * 400) + 72, MAIN_GRAFX)
    CHUNK_ARTIST:draw(CHUNK_ARTIST:getNumChunks(), 100, -328, MAIN_GRAFX)
end

function love.update(dt)
    mainChunkY:update(dt)
    if     mainChunkY:get() == getMainYForChunk(CHUNK_ARTIST:getNumChunks() + 1) then
        mainChunkY:set(getMainYForChunk(1))
    elseif mainChunkY:get() == getMainYForChunk(0) then
        mainChunkY:set(getMainYForChunk(CHUNK_ARTIST:getNumChunks()))
    end
    MAIN_GRAFX:setY(mainChunkY:get())
end

function love.keypressed(key)
    if key == "up" then
        prevChunk()
    elseif key == "down" then
        nextChunk()
    end
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function prevChunk()
    chunkID = chunkID - 1
    if chunkID < 1 then 
        chunkID = CHUNK_ARTIST:getNumChunks() 
        moveMainYToChunk(0)
    else
        moveMainYToChunk(chunkID)
    end
end

function nextChunk()
    chunkID = chunkID + 1
    if chunkID > CHUNK_ARTIST:getNumChunks() then
        chunkID = 1
        moveMainYToChunk(CHUNK_ARTIST:getNumChunks() + 1)
    else
        moveMainYToChunk(chunkID)
    end
end

function moveMainYToChunk(chunkNum)
    mainChunkY:setDestination(getMainYForChunk(chunkNum))
end

function getMainYForChunk(chunkNum)
    return -(chunkNum - 1) * 400
end

-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    -- :add( ... )
