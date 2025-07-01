local whereRectIsValid = function(rect)
    return rect.valid
end

local IMAGE_VIEWER
local PIXEL_WIDTH,  PIXEL_HEIGHT
local SPRITE_RECTS, PIXEL_ANALYZER, SPRITE_CROPPER

return {
    callbackWhenComplete = nil,
    running              = false,
    y                    = 0,
    nextY                = 0,
    linesPerSecond       = 500,
    workingRect          = nil,
    
    start = function(self, params)
        IMAGE_VIEWER              = params.imageViewer
        PIXEL_WIDTH, PIXEL_HEIGHT = IMAGE_VIEWER:getImageSize()
        SPRITE_RECTS              = require "tools/spriteSheetSlicer/spriteRects"
        PIXEL_ANALYZER            = require("tools/spriteSheetSlicer/pixelAnalyzer")
                                        :init(IMAGE_VIEWER, params.marginBGColor, params.spriteBGColor)
        SPRITE_CROPPER            = require("tools/spriteSheetSlicer/spriteCropper")
                                        :init(IMAGE_VIEWER, params.marginBGColor, params.spriteBGColor)
        
        self.callbackWhenComplete = params.callbackWhenComplete or function() end

        self.running = true
    end,

    draw = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1 * IMAGE_VIEWER:getScale())
        
        for _, rect in SPRITE_RECTS:elements() do
            love.graphics.setColor(1, 1, 1, rect.alpha or 1)
            love.graphics.rectangle("line", IMAGE_VIEWER:imageToScreenRect(rect.x, rect.y, rect.w, rect.h))
        end
    end,
    
    update = function(self, dt)
        if self.running then self:doSlicing(dt) end
        for _, rect in SPRITE_RECTS:elements() do
            if not rect.valid or not self.running then
                rect.alpha = math.max(0, (rect.alpha or 1) - dt)
            else
                rect.alpha = 1
            end
        end
    end,

    doSlicing = function(self, dt)
        self:sliceUntilWorkUnitIsDone()
        self:setupNextWorkUnit(dt)
        
        if self:isWorkComplete() then self:stop() end
    end,
    
    sliceUntilWorkUnitIsDone = function(self)
        for y = self.y, self:calculateYAtEndOfWorkUnit() do
            self:sliceLine(y)
        end
    end,

    calculateYAtEndOfWorkUnit = function(self)
        return math.min(PIXEL_HEIGHT, math.floor(self.nextY)) - 1
    end,
    
    sliceLine = function(self, y)
        self.workingRect = nil
        for x = 0, PIXEL_WIDTH - 1 do
            self:processPixelAt(x, y)
        end
    end,

    processPixelAt = function(self, x, y)
        PIXEL_ANALYZER:processPixelAt(x, y)
        self:findLeftEdge(x, y)
        self:findRightEdge(x, y)
    end,

    findLeftEdge = function(self, x, y)
        if PIXEL_ANALYZER:isProbablyLeftEdge() then
            self.workingRect = SPRITE_RECTS:addLeftEdge(x, y)
            self.workingRect.valid = self.workingRect.valid or PIXEL_ANALYZER:isDefinitelyLeftEdge()
        end
    end,

    findRightEdge = function(self, x, y)
        if PIXEL_ANALYZER:isLikelyRightEdge() and self.workingRect then
            self.workingRect.w = x - self.workingRect.x
            self.workingRect = nil
        end
    end,

    setupNextWorkUnit = function(self, dt)
        self.y     = math.floor(self.nextY)
        self.nextY = self.y + (self.linesPerSecond * dt)
    end,

    isWorkComplete = function(self, dt)
        return self.y >= PIXEL_HEIGHT
    end,

    stop = function(self)
        self.running = false
        self:callbackWhenComplete()
    end,

    findEnclosingRect = function(self, imageX, imageY)
        return SPRITE_RECTS:findEnclosingRect(imageX, imageY, whereRectIsValid)
    end,
}
