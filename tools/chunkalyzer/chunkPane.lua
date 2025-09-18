--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local GRAFX = require("tools/lib/graphics"):create()

return {
	draw = function(self)
        GRAFX:setColor(0, 0, 0)
        GRAFX:rectangle("fill", 0, 0, GRAFX:calculateViewport())
        GRAFX:setColor(1, 1, 0)
        GRAFX:rectangle("fill", 200, 100, 300, 200)
    end,

    update = function(self, dt)
        -- Do nothing
    end,

    handleKeypressed = function(self, key)
        -- Do nothing
    end,

    handleMousepressed = function(self, mx, my)
        -- Do nothing
    end,

    --------------------------------------------------------------
    --              Specialized Update Functions                --
    --------------------------------------------------------------

    keepImageInBounds = function(self)
        -- not sure what to do yet
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
}
