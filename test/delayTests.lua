local textTimer    = 0
local waitForTests = true

function love.update(dt)
    if waitForTests then
        textTimer = textTimer + dt
        if textTimer > 1 then
            waitForTests = false
            TESTS:runAll()
        end
    end
end
    
