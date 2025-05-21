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
        local name = "When Shift Key is pressed, no event is transmitted"
        local lshiftResult = self.modKeyEnabler:handleKeypressed("lshift")
        local rshiftResult = self.modKeyEnabler:handleKeypressed("rshift")

        return self:assertTrue(name, lshiftResult == true and rshiftResult == true)
    end,

    testLeftShiftKeyPressed = function(self)
        local name = "Shift Key pressed followed by Left Key pressed generates 'shiftleft' event"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKey = self.modKeyEnabler:prehandleKeypressed("left")

        return self:assertEquals(name, "shiftleft", modifiedKey)
    end,

    testLeftShiftKeyReleased = function(self)
        local name = "Shift Down, Left Down, Shift Up, Left Up => keypressed: 'shiftleft', keyreleased: 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeypressed("left")
        self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        
        return self:assertEquals(name, "shiftleft", modifiedKeyReleased)
    end,

    testIndependentLeftAndShiftPressAndRelease = function(self)
        local name = "Shift Down, Shift Up, Left Down, Left Up => keypressed: 'left', keyreleased: 'left'"

        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")

        return self:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,

    testShiftAndLeftDownThenLeftAndShiftUp = function(self)
        local name = "Shift Down, Left Down, Left Up, Shift Up => keypressed: 'shiftleft', keyreleased: 'shiftleft'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return self:assertTrue(name, modifiedKeyPressed == "shiftleft" and modifiedKeyReleased == "shiftleft")
    end,
    
    testLeftAndShiftDownThenLeftAndShiftUp = function(self)
        local name = "Left Down, Shift Down, Left Up, Shift Up => keypressed: 'left', keyreleased: 'left'"
       
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        return self:assertTrue(name, modifiedKeyPressed == "left" and modifiedKeyReleased == "left")
    end,
    
    testShiftAndADownThenShiftAndAUp = function(self)
        local name = "Shift Down, 'a' Down, Shift Up, 'a' Up => keypressed: 'A', keyreleased: 'A'"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("a")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("a")
        
        return self:assertTrue(name, modifiedKeyPressed == "A" and modifiedKeyReleased == "A")
    end,
}
