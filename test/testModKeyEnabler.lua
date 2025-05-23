TESTING = require "test/testFramework"

keyEventReceiver = ({
        
        clear = function(self)
            self.events = {
                keypressed  = {},
                keyreleased = {},
            }
            return self
        end,

        keypressed  = function(self, key) self.events.keypressed[key]  = true end,
        keyreleased = function(self, key) self.events.keyreleased[key] = true end,
        wasPressed  = function(self, key) return self.events.keypressed[key]  end,
        wasReleased = function(self, key) return self.events.keyreleased[key] end,
        
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
        local name = "Shift Key Down (Using plugin manager)                        => (no event)"

        self.pluginEngine:keypressed("lshift")
        self.pluginEngine:keypressed("rshift")

        return TESTING:assertTrue(name, not keyEventReceiver:wasPressed("lshift")
                                    and not keyEventReceiver:wasPressed("rshift"))
    end,
    
    oldTestShiftKeyPressedNoEvent = function(self)
        local name = "Shift Key Down                                               => (no event)"
        
        local lshiftResult = self.modKeyEnabler:handleKeypressed("lshift")
        local rshiftResult = self.modKeyEnabler:handleKeypressed("rshift")

        return TESTING:assertTrue(name, lshiftResult == true and rshiftResult == true)
    end,

    testShiftKeyReleasedNoEvent = function(self)
        local name = "Shift Key Up                                                 => (no event)"

        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeypressed("rshift")
        local lshiftReleasedResult = self.modKeyEnabler:handleKeyreleased("lshift")
        local rshiftReleasedResult = self.modKeyEnabler:handleKeyreleased("rshift")

        return TESTING:assertTrue(name, lshiftReleasedResult == true and rshiftReleasedResult == true)
    end,
    
    testLeftShiftKeyPressedAndReleased = function(self)
        local name = "Shift Key Down, Left  Key Down, Shift Key Up,   Left  Key Up => 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")
        
        return TESTING:assertTrue(name, modifiedKeyPressed == "shiftleft" and modifiedKeyReleased == "shiftleft")
    end,

    testIndependentShiftAndLeftPressAndRelease = function(self)
        local name = "Shift Key Down, Shift Key   Up, Left  Key Down, Left  Key Up => 'left'"

        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")

        return TESTING:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,
    
    testIndependentLeftAndShiftPressAndRelease = function(self)
        local name = "Left  Key Down, Left  Key   Up, Shift Key Down, Left  Key Up => 'left'"

        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")
        
        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return TESTING:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,

    testLeftAndShiftDownThenLeftAndShiftUp = function(self)
        local name = "Left  Key Down, Shift Key Down, Left  Key Up,   Shift Key Up => 'left'"
       
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return TESTING:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,

    testLeftAndShiftDownThenShiftAndLeftUp = function(self)
        local name = "Left  Key Down, Shift Key Down, Shift Key Up,   Left  Key Up => 'left'"

        local modifiedKeyPressed = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")

        return TESTING:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,

    testShiftAndLeftDownThenLeftAndShiftUp = function(self)
        local name = "Shift Key Down, Left  Key Down, Left  Key Up,   Shift Key Up => 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return TESTING:assertTrue(name, modifiedKeyPressed == "shiftleft" and modifiedKeyReleased == "shiftleft")
    end,
    
    testShiftAndLeftDownThenShiftAndLeftUp = function(self)
        local name = "Shift Key Down, Left  Key Down, Shift Key Up,   Left  Key Up => 'shiftleft'"

        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")

        return TESTING:assertTrue(name, modifiedKeyPressed == "shiftleft" and modifiedKeyReleased == "shiftleft")
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
