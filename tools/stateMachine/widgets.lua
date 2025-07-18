return {
    "standing",
    "running",
    "decelerating",

    currentWidgetList = { },
    currentIndex      = 1,

    WIDGET_FACTORY = nil,
        
    init = function(self, widgetFactory)
        self.WIDGET_FACTORY = widgetFactory
        self:refresh()
        return self
    end,

    draw = function(self)
        for _, widget in ipairs(self:get()) do
            widget:draw()
        end
    end,

    mousepressed = function(self, mx, my)
        for _, widget in ipairs(self:get()) do
            if widget.mousepressed then widget:mousepressed(mx, my) end
        end
    end,

    deselectAll = function(self)
        for _, widget in ipairs(self:get()) do
            widget:deselect()
        end
    end,
    
    get  = function(self) 
        return self.currentWidgetList                                     
    end,

    next = function(self)
        self.currentIndex = self.currentIndex + 1
        if self.currentIndex > #self then
            self.currentIndex = 1
        end
        self:refresh()
    end,

    prev = function(self)
        self.currentIndex = self.currentIndex - 1
        if self.currentIndex < 1 then
            self.currentIndex = #self
        end
        self:refresh()
    end,

    refresh = function(self)
        self.currentWidgetList = self.WIDGET_FACTORY:createWidgets(dofile(self:getFileName()))
    end,

    getFileName = function(self) return "tools/stateMachine/data/" .. self:getDataName() .. ".lua" end,
    getDataName = function(self) return self[self.currentIndex]                                    end,

    getFirstBox = function(self)
        for _, widget in ipairs(self:get()) do
            if widget:getType() == "BOX" then return widget end
        end
    end,
}
