require "test/delayTests"

local modKeyEnabler = require "plugins/modules/modKeyEnabler"

function runTests()
    -- Test #1
    -- When shift key is pressed (lshift or rshift), no event is transmitted
    
    print("\nRunning Tests\n-------------")
    
    local lshiftResult = modKeyEnabler:handleKeypressed("lshift")
    local rshiftResult = modKeyEnabler:handleKeypressed("rshift")
    
    if lshiftResult == true and rshiftResult == true then
        print("PASSED => Test #1: lshift and rshift keypressed were consumed by modKeyEnabler")
    else
        print("FAILED => Test #1: lshift and rshift keypressed were NOT consumed by modKeyEnabler")
    end

    -- Test #2
    -- When shift key is pressed followed by "left",
    --      "shiftleft" keypressed event is transmitted

    modKeyEnabler:handleKeypressed("lshift")
    local modifiedKey = modKeyEnabler:prehandleKeypressed("left")

    if modifiedKey == "shiftleft" then
        print("PASSED => Test #2: shift key + left equals shiftleft")
    else
        print("FAILED => Test #2: shift key + left does not equal shiftleft. (Result was " .. modifiedKey .. ")")
    end

    -- Test #3
    -- When this sequence of events occurs, results should match:
    --      keypressed:  shiftKey
    --      keypressed:  "left"     => keypressed:  "shiftleft"
    --      keyreleased: shiftKey
    --      keyreleased: "left"     => keyreleased: "shiftleft"

    modKeyEnabler:handleKeyreleased("lshift")
    local modifiedKeyReleased = modKeyEnabler:prehandleKeyreleased("left")

    if modifiedKeyReleased == "shiftleft" then
        print("PASSED => Test #3: Release shift key + left equals release shiftleft")
    else
        print("FAILED => Test #3: Release shift key + left does NOT equal release shiftleft. (Result was " .. modifiedKeyReleased .. ")")
    end
    
    love.event.quit()
end
