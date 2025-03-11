READOUT_FONT_SIZE = 40
READOUT_FONT      = love.graphics.newFont(READOUT_FONT_SIZE)
READOUT_SUSTAIN   = 180
READOUT_ATTACK    = 10
READOUT_DECAY     = 30
READOUT_DURATION  = READOUT_SUSTAIN + READOUT_ATTACK + READOUT_DECAY
READOUT_AMPLITUDE = 140
READOUT_HEIGHT    = 70

readoutMsg        = nil
readoutTimer      = READOUT_DURATION
readoutYOffset    = 0

function getTimeElapsed()     return readoutTimer                           end
function getTimeRemaining()   return READOUT_DURATION - readoutTimer        end

function drawReadout()
    if readoutMsg ~= nil and readoutTimer ~= nil then
        drawReadoutBox()
        drawReadoutMessage()
    end
end

function drawReadoutBox()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0,  WINDOW_HEIGHT - readoutYOffset, WINDOW_WIDTH, READOUT_HEIGHT)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0,  WINDOW_HEIGHT - readoutYOffset, WINDOW_WIDTH, READOUT_HEIGHT) 
end

function drawReadoutMessage()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(READOUT_FONT)
    love.graphics.printf(readoutMsg, 0, WINDOW_HEIGHT - readoutYOffset + 10, WINDOW_WIDTH, "center")
end

function updateReadout(dt)
    if isReadoutActive() then
        updateReadoutTimer(dt)
    end
    readoutYOffset = calculateYOffset()
end

function isReadoutActive() return getTimeElapsed() < READOUT_DURATION end

function updateReadoutTimer(dt)
    readoutTimer = readoutTimer + (60 * dt)
end

function calculateYOffset()
    if     isReadoutAttacking() then
        return calculateAttackingYOffset()
    elseif isReadoutDecaying()  then
        return calculateDecayingYOffset()
    else
        return calculateSustainingYOffset()  
    end
end

function isReadoutAttacking() return getTimeElapsed()   <= READOUT_ATTACK   end
function isReadoutDecaying()  return getTimeRemaining() <= READOUT_DECAY    end

function calculateAttackingYOffset()
    return getTimeElapsed()   / READOUT_ATTACK * READOUT_AMPLITUDE
end

function calculateDecayingYOffset()
    return getTimeRemaining() / READOUT_DECAY  * READOUT_AMPLITUDE
end

function calculateSustainingYOffset()
    return READOUT_AMPLITUDE
end

function printToReadout(msg)
    readoutMsg   = msg
    resetTimer()
    print("Printing to readout: ", msg)
end

function resetTimer()
    if not isReadoutActive() or isReadoutDecaying() then
        readoutTimer = 0
    else
        readoutTimer = READOUT_ATTACK
    end
end
