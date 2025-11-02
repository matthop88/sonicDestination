--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX        = require("tools/lib/graphics"):create()
 
local RING, MAP
local RING_SCANNER

local mapView = {
    isZooming  = false,
    ring       = nil,
    pageWidth  = 1200,
    pageHeight = 800,

    draw = function(self)
        if not RING then 
            RING         = require("tools/ringMaster/ringForge"):create()
            MAP          = require("tools/ringMaster/mapWright"):create(RING, self.pageWidth, self.pageHeight)
            RING_SCANNER = require("tools/ringMaster/objectScanner"):create(RING:getImageData(), MAP:getImageData(), MAP:getDebugRingX(), MAP:getDebugRingY())
        end
            
        GRAFX:setColor(1, 1, 1)
        GRAFX:drawImage(MAP:getImage(), 0, 0)
    end,

    getPageWidth  = function(self) return self.pageWidth  end,
    getPageHeight = function(self) return self.pageHeight end,
    
    keepImageInBounds = function(self)
        if not self.isZooming then
            GRAFX:setX(math.min(0, math.max(GRAFX:getX(), (love.graphics:getWidth()  / GRAFX:getScale()) - self:getPageWidth())))
            GRAFX:setY(math.min(0, math.max(GRAFX:getY(), (love.graphics:getHeight() / GRAFX:getScale()) - self:getPageHeight())))
        end
        self.isZooming = false
    end,

    moveImage = function(self, deltaX, deltaY)
        GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAFX:adjustScaleGeometrically(deltaScale)
        if deltaScale > 0 then self.isZooming = true end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
       GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("RingMaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    mapView:draw()
end

function love.mousepressed(mx, my)
    scanForRings()
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function scanForRings()
    printToReadout("Scanning for rings...")
    RING_SCANNER:scanAll()
end

-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = mapView,          })
    :add("scrolling",    { imageViewer = mapView,          })
    :add("readout",      { printFnName = "printToReadout", })
    
