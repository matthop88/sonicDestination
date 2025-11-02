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
        RING_SCANNER:scanAll()
    end
end

-- ...
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
    :add("readout",      { printFnName = "printToReadout", })
    
