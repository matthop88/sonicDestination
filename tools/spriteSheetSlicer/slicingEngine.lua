local sliceTable   = require("tools/spriteSheetSlicer/sliceTable")
local sliceFactory = require("tools/spriteSheetSlicer/sliceFactory")

return {
    MARGIN_BACKGROUND_COLOR = nil,
    SPRITE_BACKGROUND_COLOR = nil,
    IMAGE_WIDTH             = nil,
    IMAGE_HEIGHT            = nil,
    getImageViewer          = nil,
    pixelAnalyzer           = nil,
    prevColor               = nil,
    thisColor               = nil,
    
    slice = function(self, marginBgColor, spriteBgColor, imageViewerFn)
        self.getImageViewer = imageViewerFn
        self.IMAGE_WIDTH, self.IMAGE_HEIGHT = self.getImageViewer():getImageSize()
        self.pixelAnalyzer  = require("tools/spriteSheetSlicer/pixelAnalyzer")
                                      :init(marginBgColor, spriteBgColor) 

        self:doSlicing()
        return self:finalizeSpriteRects()
    end,

    doSlicing = function(self)
        for y = 0, self.IMAGE_HEIGHT - 1 do
            local newSlices = self:createHorizontalSlicesFromLine(y)
            self:addHorizontalSlices(newSlices, y)
        end
    end,

    createHorizontalSlicesFromLine = function(self, y)
        self.prevColor = nil
        return self:appendHorizontalSlicesTo({ }, y)
    end,

    appendHorizontalSlicesTo = function(self, sliceList, y)
        for x = 0, self.IMAGE_WIDTH - 1 do
            self.thisColor = self:getImageViewer():getPixelColorAt(x, y)
            local newSlice = self:produceSliceFrom(x, y)
            if newSlice ~= nil then table.insert(sliceList, newSlice) end
        end
        return sliceList
    end,

    produceSliceFrom = function(self, x, y)
        local pixelTransitionData = self.pixelAnalyzer:analyzePixelTransition(self.prevColor, self.thisColor)
        self.prevColor = self.thisColor
        return sliceFactory:produceSliceUsing(pixelTransitionData, x, y)
    end,

    addHorizontalSlices = function(self, horizSlices, y)
        sliceTable:markCompletedSlicesAbove(y)
        sliceTable:update()
        if #horizSlices > 0 then
            sliceTable:addHorizontalSlices(horizSlices)
        end
    end,

    finalizeSpriteRects = function(self)
        return sliceTable:getFinishedSpriteRects()
    end,
}
