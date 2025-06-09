TESTING = require "test/testFramework"

tests = {
    WIDGET_FACTORY = require 'tools/stateMachine/widgetFactory",
    pluginManager  = nil,

    beforeAll = function(self)
        self.WIDGET_FACTORY:init(32, 32, nil)
    end,

    before    = function(self)
        -- ...
    end,

    --------- Tests ----------

    -- ...
    -- ...
    -- ...

}

TESTING:initTests(tests)

require "test/delayTests"
