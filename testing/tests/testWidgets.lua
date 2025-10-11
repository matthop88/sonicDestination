return {
    WIDGET_FACTORY = nil,
    WIDGETS        = nil,

    getName = function(self)
        return "State Machine Widget Test - Finding Default Box Widget Tests"
    end,
    
    beforeAll = function(self)
        self.WIDGET_FACTORY = require("plugins/modules/stateMachineViewer/widgetFactory"):init(1, 32, nil)
        self.WIDGETS = require("plugins/modules/stateMachineViewer/widgets"):init(self.WIDGET_FACTORY, {})
    end,

    before    = function(self)
        -- ...
    end,

    --------- Tests ----------

   testGetFirstBox = function(self)
        local name    = "Test Get First Box"
        self.WIDGETS.currentWidgetList = self:generateTestWidgets()

        return TESTING:assertTrue(name, self.WIDGETS:getFirstBox() == self.WIDGETS.currentWidgetList[1])
    end,

    generateTestWidgets = function(self)
        return self.WIDGET_FACTORY:createWidgets(self:generateTestData())
    end,
    
    generateTestData = function(self)
        return {
            { type = "BOX",   label = "Stand Right", x =  2, y = 5, w = 9, h = 4 },
            { type = "BOX",   label = "Run Right",   x = 21, y = 5, w = 9, h = 8 },
            { type = "ARROW", label = "R On",  from = "Stand Right", to = "Run Right",   y = 5 },
            { type = "ARROW", label = "R Off", from = "Run Right",   to = "Stand Right", y = 8 },
        }
    end,
}
