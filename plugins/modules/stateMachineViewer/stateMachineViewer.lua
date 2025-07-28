local LABEL_FONT_SIZE = 32
local GRID_SIZE       = 32

local PEGBOARD, WIDGET_FACTORY, WIDGETS

return {
    arrowFunctions = { },
    
    init = function(self, params)
        self.targetBox      = nil
        self.refreshKey     = params.refreshKey or "return"
        self.nextKey        = params.nextKey    or "="
        self.prevKey        = params.prevKey    or "-"
        self.graphics       = require("tools/lib/bufferedGraphics"):create(params.graphics, 1024, 768)
        self.arrowFunctions = params.arrowFunctions or self.arrowFunctions
        
        PEGBOARD       = require("plugins/modules/stateMachineViewer/pegboard"):init(GRID_SIZE, self.graphics)
        WIDGET_FACTORY = require("plugins/modules/stateMachineViewer/widgetFactory"):init(GRID_SIZE, LABEL_FONT_SIZE, self.graphics)
        WIDGETS        = require("plugins/modules/stateMachineViewer/widgets"):init(WIDGET_FACTORY, params.states)

        printMessage   = printMessage or function(msg) print(msg) end
        self:refreshView()
        
        return self
    end,

    draw = function(self)
        PEGBOARD:draw()
        WIDGETS:draw()
        self.graphics:blitToScreen(0, 0, { 1, 1, 1, 0.3 })
    end,

    update = function(self, dt)
        self:updateFromArrowFunctions()
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

        self:refreshView()
    end,

    refreshView = function(self)
        self:refreshTargetBox()

        self.graphics:setX(WIDGETS.x)
        self.graphics:setY(WIDGETS.y)
        self.graphics:setScale(WIDGETS.scale)
    end,

    refreshTargetBox = function(self)
        self.targetBox = WIDGETS:getFirstBox()
        self.targetBox:select()
    end,

    processWidgetKeypressedEvent = function(self, key)
        for _, widget in ipairs(WIDGETS:get()) do
            if widget.keypressed == key and widget.from == self.targetBox then
                self:selectWidget(widget)
            end
        end
    end,

    processWidgetKeyreleasedEvent = function(self, key)
        for _, widget in ipairs(WIDGETS:get()) do
            if widget.keyreleased == key and widget.from == self.targetBox then
                self:selectWidget(widget)
            end
        end
    end,

    selectWidget = function(self, widget)
        WIDGETS:deselectAll()
        self.targetBox = widget.to
        self.targetBox:select()
        widget:select()
        printMessage(widget.label)
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

    updateFromArrowFunctions = function(self)
        for _, kv in ipairs(self.arrowFunctions) do
            for _, widget in ipairs(WIDGETS:get()) do
                if widget.label == kv.key and kv.fn() and widget.from == self.targetBox then
                    self:selectWidget(widget)
                end
            end
        end
    end,

    getGraphics = function(self)
        return self.graphics
    end,
    
}
