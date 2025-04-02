return {
    y                    = 0,
    nextY                = 0,
    marginBGColor        = nil,
    spriteBGColor        = nil,
    imageViewer          = nil,
    widthInPixels        = nil,
    heightInPixels       = nil,
    linesPerSecond       = 500,
    running              = false,
    matchesFound         = 0,
    prevColor            = nil,
    callbackWhenComplete = function() end,

    spriteRects          = {},

    start = function(self, params)
        self.imageViewer          = params.imageViewer
        self.marginBGColor        = params.marginBGColor
        self.spriteBGColor        = params.spriteBGColor
        self.callbackWhenComplete = params.callbackWhenComplete or self.callbackWhenComplete

        self.widthInPixels, self.heightInPixels = self.imageViewer:getImageSize()
        self.running = true
    end,
    
    update = function(self, dt)
        if self.running then
            self:doSlicing(dt)
        end
    end,

    doSlicing = function(self, dt)
        self:sliceUntilWorkUnitIsDone()
        self:setupNextWorkUnit(dt)
        if self:isWorkComplete() then
            self:stop()
        end
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
        if self:isLeftEdge(pixelColor) then
            print("Found Left Edge at x = " .. x .. ", y = " .. y)
            table.insert(self.spriteRects, { x = x, y = y, w = 50, h = 1 })
            self.matchesFound = self.matchesFound + 1
        end
    end,

    isLeftEdge  = function(self, thisColor)
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
        self:callbackWhenComplete()
        print("Matches Found: " .. self.matchesFound)
    end,
}
