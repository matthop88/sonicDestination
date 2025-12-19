--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX = require("tools/lib/graphics"):create()

GRAFX.moveImageOld = GRAFX.moveImage
GRAFX.moveImage = function(self, deltaX, deltaY)
    self:moveImageOld(deltaX / self:getScale(), deltaY / self:getScale())
end

local CHUNKS_PATH = "game/resources/zones/chunks/ghzChunks.lua"
local CHUNKS_INFO
local CHUNKS

local CHUNK_MAP

local MODE = {
    CHUNK  = "chunk",
    OBJECT = "object",
    EDIT   = "edit",
    BADNIK = "badnik",
    SONIC  = "sonic",
}

local mode = MODE.EDIT
    
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if CHUNK_MAP then 
        CHUNK_MAP:draw(GRAFX)
        if mode == MODE.CHUNK then 
            CHUNK_MAP:drawMouseChunk(GRAFX) 
        end
    end
end

function love.keypressed(key)
    if     key == "tab" and mode == MODE.CHUNK then
        CHUNK_MAP:incrementChunk()
    elseif key == "shifttab" and mode == MODE.CHUNK then
        CHUNK_MAP:decrementChunk()
    elseif key == "space" and mode == MODE.CHUNK then
        CHUNK_MAP:printChunkIndex()
    elseif key == "c" then
        if mode == MODE.CHUNK then mode = MODE.EDIT
        else                       mode = MODE.CHUNK end
    elseif key == "escape" then
        mode = MODE.EDIT
    end
end

function love.mousepressed(mx, my)
    if mode == MODE.CHUNK and CHUNK_MAP then
        CHUNK_MAP:placeChunk(GRAFX, mx, my)
    end
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("keyRepeat", {
        interval    = 0.05,
        delay       = 0.5,
    })
    :add("scrolling",      { imageViewer = GRAFX })
    :add("zooming",        { imageViewer = GRAFX })    
    :add("grid2d",         { 
        graphics    = GRAFX,
        bounds      = { x = 0, y = 0, w = 256, h = 256 },
    })
    :add("timedFunctions",
    {
        {   secondsWait = 0.25, 
            callback = function() 
                CHUNKS_INFO = require("tools/constructionSet/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                CHUNKS      = require("tools/constructionSet/terrain/chunksBuilder"):create(CHUNKS_INFO.image) 
                CHUNK_MAP   = require("tools/constructionSet/map"):create { w = 256, h = 256, chunks = CHUNKS, chunkIDs = { 10, 19, 17 } }
            end,
        },
    }) 
    
