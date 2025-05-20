require "test/delayTests"

TESTS = {
    modKeyEnabler = require "plugins/modules/modKeyEnabler",

    runAll = function(self)
        print("\nRunning Tests\n-------------")
    
        self:testShiftKeyPressedNoEvent()
        self:testLeftShiftKeyPressed()
        self:testLeftShiftKeyReleased()
        self:testIndependentLeftAndShiftPressAndRelease()

        love.event.quit()
    end,

    testShiftKeyPressedNoEvent = function(self)
        -- Test #1
        -- When shift key is pressed (lshift or rshift), no event is transmitted
    
        local lshiftResult = self.modKeyEnabler:handleKeypressed("lshift")
        local rshiftResult = self.modKeyEnabler:handleKeypressed("rshift")
    
        if lshiftResult == true and rshiftResult == true then
            print("PASSED => Test #1: lshift and rshift keypressed were consumed by modKeyEnabler")
        else
            print("FAILED => Test #1: lshift and rshift keypressed were NOT consumed by modKeyEnabler")
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
        else
            print("FAILED => Test #2: shift key + left does not equal shiftleft. (Result was " .. modifiedKey .. ")")
        end
    end,

    testLeftShiftKeyReleased = function(self)
        -- Test #3
        -- When this sequence of events occurs, results should match:
        --      keypressed:  shiftKey
        --      keypressed:  "left"     => keypressed:  "shiftleft"
        --      keyreleased: shiftKey
        --      keyreleased: "left"     => keyreleased: "shiftleft"

        self.modKeyEnabler:handleKeyreleased("lshift")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")

        if modifiedKeyReleased == "shiftleft" then
            print("PASSED => Test #3: Release shift key + left equals release shiftleft")
        else
            print("FAILED => Test #3: Release shift key + left does NOT equal release shiftleft. (Result was " .. modifiedKeyReleased .. ")")
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

        self.modKeyEnabler:reset()
        
        self.modKeyEnabler:handleKeypressed("lshift")
        self.modKeyEnabler:handleKeyreleased("lshift")
        
        local modifiedKeyPressed  = self.modKeyEnabler:prehandleKeypressed("left")
        local modifiedKeyReleased = self.modKeyEnabler:prehandleKeyreleased("left")

        if modifiedKeyPressed == "left" and modifiedKeyReleased == "left" then
            print("PASSED => Test #4: Independently pressing and releasing shift and left results in left pressed & released")
        else
            print("FAILED => Test #4: Independently pressing and releasing shift and left does NOT result in left pressed & released")
        end
    end,
}
