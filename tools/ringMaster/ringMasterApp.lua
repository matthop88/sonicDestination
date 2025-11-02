--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX        = require("tools/lib/graphics"):create()
 
local RING
local RING_SCANNER

local MAP_IMG_PATH = "resources/zones/maps/GHZ_Act1_Map.png"

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("RingMaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if not RING then 
        RING = require("tools/ringMaster/ringForge"):create()
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
    if not RING_SCANNER then
        RING_SCANNER = require("tools/ringMaster/objectScanner"):create(RING:getImageData(), getImageViewer():getImageData())
        printToReadout("Scanning for rings...")
        local startTime = love.timer.getTime()
        RING_SCANNER:scanAll()
        local timeElapsed = love.timer.getTime() - startTime
        print("Completed scan in " .. timeElapsed .. " seconds.")
    end
end

function drawObjects()
    if RING_SCANNER then
        local IMAGE_VIEWER = getImageViewer()
        love.graphics.setColor(1, 1, 0, 0.7)
        love.graphics.setLineWidth(1 * IMAGE_VIEWER:getScale())

        for _, obj in ipairs(RING_SCANNER:getObjectsFound()) do
            love.graphics.rectangle("line", IMAGE_VIEWER:pageToScreenRect(obj.x, obj.y, 16, 16))
        end
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
    :add("scrolling",    { imageViewer = getImageViewer() })
    :add("drawingLayer", { drawingFn   = drawObjects      })
    :add("readout",      { printFnName = "printToReadout" })
    
