
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

local GRAPHICS   = require("tools/lib/graphics"):create()

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    GRAPHICS:setColor(1, 1, 1)
    GRAPHICS:rectangle("fill", 100, 100, 200, 150)
end

function love.mousepressed(mx, my)
    -- Do something
end

function love.keypressed(key)
    -- Scrolling
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

local LAYERS = {
    ---------------------- Graphics Object Methods ------------------------

    moveImage = function(self, deltaX, deltaY)
        GRAPHICS:moveImage(deltaX / GRAPHICS:getScale(), deltaY / GRAPHICS:getScale())
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return GRAPHICS:screenToImageCoordinates(screenX, screenY)
    end,

    imageToScreenCoordinates = function(self, imageX, imageY)
        return GRAPHICS:imageToScreenCoordinates(imageX, imageY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAPHICS:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAPHICS:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,
}

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("zooming",      { imageViewer    = LAYERS })
    :add("scrolling",    { imageViewer    = LAYERS })
    :add("questionBox",
    {   x     = 750,
        w     = 600,
        destX = 100,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            "Use arrow keys to scroll with parallax",
        },
    })
