require "test/delayTests"

local modKeyEnabler = require "plugins/modules/modKeyEnabler"

function runTests()
    -- Test #1
    -- When shift key is pressed (lshift or rshift), no event is transmitted
    
    print("\nRunning Tests\n-------------")
    
    local lshiftResult = modKeyEnabler:prehandleKeypressed("lshift")
    local rshiftResult = modKeyEnabler:prehandleKeypressed("rshift")
    
    if lshiftResult == true and rshiftResult == true then
        print("PASSED => Test #1: lshift and rshift keypressed were consumed by modKeyEnabler")
    else
        print("FAILED => Test #1: lshift and rshift keypressed were NOT consumed by modKeyEnabler")
    end

    -- Test #2
    -- When shift key is pressed followed by "left",
    --      "shiftleft" keypressed event is transmitted
    
    love.event.quit()
end
