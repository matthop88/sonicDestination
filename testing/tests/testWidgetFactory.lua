return {
    WIDGET_FACTORY = require("tools/stateMachine/widgetFactory"),
    pluginManager  = nil,

    getName = function(self)
        return "State Machine Widget Factory Smart Arrow Tests"
    end,
    
    beforeAll = function(self)
        self.WIDGET_FACTORY:init(1, 1, nil)
    end,

    before    = function(self)
        -- ...
    end,

    --------- Tests ----------

   testArrowLeftToRight = function(self)
        local name    = "Test Arrow from Left to Right"
        local widgets = self:generateTestWidgets()

        local resultString = "X1 = " .. widgets[3].x1 .. ", X2 = " .. widgets[3].x2 .. ", Y1 = " .. widgets[3].y1 .. ", Y2 = " .. widgets[3].y2
        
        return TESTING:assertEquals(name, "X1 = 11, X2 = 21, Y1 = 5, Y2 = 5", resultString)
    end,
    
    testArrowRightToLeft = function(self)
        local name    = "Test Arrow from Right to Left"
        local widgets = self:generateTestWidgets()

        local resultString = "X1 = " .. widgets[4].x1 .. ", X2 = " .. widgets[4].x2 .. ", Y1 = " .. widgets[4].y1 .. ", Y2 = " .. widgets[4].y2
        
        return TESTING:assertEquals(name, "X1 = 21, X2 = 11, Y1 = 8, Y2 = 8", resultString)
    end,
        
    testLeftArrowToField = function(self)
        local name    = "Test Left Arrow 'To' Field"
        local widgets = self:generateTestWidgets()

        return TESTING:assertTrue(name, widgets[4].to == widgets[1])
    end,

    testLeftArrowFromField = function(self)
        local name    = "Test Left Arrow 'From' Field"
        local widgets = self:generateTestWidgets()

        return TESTING:assertTrue(name, widgets[4].from == widgets[2])
    end,

    testLeftArrowKeyreleasedField = function(self)
        local name    = "Test Left Arrow Key Released Field"
        local widgets = self:generateTestWidgets()

        return TESTING:assertTrue(name, widgets[4].keyreleased == "right")
    end,

    testRightArrowKeypressedField = function(self)
        local name = "Test Right Arrow Key Pressed Field"
        local widgets = self:generateTestWidgets()

        return TESTING:assertTrue(name, widgets[3].keypressed == "right")
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
