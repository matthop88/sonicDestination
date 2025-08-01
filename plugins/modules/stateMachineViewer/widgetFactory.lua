return {
    init = function(self, gridSize, labelFontSize, graphics)
        self.GRID_SIZE       = gridSize
        self.LABEL_FONT_SIZE = labelFontSize
        self.graphics        = graphics

        self.BOX   = require("plugins/modules/stateMachineViewer/box"):init(  self.GRID_SIZE, self.LABEL_FONT_SIZE,        graphics)
        self.ARROW = require("plugins/modules/stateMachineViewer/arrow"):init(self.GRID_SIZE, self.LABEL_FONT_SIZE * 0.75, graphics)

        return self
    end,

    createWidgets = function(self, data)
        local widgets = {}
        self.boxesByName = {}

        for _, dataElement in ipairs(data) do
            table.insert(widgets, self:createFromDataElement(dataElement))
        end

        widgets.x, widgets.y, widgets.scale = data.x, data.y, data.scale
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
        
        if element.y then
            if dstBox.x > srcBox.x then return self:createSmartRightArrow(element, srcBox, dstBox)
            else                        return self:createSmartLeftArrow(element, srcBox, dstBox)  end
        else
            if dstBox.y > srcBox.y then return self:createSmartDownArrow(element, srcBox, dstBox)
            else                        return self:createSmartUpArrow(element, srcBox, dstBox)    end
        end
    end,

    createSmartRightArrow = function(self, element, srcBox, dstBox)
        local smartRightArrow = self.ARROW:create(element.label, (srcBox.x + srcBox.w) / self.GRID_SIZE, element.y, dstBox.x / self.GRID_SIZE, element.y)
        return self:setupSmartArrow(smartRightArrow)
    end,

    setupSmartArrow = function(self, arrow, srcBox, dstBox)
        arrow.from = srcBox
        arrow.to   = dstBox
        self:createKeyEvent(arrow)
        return arrow
    end,
    
    createSmartLeftArrow = function(self, element, srcBox, dstBox)
        local smartLeftArrow = self.ARROW:create(element.label, srcBox.x / self.GRID_SIZE, element.y, (dstBox.x + dstBox.w) / self.GRID_SIZE, element.y)
        return self:setupSmartArrow(smartLeftArrow)
    end,

    createSmartUpArrow = function(self, element, srcBox, dstBox)
        local smartUpArrow = self.ARROW:create(element.label, element.x, srcBox.y / self.GRID_SIZE, element.x, (dstBox.y + dstBox.h) / self.GRID_SIZE)
        return self:setupSmartArrow(smartUpArrow)
    end,

    createSmartDownArrow = function(self, element, srcBox, dstBox)
        local smartDownArrow = self.ARROW:create(element.label, element.x, (srcBox.y + srcBox.h) / self.GRID_SIZE, element.x, dstBox.y / self.GRID_SIZE)
        return self:setupSmartArrow(smartDownArrow)
    end,
    
    createKeyEvent = function(self, element)
        if     element.label == "L On"      then element.keypressed  = "left"
        elseif element.label == "R On"      then element.keypressed  = "right"
        elseif element.label == "L Off"     then element.keyreleased = "left"
        elseif element.label == "R Off"     then element.keyreleased = "right"
        elseif element.label == "Speed = 0" then element.keypressed  = "0"
        end
    end,
    
}
