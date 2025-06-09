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

        for _, dataElement in ipairs(data) do
            table.insert(widgets, self:createFromDataElement(dataElement))
        end

        return widgets
    end,

    createFromDataElement = function(self, element)
        if     element.type == "BOX"   then
            return self.BOX:create(element.label, element.x, element.y, element.w, element.h)
        elseif element.type == "ARROW" then
            return self:createArrow(element)
        end
    end,

    createArrow = function(self, element)
        return self.ARROW:create(element.label, element.x1, element.y1, element.x2, element.y2)
    end,
}
