local whereRectIsValid = function(rect)
    return rect.valid
end

return {
    imageViewer          = nil,
    widthInPixels        = nil,   heightInPixels       = nil,
    callbackWhenComplete = nil,
    pixelAnalyzer        = nil,
    running              = false,
    spriteRects          = require "tools/spriteSheetSlicer/spriteRects",
    y                    = 0,
    nextY                = 0,
    linesPerSecond       = 500,
    workingRect          = nil,
    
    start = function(self, params)
        self.imageViewer           = params.imageViewer
        self.widthInPixels, 
        self.heightInPixels        = self.imageViewer:getImageSize()
        self.pixelAnalyzer         = require("tools/spriteSheetSlicer/pixelAnalyzer")
                                        :init(self.imageViewer, params.marginBGColor, params.spriteBGColor)
        self.callbackWhenComplete  = params.callbackWhenComplete or function() end

        self.running = true
    end,

    draw = function(self)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1 * self.imageViewer:getScale())
        
        for _, rect in self.spriteRects:elements() do
            love.graphics.setColor(1, 1, 1, rect.alpha or 1)
            love.graphics.rectangle("line", self.imageViewer:imageToScreenRect(rect.x, rect.y, rect.w, rect.h))
        end
    end,
    
    update = function(self, dt)
        if self.running then self:doSlicing(dt) end
        for _, rect in self.spriteRects:elements() do
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
        return math.min(self.heightInPixels, math.floor(self.nextY)) - 1
    end,
    
    sliceLine = function(self, y)
        self.workingRect = nil
        for x = 0, self.widthInPixels - 1 do
            self:processPixelAt(x, y)
        end
    end,

    processPixelAt = function(self, x, y)
        self.pixelAnalyzer:processPixelAt(x, y)
        self:findLeftEdge(x, y)
        self:findRightEdge(x, y)
    end,

    findLeftEdge = function(self, x, y)
        if self.pixelAnalyzer:isProbablyLeftEdge() then
            self.workingRect = self.spriteRects:addLeftEdge(x, y)
            self.workingRect.valid = self.workingRect.valid or self.pixelAnalyzer:isDefinitelyLeftEdge()
        end
    end,

    findRightEdge = function(self, x, y)
        if self.pixelAnalyzer:isLikelyRightEdge() and self.workingRect then
            self.workingRect.w = x - self.workingRect.x
            self.workingRect = nil
        end
    end,

    setupNextWorkUnit = function(self, dt)
        self.y     = math.floor(self.nextY)
        self.nextY = self.y + (self.linesPerSecond * dt)
    end,

    isWorkComplete = function(self, dt)
        return self.y >= self.heightInPixels
    end,

    stop = function(self)
        self.running = false
        self:callbackWhenComplete()
    end,

    findEnclosingRect = function(self, imageX, imageY)
        return self.spriteRects:findEnclosingRect(imageX, imageY, whereRectIsValid)
    end,
}
