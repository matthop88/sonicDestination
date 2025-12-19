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

local chunkIndex = 1

local chunkIDs = { 10, 19, 17 }

local chunkMap = {}

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

for i = 1, 256 do
    local c = {}
    for j = 1, 256 do
        table.insert(c, 0)
    end
    table.insert(chunkMap, c)
end

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    GRAFX:setColor(1, 1, 1)
    for i = 1, 256 do
        local c = chunkMap[i]
        for j = 1, 256 do
            if c[j] ~= 0 then
                CHUNKS:drawAt(GRAFX, c[j], (j - 1) * 256, (i - 1) * 256)
            end
        end
    end

    if mode == MODE.CHUNK then
        local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        GRAFX:rectangle("line", x - 128, y - 128, 256, 256)
        if CHUNKS then
            GRAFX:setColor(1, 1, 1, 0.8)
            CHUNKS:drawAt(GRAFX, chunkIDs[chunkIndex], x - 128, y - 128)
        end
    end
end

function love.keypressed(key)
    if     key == "tab" and mode == MODE.CHUNK then
        chunkIndex = chunkIndex + 1
        if chunkIndex > #chunkIDs then chunkIndex = 1 end
    elseif key == "shifttab" and mode == MODE.CHUNK then
        chunkIndex = chunkIndex - 1
        if chunkIndex < 1 then chunkIndex = #chunkIDs end
    elseif key == "space" and mode == MODE.CHUNK then
        print(chunkIndex)
    elseif key == "c" then
        if mode == MODE.CHUNK then mode = MODE.EDIT
        else                       mode = MODE.CHUNK end
    elseif key == "escape" then
        mode = MODE.EDIT
    end
end

function love.mousepressed(mx, my)
    if mode == MODE.CHUNK then
        local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        local j, i = math.floor(x / 256) + 1, math.floor(y / 256) + 1
        chunkMap[i][j] = chunkIDs[chunkIndex]
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
                CHUNKS = require("tools/constructionSet/terrain/chunksBuilder"):create(CHUNKS_INFO.image) 
            end,
        },
    }) 
    
