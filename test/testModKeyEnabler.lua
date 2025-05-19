require "test/delayTests"

local modKeyEnabler = require "plugins/modules/modKeyEnabler"

function runTests()
    -- Test #1
    -- When shift key is pressed (lshift or rshift), no event is transmitted
    
    print("\nRunning Tests\n-------------")
    
    local lshiftResult = modKeyEnabler:keypressed("lshift")
    local rshiftResult = modKeyEnabler:keypressed("rshift")
    
    if lshiftResult == true and rshiftResult == true then
        print("PASSED => Test #1: lshift and rshift were consumed by modKeyEnabler")
    else
        print("FAILED => Test #1: lshift and rshift were NOT consumed by modKeyEnabler")
    end
    
    love.event.quit()
end
