require "test/delayTests"

TESTS = {
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
        testFn(self)
    end,

    before = function(self)
        self.modKeyEnabler:reset()
    end,

    testShiftKeyPressedNoEvent = function(self)
        -- Test #1
        -- When shift key is pressed (lshift or rshift), no event is transmitted
    
        local lshiftResult = self.modKeyEnabler:handleKeypressed("lshift")
        local rshiftResult = self.modKeyEnabler:handleKeypressed("rshift")
    
        if lshiftResult == true and rshiftResult == true then
            print("PASSED => Test #1: lshift and rshift keypressed were consumed by modKeyEnabler")
            return true
        else
            print("FAILED => Test #1: lshift and rshift keypressed were NOT consumed by modKeyEnabler")
            return false
        end
    end,

    testLeftShiftKeyPressed = function(self)
        -- Test #2
        -- When shift key is pressed followed by "left",
        --      "shiftleft" keypressed event is transmitted
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKey = self.modKeyEnabler:prehandleKeypressed("left")

        if modifiedKey == "shiftleft" then
            print("PASSED => Test #2: shift key + left equals shiftleft")
            return true
        else
            print("FAILED => Test #2: shift key + left does not equal shiftleft. (Result was " .. modifiedKey .. ")")
            return false
        end
    end,

    testLeftShiftKeyReleased = function(self)
        -- Test #3
        -- When this sequence of events occurs, results should match:
        --      keypressed:  shiftKey
        --      keypressed:  "left"     => keypressed:  "shiftleft"
        --      keyreleased: shiftKey
        --      keyreleased: "left"     => keyreleased: "shiftleft"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeypressed("left")
        self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        
        if modifiedKeyReleased == "shiftleft" then
            print("PASSED => Test #3: Release shift key + left equals release shiftleft")
            return true
        else
            print("FAILED => Test #3: Release shift key + left does NOT equal release shiftleft. (Result was " .. modifiedKeyReleased .. ")")
            return false
        end
    end,

    testIndependentLeftAndShiftPressAndRelease = function(self)
        -- Test #4
        -- When this sequence of events occurs:
        --      keypressed:  shiftKey
        --      keyreleased: shiftKey
        --      keypressed:  "left"
        --      keyreleased: "left"
        --
        -- The first event is a keypressed:  "left"
        -- and the second  is a keyreleased: "left"

        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")

        if modifiedKeyPressed == "left" and modifiedKeyReleased == "left" then
            print("PASSED => Test #4: Independently pressing and releasing shift and left results in left pressed & released")
            return true
        else
            print("FAILED => Test #4: Independently pressing and releasing shift and left does NOT result in left pressed & released")
            return false
        end
    end,

    testShiftAndLeftDownThenLeftAndShiftUp = function(self)
        -- Test #5
        -- When this sequence of events occurs:
        --      keypressed:  shiftKey
        --      keypressed:  "left"
        --      keyreleased: "left"
        --      keyreleased: shiftKey
        --
        -- The first event is a keypressed:  "shiftleft"
        -- and the second  is a keyreleased: "shiftleft"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        if modifiedKeyPressed == "shiftleft" and modifiedKeyReleased == "shiftleft" then
            print("PASSED => Test #5: Shift Down, Left Down, Left Up, Shift Up yields shiftLeft for pressed and released")
            return true
        else
            print("FAILED => Test #5: Shift Down, Left Down, Left Up, Shift Up does NOT yield shiftLeft for pressed and released")
            return false
        end
    end,
    
    testLeftAndShiftDownThenLeftAndShiftUp = function(self)
        -- Test #6
        -- When this sequence of events occurs:
        --      keypressed:  "left"
        --      keypressed:  shiftKey
        --      keyreleased: "left"
        --      keyreleased: shiftKey
        --
        -- The first event is a keypressed:  "left"
        -- and the second  is a keyreleased: "left"
        
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        if modifiedKeyPressed == "left" and modifiedKeyReleased == "left" then
            print("PASSED => Test #6: Left Down, Shift Down, Left Up, Shift Up yields left for pressed and released")
            return true
        else
            print("FAILED => Test #6: Left Down, Shift Down, Left Up, Shift Up does NOT left for pressed and released")
            return false
        end
    end,
    
    testShiftAndADownThenShiftAndAUp = function(self)
        -- Test #7
        -- When this sequence of events occurs:
        --      keypressed:  shiftKey
        --      keypressed:  "a"
        --      keyreleased: shiftKey
        --      keyreleased: "a"
        --
        -- The first event is a keypressed:  "A"
        -- and the second  is a keyreleased: "A"
        
        self.modKeyEnabler:handleKeypressed("lshift")
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("a")
        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("a")
        
        if modifiedKeyPressed == "A" and modifiedKeyReleased == "A" then
            print("PASSED => Test #7: Shift Down, 'a' Down, Shift Up, 'a' Up yields 'A' for pressed and released")
            return true
        else
            print("FAILED => Test #7: Shift Down, 'a' Down, Shift Up, 'a' Up does NOT yield 'A' for pressed and released")
            return false
        end
    end,
}
