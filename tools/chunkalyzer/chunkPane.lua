--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), 1200, 800)

local prevGraphics = { x = GRAFX.x, y = GRAFX.y }

return {
    isChunkVisible = true,

    yBlit = 0,

	draw = function(self)
        GRAFX:setColor(0.2, 0.2, 0.2)
        GRAFX:rectangle("fill", GRAFX:calculateViewport())

        GRAFX:setColor(1, 1, 0)
        GRAFX:rectangle("fill", 260, 260, 248, 248)

        GRAFX:setColor(1, 0.7, 0.7)
        GRAFX:rectangle("fill", 516, 260, 248, 248)

        GRAFX:setColor(1, 1, 0)
        GRAFX:rectangle("fill", 772, 260, 248, 248)

        if self.isChunkVisible then self:drawCurrentChunk() end
    end,

    update = function(self, dt)
        self:updateChunkVisibility(dt)
    end,

    handleKeypressed = function(self, key)
        -- Do nothing
    end,

    handleMousepressed = function(self, mx, my)
        -- Do nothing
    end,

    --------------------------------------------------------------
    --               Specialized Draw Functions                 --
    --------------------------------------------------------------

    blitToScreen = function(self, x, y)
        GRAFX:blitToScreen(x, y, { 1, 1, 1 }, 0, 1, 1)
        self.yBlit = y
    end,

    drawCurrentChunk = function(self)
        local cX, cY = self:getChunkXY(self:getMousePositionFn())
        local x,  y  = self:getWorldCoordinatesOfChunk(cX, cY)

        GRAFX:setColor(1, 1, 1)
        GRAFX:setLineWidth(3)
        GRAFX:rectangle("line", x - 2, y - 2, 260, 260)
    end,

    getChunkXY = function(self, x, y)
        local imgX, imgY = GRAFX:screenToImageCoordinates(x, y)
        return math.floor(imgX / 256), math.floor(imgY / 256)
    end,

    getWorldCoordinatesOfChunk = function(self, cX, cY)
        return cX * 256, cY * 256
    end,

    --------------------------------------------------------------
    --              Specialized Update Functions                --
    --------------------------------------------------------------

    updateChunkVisibility = function(self, dt)
        self.isChunkVisible = not self:isScreenInMotion()

        self:updateScreenMotionDetection(dt)
    end,

    isScreenInMotion = function(self)
        return GRAFX:getX() ~= prevGraphics.x or GRAFX:getY() ~= prevGraphics.y or GRAFX:getScale() ~= prevGraphics.scale
    end,

    updateScreenMotionDetection = function(self, dt)
        prevGraphics.x, prevGraphics.y, prevGraphics.scale = GRAFX:getX(), GRAFX:getY(), GRAFX:getScale()
    end,

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

	getMousePositionFn = function(self)
        local mx, my = love.mouse.getPosition()
        return mx, my - self.yBlit
    end,
}
