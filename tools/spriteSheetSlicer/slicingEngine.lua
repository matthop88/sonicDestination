local whereRectIsValid = function(rect)
    return rect.valid
end

return {
    imageViewer          = nil,
    widthInPixels        = nil,   heightInPixels       = nil,
    marginBGColor        = nil,   spriteBGColor        = nil,
    callbackWhenComplete = nil,
    running              = false,
    spriteRects          = require "tools/spriteSheetSlicer/spriteRects",
    y                    = 0,
    nextY                = 0,
    prevColor            = nil,
    linesPerSecond       = 500,
    
    start = function(self, params)
        self.imageViewer           = params.imageViewer
        self.widthInPixels, 
        self.heightInPixels        = self.imageViewer:getImageSize()
        
        self.marginBGColor         = params.marginBGColor
        self.spriteBGColor         = params.spriteBGColor
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
            if not rect.valid and rect.alpha ~= nil then
                rect.alpha = math.max(0, rect.alpha - dt)
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
        for x = 0, self.widthInPixels - 1 do
            self:processPixelAt(x, y)
        end
    end,

    processPixelAt = function(self, x, y)
        if x == 0 then self.prevColor = nil end
        
        local pixelColor = self.imageViewer:getPixelColorAt(x, y)
        self:findLeftEdge(pixelColor, x, y)
        
        self.prevColor = pixelColor
    end,

    findLeftEdge = function(self, pixelColor, x, y)
        if self:isProbablyLeftEdge(pixelColor) then
            local resultingRect = self.spriteRects:addLeftEdge(x, y)
            if self:isDefinitelyLeftEdge(pixelColor) then
                resultingRect.valid = true
            end
        end
    end,

    isProbablyLeftEdge  = function(self, thisColor)
        return      self:colorsMatch(self.prevColor, self.marginBGColor)
            and not self:colorsMatch(thisColor,      self.marginBGColor)
    end,

    isDefinitelyLeftEdge  = function(self, thisColor)
        return  self:colorsMatch(self.prevColor, self.marginBGColor)
            and self:colorsMatch(thisColor,      self.spriteBGColor)
    end,
    
    colorsMatch = function(self, c1, c2)
        return c1 ~= nil 
           and c2 ~= nil
           and math.abs(c1.r - c2.r) < 0.005
           and math.abs(c1.g - c2.g) < 0.005 
           and math.abs(c1.b - c2.b) < 0.005
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
        self:cleanup()
        self:callbackWhenComplete()
    end,

    cleanup = function(self)
        for _, rect in self.spriteRects:elements() do
            rect.alpha = 1
        end
    end,

    findEnclosingRect = function(self, imageX, imageY)
        return self.spriteRects:findEnclosingRect(imageX, imageY, whereRectIsValid)
    end,
}
