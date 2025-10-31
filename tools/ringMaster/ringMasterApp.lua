--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX     = require("tools/lib/graphics"):create()
local RING_IMG  = love.graphics.newImage("tools/ringMaster/resources/commonObj.png")
local RING_QUAD = love.graphics.newQuad(24, 198, 16, 16, RING_IMG:getWidth(), RING_IMG:getHeight())

local map = ({
    isZooming  = false,
    ringsDrawn = false,

    init = function(self)
        self.pageWidth  = 1200
        self.pageHeight =  800

        self.BUF_GRAFX = require("tools/lib/bufferedGraphics"):create(GRAFX, self.pageWidth, self.pageHeight)

        return self
    end,

    draw = function(self)
        if not self.ringsDrawn then self:drawRingsToBuffer() end
            
        GRAFX:setColor(1, 1, 1)
        GRAFX:drawImage(self.BUF_GRAFX:getBuffer(), 0, 0)
    end,

    drawRingsToBuffer = function(self)
        self:drawBackground()
        self:drawRings()
    end,

    drawBackground = function(self)
        self.BUF_GRAFX:setColor(0, 0, 0)
        self.BUF_GRAFX:rectangle("fill", self.BUF_GRAFX:calculateViewport())
        self.BUF_GRAFX:setColor(0.3, 0.3, 0.3)
        self.BUF_GRAFX:rectangle("fill", 10, 10, self:getPageWidth() - 20, self:getPageHeight() - 20)
    end,

    drawRings = function(self)
        self.BUF_GRAFX:setColor(1, 1, 1)
        for i = 1, 150 do
            local ringX = math.random(1, (self:getPageWidth() / 16)  - 3) * 16
            local ringY = math.random(1, (self:getPageHeight() / 16) - 3) * 16
            self.BUF_GRAFX:draw(RING_IMG, RING_QUAD, ringX, ringY, 0, 1, 1)
        end
        self.ringsDrawn = true
    end,

    getPageWidth  = function(self) return self.pageWidth  end,
    getPageHeight = function(self) return self.pageHeight end,
    
    keepImageInBounds = function(self)
        if not self.isZooming then
            self.BUF_GRAFX:setX(math.min(0, math.max(self.BUF_GRAFX:getX(), (love.graphics:getWidth()  / self.BUF_GRAFX:getScale()) - self:getPageWidth())))
            self.BUF_GRAFX:setY(math.min(0, math.max(self.BUF_GRAFX:getY(), (love.graphics:getHeight() / self.BUF_GRAFX:getScale()) - self:getPageHeight())))
        end
        self.isZooming = false
    end,

    moveImage = function(self, deltaX, deltaY)
        self.BUF_GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.BUF_GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.BUF_GRAFX:adjustScaleGeometrically(deltaScale)
        if deltaScale > 0 then self.isZooming = true end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
       self.BUF_GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

}):init()

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("RingMaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

RING_IMG:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    map:draw()
end

-- ...
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


