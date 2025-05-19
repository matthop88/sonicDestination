function runTests()
    -- Test #1
    -- When shift key is pressed (lshift or rshift), no event is transmitted
    
    print("Test #1... testing shift key being pressed.")
    
    love.event.quit()
end

local textTimer    = 0
local waitForTests = true

function love.update(dt)
    if waitForTests then
        textTimer = textTimer + dt
        if textTimer > 1 then
            waitForTests = false
            runTests()
        end
    end
end
