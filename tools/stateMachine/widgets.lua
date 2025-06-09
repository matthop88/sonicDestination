return ({
    "standing",
    "running",

    currentWidgetList = { },
    currentIndex      = 1,

    init = function(self)
        self:refresh()
        return self
    end,

    get         = function(self) return self.currentWidgetList                                     end,
    getDataName = function(self) return self[self.currentIndex]                                    end,
    getFileName = function(self) return "tools/stateMachine/data/" .. self:getDataName() .. ".lua" end,

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
        self.currentWidgetList = WIDGET_FACTORY:createWidgets(dofile(self:getFileName()))
    end,

}):init()
