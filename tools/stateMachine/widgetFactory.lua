return {
    init = function(self, gridSize, labelFontSize, graphics)
        self.GRID_SIZE       = gridSize
        self.LABEL_FONT_SIZE = labelFontSize
        self.graphics        = graphics

        self.BOX   = require("tools/stateMachine/box"):init(  self.GRID_SIZE, self.LABEL_FONT_SIZE, graphics)
        self.ARROW = require("tools/stateMachine/arrow"):init(self.GRID_SIZE, self.LABEL_FONT_SIZE, graphics)

        return self
    end,

    createWidgets = function(self, data)
        local widgets = {}
        self.boxesByName = {}

        for _, dataElement in ipairs(data) do
            table.insert(widgets, self:createFromDataElement(dataElement))
        end

        return widgets
    end,

    createFromDataElement = function(self, element)
        if     element.type == "BOX"   then
            return self:createBox(element)
        elseif element.type == "ARROW" then
            return self:createArrow(element)
        end
    end,

    createBox   = function(self, element)
        local box = self.BOX:create(element.label, element.x, element.y, element.w, element.h)
        self.boxesByName[element.label] = box
        return box
    end,
    
    createArrow = function(self, element)
        if element.x1 then
            return self.ARROW:create(element.label, element.x1, element.y1, element.x2, element.y2)
        else
            return self:createSmartArrow(element)
        end
    end,

    createSmartArrow = function(self, element)
        local srcBox = self.boxesByName[element.from]
        local dstBox = self.boxesByName[element.to]
        
        if dstBox.x > srcBox.x then return self:createSmartRightArrow(element, srcBox, dstBox)
        else                        return self:createSmartLeftArrow(element, srcBox, dstBox)  end
    end,

    createSmartRightArrow = function(self, element, srcBox, dstBox)
        local smartRightArrow = self.ARROW:create(element.label, (srcBox.x + srcBox.w) / self.GRID_SIZE, element.y, dstBox.x / self.GRID_SIZE, element.y)
        smartRightArrow.from = srcBox
        smartRightArrow.to   = dstBox
        self:createKeyEvent(smartRightArrow)
        return smartRightArrow
    end,

    createSmartLeftArrow = function(self, element, srcBox, dstBox)
        local smartLeftArrow = self.ARROW:create(element.label, srcBox.x / self.GRID_SIZE, element.y, (dstBox.x + dstBox.w) / self.GRID_SIZE, element.y)
        smartLeftArrow.from = srcBox
        smartLeftArrow.to   = dstBox
        self:createKeyEvent(smartLeftArrow)
        return smartLeftArrow
    end,

    createKeyEvent = function(self, element)
        if     element.label == "L On"  then element.keypressed  = "left"
        elseif element.label == "R On"  then element.keypressed  = "right"
        elseif element.label == "L Off" then element.keyreleased = "left"
        elseif element.label == "R Off" then element.keyreleased = "right"
        end
    end,
    
}
