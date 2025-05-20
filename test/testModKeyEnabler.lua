require "test/delayTests"

TESTS = {
    modKeyEnabler = require "plugins/modules/modKeyEnabler",

    runAll = function(self)
        print("\nRunning Tests\n-------------")
    
        self:testShiftKeyPressedNoEvent()
        self:testLeftShiftKeyPressed()
        self:testLeftShiftKeyReleased()

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
end
