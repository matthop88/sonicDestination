TESTING = require "test/testFramework"

TESTS = {
    WIDGET_FACTORY = require("tools/stateMachine/widgetFactory"),
    pluginManager  = nil,

    beforeAll = function(self)
        self.WIDGET_FACTORY:init(32, 32, nil)
    end,

    before    = function(self)
        -- ...
    end,

    --------- Tests ----------

   testArrowLeftToRight = function(self)
        local name = "Arrow from Left to Right"

        local data = {
            { type = "BOX",   label = "Stand Right", x =  2, y = 5, w = 9, h = 4 },
            { type = "BOX",   label = "Run Right",   x = 21, y = 5, w = 9, h = 8 },
            { type = "ARROW", label = "R On", from = "Stand Right", to = "Run Right", y = 5 },
        }

        local widgets = self.WIDGET_FACTORY:createWidgets(data)

        return TESTING:assertTrue(name, widgets[3].x1 == 11
                                    and widgets[3].x2 == 21
                                    and widgets[3].y1 ==  5
                                    and widgets[3].y2 ==  5)
    end,
    
    testWhichAlwaysPasses = function(self)
        return TESTING:assertTrue("Test which always passes", 2 + 2 == 4)
    end,
    
    -- ...

}

TESTING:initTests(TESTS)

require "test/delayTests"
