--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local RING_INFO    = require("tools/ringMaster/ringInfo")
local RING_SCANNER = require("tools/ringMaster/objectScanner")

local MAP_IMG_PATH = "resources/zones/maps/GHZ_Act1_Map.png"

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
    if RING_SCANNER:isComplete() then printToReadout("Scanning Complete.") end
    
    updateObjects(dt)
end

function love.mousepressed(mx, my)
    scanForRings()
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function scanForRings()
    if not scanComplete then
        RING_SCANNER:setup(RING_INFO, getMapInfo())
        RING_SCANNER:execute()
        scanComplete = true
    end
end

function getMapInfo()
    local img = getImageViewer()
    return { data = img:getImageData(), width = img:getImageWidth(), height = img:getImageHeight(), startX = 0, startY = 0 }
end

function drawObjects()
    for _, ring in ipairs(RING_SCANNER:getObjectsFound()) do
        drawRingHighlight(ring)
    end
end

function drawRingHighlight(ring)
    local IMAGE_VIEWER = getImageViewer()
    
    if ring.alpha ~= nil then
        local x, y = IMAGE_VIEWER:imageToScreenCoordinates(ring.x, ring.y)
        RING_INFO:draw(x, y, IMAGE_VIEWER:getScale(), { 1, 0, 0, ring.alpha })
        love.graphics.setColor(1, 1, 0, (1 - ring.alpha) * 0.7)
        love.graphics.setLineWidth(1 * IMAGE_VIEWER:getScale())
        love.graphics.rectangle("line", IMAGE_VIEWER:pageToScreenRect(ring.x, ring.y, 16, 16))
    end
end

function updateObjects(dt)
    for _, ring in ipairs(RING_SCANNER:getObjectsFound()) do
        if   ring.alpha == nil then ring.alpha = 1
        else                        ring.alpha = ring.alpha - (3 * dt) end
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
