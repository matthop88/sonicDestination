--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local RING_INFO     = require("tools/ringMaster/ringInfo")
local RING_SCANNER  = require("tools/ringMaster/pipelines/objectScanner")

local MAP_IMG_PATH  = "resources/zones/maps/" .. __PARAMS["mapIn"] .. ".png"
local MAP_SAVER     = require("tools/ringMaster/savableMap"):create(MAP_IMG_PATH, (__PARAMS["ringDataOut"] or "sampleRingData") .. ".lua")

require("tools/ringMaster/ringSmarts"):upgradeRingList(RING_SCANNER:getObjectsFound())

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("RingMaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.update(dt)
    if RING_SCANNER:isReady()    then RING_SCANNER:execute()               end
    RING_SCANNER:getObjectsFound():update(dt, RING_SCANNER:isComplete())
end

function love.keypressed(key)
    if key == "return" then
        MAP_SAVER:save(RING_SCANNER:getObjectsFound())
    end
end

function love.mousepressed(mx, my)
    scanForRings()
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function scanForRings()
    if not RING_SCANNER:isReady() and not RING_SCANNER:isComplete() then
        RING_SCANNER:setup(RING_INFO, getMapInfo())
        RING_SCANNER:execute()
    end
end

function getMapInfo()
    local img = getImageViewer()
    return { data = img:getImageData(), width = img:getImageWidth(), height = img:getImageHeight(), startX = 0, startY = 0 }
end

function drawObjects()
    RING_SCANNER:getObjectsFound():draw(getImageViewer(), RING_INFO)
    if RING_SCANNER:getOldHotList() then
        drawHotList()
    end
end

function drawHotList()
    local img = getImageViewer()
    local hotList = RING_SCANNER:getOldHotList()
    for n, elt in ipairs(hotList) do
        local x, y = img:imageToScreenCoordinates(elt.offset, 0)
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.rectangle("fill", x, 0, elt.size * img:getScale(), WINDOW_HEIGHT)
    end
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("imageViewer",
    {
        imagePath       = MAP_IMG_PATH,
        accessorFnName  = "getImageViewer",
        pixelated       = true,
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("scrolling",    
    { 
        imageViewer = getImageViewer(),
        scrollSpeed = 2400,
    })
    :add("drawingLayer", { drawingFn   = drawObjects      })
    :add("progressBar",
    {
        message  = "Scanning for Rings...",
        callback = function() return RING_SCANNER:getProgress() end,
    })
    :add("readout",      { printFnName = "printToReadout" })
