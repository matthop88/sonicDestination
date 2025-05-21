require "test/delayTests"

TESTS = {
    ASTERISKS     = "**********************************************************************************************************\n",
    modKeyEnabler = require "plugins/modules/modKeyEnabler",

    runnableTests = {},

    initTests = function(self)
        self.runnableTests = {
            self.testShiftKeyPressedNoEvent,
            self.testLeftShiftKeyPressed,
            self.testLeftShiftKeyReleased,
            self.testIndependentLeftAndShiftPressAndRelease,
            self.testShiftAndLeftDownThenLeftAndShiftUp,
            self.testLeftAndShiftDownThenLeftAndShiftUp,
            self.testShiftAndADownThenShiftAndAUp,
        }
    end,
    
    runAll = function(self)
        print("\nRunning Tests\n-------------")
        self:initTests()

        local testsSucceeded = 0

        for _, test in ipairs(self.runnableTests) do
            if self:runTest(test) then
                testsSucceeded = testsSucceeded + 1
            end
        end

        local testsFailed = #self.runnableTests - testsSucceeded

        print("\nTests succeeded: " .. testsSucceeded .. " out of " .. #self.runnableTests)
        if testsFailed > 0 then
            print("\n" .. testsFailed .. " tests FAILED.")
        end
        print("\n")
        
        love.event.quit()
    end,

    runTest = function(self, testFn)
        self:before()
        return testFn(self)
    end,

    before = function(self)
        self.modKeyEnabler:reset()
    end,

    assertTrue = function(self, name, expression)
        if expression == true then
            print("PASSED => " .. name)
            return true
        else
            print("\n" .. self.ASTERISKS .. "FAILED => " .. name .. "\n" .. self.ASTERISKS)
            return false
        end
    end,

    assertEquals = function(self, name, expected, actual)
        if expected == actual then
            print("PASSED => " .. name)
            return true
        else
            print("\n" .. self.ASTERISKS .. "FAILED => " .. name)
            print("FAILED => " .. name)
            print("  Expected: ", expected)
            print("  Actual:   ", actual)
            print(self.ASTERISKS)
            return false
        end
    end,

    testShiftKeyPressedNoEvent = function(self)
        local name = "Shift Key Down                 => (no event)"
        
        local lshiftResult = self.modKeyEnabler:handleKeypressed("lshift")
        local rshiftResult = self.modKeyEnabler:handleKeypressed("rshift")

        return self:assertTrue(name, lshiftResult == true and rshiftResult == true)
    end,

    testLeftShiftKeyPressed = function(self)
        local name = "Shift Key Down, Left  Key Down => 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKey = self.modKeyEnabler:prehandleKeypressed("left")

        return self:assertEquals(name, "shiftleft", modifiedKey)
    end,

    testLeftShiftKeyReleased = function(self)
        local name = "Shift Key Down, Left  Key Down, Shift Key Up,   Left  Key Up => 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeypressed("left")
        self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        
        return self:assertEquals(name, "shiftleft", modifiedKeyReleased)
    end,

    testIndependentLeftAndShiftPressAndRelease = function(self)
        local name = "Shift Key Down, Shift Key Up,   Left  Key Down, Left  Key Up => 'left'"

        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")

        return self:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,

    testShiftAndLeftDownThenLeftAndShiftUp = function(self)
        local name = "Shift Key Down, Left  Key Down, Left  Key Up,   Shift Key Up => 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return self:assertTrue(name, modifiedKeyPressed == "shiftleft" and modifiedKeyReleased == "shiftleft")
    end,
    
    testLeftAndShiftDownThenLeftAndShiftUp = function(self)
        local name = "Left  Key Down, Shift Key Down, Left  Key Up,   Shift Key Up => 'left'"
       
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return self:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,
    
    testShiftAndADownThenShiftAndAUp = function(self)
        local name = "Shift Key Down, 'a'   Key Down, Shift Key Up,   'a'   Key Up => 'A'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("a")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("a")
        
        return self:assertTrue(name, modifiedKeyPressed == "A" and modifiedKeyReleased == "A")
    end,
}
