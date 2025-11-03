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
    if RING_SCANNER:isReady() then
        RING_SCANNER:execute()
    end
    if RING_SCANNER:isComplete() then
        printToReadout("Scanning Complete.")
    end
end

function love.mousepressed(mx, my)
    scanForRings()
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function scanForRings()
    RING_SCANNER:setup(RING_INFO, getMapInfo())
    printToReadout("Scanning for rings...")
    RING_SCANNER:execute()
end

function getMapInfo()
    local img = getImageViewer()
    return { data = img:getImageData(), width = img:getImageWidth(), height = img:getImageHeight(), startX = 0, startY = 0 }
end

function drawObjects()
    local IMAGE_VIEWER = getImageViewer()
    love.graphics.setColor(1, 1, 0, 0.7)
    love.graphics.setLineWidth(1 * IMAGE_VIEWER:getScale())

    for _, obj in ipairs(RING_SCANNER:getObjectsFound()) do
        love.graphics.rectangle("line", IMAGE_VIEWER:pageToScreenRect(obj.x, obj.y, 16, 16))
    end

    local vScanX = RING_SCANNER:getVScanX()
    if vScanX ~= nil then
        love.graphics.setColor(1, 0, 0, 0.7)
        love.graphics.setLineWidth(9 * IMAGE_VIEWER:getScale())
        local x, _ = IMAGE_VIEWER:imageToScreenCoordinates(vScanX, 0)
        love.graphics.line(x, 0, x, WINDOW_HEIGHT)
        love.graphics.setLineWidth(3 * IMAGE_VIEWER:getScale())
        love.graphics.setColor(1, 1, 0)
        love.graphics.line(x, 0, x, WINDOW_HEIGHT)
    end
end

-- ...

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
    :add("readout",      { printFnName = "printToReadout" })
    
