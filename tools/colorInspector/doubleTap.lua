local DOUBLE_TAP_THRESHOLD = 0.2

local lastKeypressed       = nil
local lastKeypressedTime   = 0

function isDoubleTap(key)
    return lastKeypressed == key and getTimeElapsedSinceLastKeypress() < DOUBLE_TAP_THRESHOLD
end

function getTimeElapsedSinceLastKeypress()
    return love.timer.getTime() - lastKeypressedTime
end

function isWithinDoubleTapThreshold()
    return getTimeElapsedSinceLastKeypress() <= DOUBLE_TAP_THRESHOLD
end

function setLastKeypressed(key)
    lastKeypressed     = key 
    lastKeypressedTime = love.timer.getTime()
end
