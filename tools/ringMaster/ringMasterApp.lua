--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX      = require("tools/lib/graphics"):create()
local RING_FORGE = require("tools/ringMaster/ringForge")

local map = ({
    isZooming = false,
    ring      = nil,

    init = function(self)
        self.pageWidth  = 1200
        self.pageHeight =  800

        self.MAP_GRAFX  = require("tools/lib/bufferedGraphics"):create(GRAFX, self.pageWidth, self.pageHeight)
        self.imageData = self.MAP_GRAFX:getBuffer():newImageData()
        return self
    end,

    draw = function(self)
        if not self.ring then 
            self.ring = RING_FORGE:create()
            self:drawRingsToBuffer() 
        end
            
        GRAFX:setColor(1, 1, 1)
        GRAFX:drawImage(self.MAP_GRAFX:getBuffer(), 0, 0)
    end,

    drawRingsToBuffer = function(self)
        self:drawBackground()
        self:drawRings()
    end,

    drawBackground = function(self)
        self.MAP_GRAFX:setColor(0, 0, 0)
        self.MAP_GRAFX:rectangle("fill", self.MAP_GRAFX:calculateViewport())
        self.MAP_GRAFX:setColor(0.3, 0.3, 0.3)
        self.MAP_GRAFX:rectangle("fill", 10, 10, self:getPageWidth() - 20, self:getPageHeight() - 20)
    end,

    drawRings = function(self)
        self.MAP_GRAFX:setColor(1, 1, 1)
        for i = 1, 150 do
            local ringX = math.random(1, (self:getPageWidth()  / 16) - 3) * 16
            local ringY = math.random(1, (self:getPageHeight() / 16) - 3) * 16
            self.MAP_GRAFX:drawImage(self.ring:getImage(), ringX, ringY)
        end
    end,

    getPageWidth  = function(self) return self.pageWidth  end,
    getPageHeight = function(self) return self.pageHeight end,
    
    keepImageInBounds = function(self)
        if not self.isZooming then
            self.MAP_GRAFX:setX(math.min(0, math.max(self.MAP_GRAFX:getX(), (love.graphics:getWidth()  / self.MAP_GRAFX:getScale()) - self:getPageWidth())))
            self.MAP_GRAFX:setY(math.min(0, math.max(self.MAP_GRAFX:getY(), (love.graphics:getHeight() / self.MAP_GRAFX:getScale()) - self:getPageHeight())))
        end
        self.isZooming = false
    end,

    moveImage = function(self, deltaX, deltaY)
        self.MAP_GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.MAP_GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.MAP_GRAFX:adjustScaleGeometrically(deltaScale)
        if deltaScale > 0 then self.isZooming = true end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
       self.MAP_GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

}):init()

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("RingMaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    map:draw()
    love.graphics.setColor(1, 1, 1)
end

function love.mousepressed(mx, my)
    print("Scanning for rings...")
end

-- ...

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
    :add("zooming",      { imageViewer = map, })
    :add("scrolling",    { imageViewer = map, })


