TESTING = require "test/testFramework"

keyEventReceiver = ({
 
        clear = function(self)
            self.events = {
                keypressed  = {},
                keyreleased = {},
            }
            return self
        end,

        handleKeypressed  = function(self, key) self.events.keypressed[key]  = true end,
        handleKeyreleased = function(self, key) self.events.keyreleased[key] = true end,
        wasPressed  = function(self, key) return self.events.keypressed[key]        end,
        wasReleased = function(self, key) return self.events.keyreleased[key]       end,

}):clear()
        
TESTS = {
    modKeyEnabler = require "plugins/modules/modKeyEnabler",
    pluginEngine  = nil,

    beforeAll = function(self)
        self.pluginEngine = require("plugins/engine")
            :addPlugin(self.modKeyEnabler)
            :addPlugin(keyEventReceiver)
    end,

    before = function(self)
        self.modKeyEnabler:reset()
        keyEventReceiver:clear()
    end,

    testShiftKeyPressedNoEvent = function(self)
        local name = "Shift Key Down                                              => (no event)"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keypressed("rshift")

        return TESTING:assertTrue(name, not keyEventReceiver:wasPressed("lshift")
                                    and not keyEventReceiver:wasPressed("rshift"))
    end,

    testShiftKeyReleasedNoEvent = function(self)
        local name = "Shift Key Up                                                => (no event)"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keypressed("rshift")
        self.pluginEngine:keyreleased("lshift")
        self.pluginEngine:keyreleased("rshift")

        return TESTING:assertTrue(name, not keyEventReceiver:wasReleased("lshift")
                                    and not keyEventReceiver:wasReleased("rshift"))
    end,

    testLeftShiftKeyPressedAndReleased = function(self)
        local name = "Shift Key Down, Left  Key Down, Shift Key Up,   Left  Key Up => 'shiftleft'"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keypressed("left")
        self.pluginEngine:keyreleased("lshift")
        self.pluginEngine:keyreleased("left")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("shiftleft")
                                    and keyEventReceiver:wasReleased("shiftleft"))
    end,

    testIndependentShiftAndLeftPressAndRelease = function(self)
        local name = "Shift Key Down, Shift Key   Up, Left  Key Down, Left  Key Up => 'left'"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keyreleased("lshift")
        self.pluginEngine:keypressed("left")
        self.pluginEngine:keyreleased("left")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("left")
                                    and keyEventReceiver:wasReleased("left"))
    end,
    
    testIndependentLeftAndShiftPressAndRelease = function(self)
        local name = "Left  Key Down, Left  Key   Up, Shift Key Down, Shift Key Up => 'left'"

        self.pluginEngine:keypressed("left")
        self.pluginEngine:keyreleased("left")
        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keyreleased("lshift")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("left")
                                    and keyEventReceiver:wasReleased("left"))
    end,

    testLeftAndShiftDownThenLeftAndShiftUp = function(self)
        local name = "Left  Key Down, Shift Key Down, Left  Key Up,   Shift Key Up => 'left'"

        self.pluginEngine:keypressed("left")
        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keyreleased("left")
        self.pluginEngine:keyreleased("lshift")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("left")
                                    and keyEventReceiver:wasReleased("left"))
    end,

    testLeftAndShiftDownThenShiftAndLeftUp = function(self)
        local name = "Left  Key Down, Shift Key Down, Shift Key Up,   Left  Key Up => 'left'"

        self.pluginEngine:keypressed("left")
        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keyreleased("lshift")
        self.pluginEngine:keyreleased("left")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("left")
                                    and keyEventReceiver:wasReleased("left"))
    end,

    testShiftAndLeftDownThenLeftAndShiftUp = function(self)
        local name = "Shift Key Down, Left  Key Down, Left  Key Up,   Shift Key Up => 'shiftleft'"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keypressed("left")
        self.pluginEngine:keyreleased("left")
        self.pluginEngine:keyreleased("lshift")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("shiftleft")
                                    and keyEventReceiver:wasReleased("shiftleft"))
    end,
    
    testShiftAndLeftDownThenShiftAndLeftUp = function(self)
        local name = "Shift Key Down, Left  Key Down, Shift Key Up,   Left  Key Up => 'shiftleft'"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keypressed("left")
        self.pluginEngine:keyreleased("lshift")
        self.pluginEngine:keyreleased("left")
        
        return TESTING:assertTrue(name, keyEventReceiver:wasPressed("shiftleft")
                                    and keyEventReceiver:wasReleased("shiftleft"))
    end,

    testShiftAndADownThenShiftAndAUp = function(self)
        local name = "Shift Key Down, 'a'   Key Down, Shift Key Up,   'a'   Key Up => 'A'"

        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("a")
        self.modKeyEnabler:handleKeypressed("a")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("a")
        self.modKeyEnabler:handleKeyreleased("a")

        return TESTING:assertTrue(name, modifiedKeyPressed == "A" and modifiedKeyReleased == "A")
    end,
}

TESTING:initTests(TESTS)

require "test/delayTests"
