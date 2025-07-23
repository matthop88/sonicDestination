local LABEL_FONT_SIZE = 32
local GRID_SIZE       = 32

local PEGBOARD, WIDGET_FACTORY, WIDGETS

return {
    init = function(self, params)
        self.targetBox = nil
        self.refreshKey = params.refreshKey or "return"
        self.nextKey    = params.nextKey    or "tab"
        self.prevKey    = params.prevKey    or "shifttab"
        self.graphics   = params.graphics

        PEGBOARD       = require("plugins/modules/stateMachineViewer/pegboard"):init(GRID_SIZE, self.graphics)
        WIDGET_FACTORY = require("plugins/modules/stateMachineViewer/widgetFactory"):init(GRID_SIZE, LABEL_FONT_SIZE, self.graphics)
        WIDGETS        = require("plugins/modules/stateMachineViewer/widgets"):init(WIDGET_FACTORY)

        self:refreshTargetBox()
        
        return self
    end,

    draw = function(self)
        PEGBOARD:draw()
        WIDGETS:draw()
    end,

    handleKeypressed = function(self, key)
        if key == self.refreshKey or key == self.nextKey or key == self.prevKey then
            self:processViewKeypressedEvent(key)
        else
            self:processWidgetKeypressedEvent(key)
        end
    end,

    processViewKeypressedEvent = function(self, key)
        if     key == self.refreshKey then WIDGETS:refresh()
        elseif key == self.nextKey    then WIDGETS:next()
        elseif key == self.prevKey    then WIDGETS:prev()   end

        self:refreshTargetBox()

        self.graphics.x, self.graphics.y, self.graphics.scale = WIDGETS.x, WIDGETS.y, WIDGETS.scale
    end,

    refreshTargetBox = function(self)
        self.targetBox = WIDGETS:getFirstBox()
        self.targetBox:select()
    end,

    processWidgetKeypressedEvent = function(self, key)
        for _, widget in ipairs(WIDGETS:get()) do
            if widget.keypressed == key and widget.from == self.targetBox then
                WIDGETS:deselectAll()
                self.targetBox = widget.to
                self.targetBox:select()
                widget:select()
                printMessage(widget.label)
            end
        end
    end,

    handleKeyreleased = function(self, key)
        self:processWidgetKeyreleasedEvent(key)
    end,

    handleMousepressed = function(self, mx, my)
        WIDGETS:deselectAll()
        WIDGETS:mousepressed(mx, my)
        self:updateTargetBox()
    end,

    updateTargetBox = function(self)
        for _, widget in ipairs(WIDGETS:get()) do
            if widget:getType() == "BOX" and widget:isSelected() then
                self.targetBox = widget
            end
        end
    end,

    processKeyreleasedEvent = function(self, key)
        for _, widget in ipairs(WIDGETS:get()) do
            if widget.keyreleased == key and widget.from == self.targetBox then
                WIDGETS:deselectAll()
                self.targetBox = widget.to
                self.targetBox:select()
                widget:select()
                printMessage(widget.label)
            end
        end
    end,
    
}
