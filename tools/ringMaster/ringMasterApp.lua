--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX     = require("tools/lib/graphics"):create()
local RING_IMG  = love.graphics.newImage("tools/ringMaster/resources/commonObj.png")
local RING_QUAD = love.graphics.newQuad(24, 198, 16, 16, RING_IMG:getWidth(), RING_IMG:getHeight())

local map = ({
    init = function(self)
        self.pageWidth  = 10240
        self.pageHeight =  1280

        return self
    end,

    draw = function(self)
        GRAFX:setColor(0.3, 0.3, 0.3)
        GRAFX:rectangle("fill", 10, 10, self:getPageWidth() - 20, self:getPageHeight() - 20)
        GRAFX:setColor(1, 1, 1)
        GRAFX:draw(RING_IMG, RING_QUAD, 300, 200, 0, 1, 1)
    end,

    getPageWidth  = function(self) return self.pageWidth  end,
    getPageHeight = function(self) return self.pageHeight end,
    
    keepImageInBounds = function(self)
        GRAFX:setX(math.min(0, math.max(GRAFX:getX(), (love.graphics:getWidth()  / GRAFX:getScale()) - self:getPageWidth())))
        GRAFX:setY(math.min(0, math.max(GRAFX:getY(), (love.graphics:getHeight() / GRAFX:getScale()) - self:getPageHeight())))
    end,

    moveImage = function(self, deltaX, deltaY)
        GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAFX:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
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


