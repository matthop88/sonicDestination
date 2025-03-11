local FONT_SIZE      = 40
local FONT           = love.graphics.newFont(FONT_SIZE)
local SUSTAIN        = 180
local ATTACK         = 10
local DECAY          = 30
local TOTAL_DURATION = SUSTAIN + ATTACK + DECAY
local AMPLITUDE      = 140
local BOX_HEIGHT     = 70

local TRANSPARENT_BLACK = { 0, 0, 0, 0.5 }
local TRANSPARENT_BLUE  = { 0, 0, 1, 0.5 }
local PURE_WHITE        = { 1, 1, 1      }

local BOX_COLOR      = TRANSPARENT_BLUE
local BORDER_COLOR   = PURE_WHITE
local TEXT_COLOR     = PURE_WHITE

local message    = nil
local timer      = TOTAL_DURATION
local yOffset    = 0

function getTimeElapsed()     return timer                  end
function getTimeRemaining()   return TOTAL_DURATION - timer end

function drawReadout()
    if message ~= nil then
        drawBox()
        drawMessage()
    end
end

function drawBox()
    love.graphics.setColor(BOX_COLOR)
    love.graphics.rectangle("fill", 0,  WINDOW_HEIGHT - yOffset, WINDOW_WIDTH, BOX_HEIGHT)

    love.graphics.setColor(BORDER_COLOR)
    love.graphics.rectangle("line", 0,  WINDOW_HEIGHT - yOffset, WINDOW_WIDTH, BOX_HEIGHT) 
end

function drawMessage()
    love.graphics.setColor(TEXT_COLOR)
    love.graphics.setFont(FONT)
    love.graphics.printf(message, 0, WINDOW_HEIGHT - yOffset + 10, WINDOW_WIDTH, "center")
end

function updateReadout(dt)
    if isActive() then
        updateTimer(dt)
    end
    yOffset = calculateYOffset()
end

function isActive()      return getTimeElapsed() < TOTAL_DURATION end

function updateTimer(dt) timer = timer + (60 * dt)                end

function calculateYOffset()
    if     isAttacking() then return calculateAttackingYOffset()
    elseif isDecaying()  then return calculateDecayingYOffset()
    else                      return calculateSustainingYOffset()  
    end
end

function isAttacking() return getTimeElapsed()   <= ATTACK   end
function isDecaying()  return getTimeRemaining() <= DECAY    end

function calculateAttackingYOffset()  return getTimeElapsed()   / ATTACK * AMPLITUDE end
function calculateDecayingYOffset()   return getTimeRemaining() / DECAY  * AMPLITUDE end
function calculateSustainingYOffset() return AMPLITUDE                               end

function printToReadout(msg)
    message = msg
    resetTimer()
end

function resetTimer()
    if not isActive() or isDecaying() then timer = 0
    else                                   timer = ATTACK
    end
end
