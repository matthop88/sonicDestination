--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local RING_IMG  = love.graphics.newImage("tools/ringMaster/resources/commonObj.png")
local RING_QUAD = love.graphics.newQuad(24, 198, 16, 16, RING_IMG:getWidth(), RING_IMG:getHeight())

local map = ({
    rings = {},
    isZooming = false,

    init = function(self)
        self.pageWidth  = 1200
        self.pageHeight =  800

        self.GRAFX = require("tools/lib/bufferedGraphics")
                        :create(require("tools/lib/graphics"):create(), self.pageWidth, self.pageHeight)

        self:initRings()
        return self
    end,

    initRings = function(self)
        for i = 1, 150 do
            local ringX = math.random(1, (self:getPageWidth() / 16)  - 3) * 16
            local ringY = math.random(1, (self:getPageHeight() / 16) - 3) * 16

            table.insert(self.rings, { x = ringX, y = ringY})
        end
    end,

    draw = function(self)
        self.GRAFX:setColor(0, 0, 0)
        self.GRAFX:rectangle("fill", self.GRAFX:calculateViewport())
        self.GRAFX:setColor(0.3, 0.3, 0.3)
        self.GRAFX:rectangle("fill", 10, 10, self:getPageWidth() - 20, self:getPageHeight() - 20)
        self.GRAFX:setColor(1, 1, 1)
        for _, ring in ipairs(self.rings) do
            self.GRAFX:draw(RING_IMG, RING_QUAD, ring.x, ring.y, 0, 1, 1)
        end
        self.GRAFX:blitToScreen(0, 0)
    end,

    getPageWidth  = function(self) return self.pageWidth  end,
    getPageHeight = function(self) return self.pageHeight end,
    
    keepImageInBounds = function(self)
        if not self.isZooming then
            self.GRAFX:setX(math.min(0, math.max(self.GRAFX:getX(), (love.graphics:getWidth()  / self.GRAFX:getScale()) - self:getPageWidth())))
            self.GRAFX:setY(math.min(0, math.max(self.GRAFX:getY(), (love.graphics:getHeight() / self.GRAFX:getScale()) - self:getPageHeight())))
        end
        self.isZooming = false
    end,

    moveImage = function(self, deltaX, deltaY)
        self.GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.GRAFX:adjustScaleGeometrically(deltaScale)
        if deltaScale > 0 then self.isZooming = true end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
       self.GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
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


