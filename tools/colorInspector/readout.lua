require "tools/colorInspector/color"

local FONT_SIZE      = 40
local FONT           = love.graphics.newFont(FONT_SIZE)
local SUSTAIN        = 180
local ATTACK         = 8
local DECAY          = 24
local TOTAL_DURATION = SUSTAIN + ATTACK + DECAY
local AMPLITUDE      = 90
local BOX_HEIGHT     = 70
local HORIZ_MARGINS  = 30

local BOX_COLOR      = COLOR.TRANSPARENT_BLACK
local BORDER_COLOR   = COLOR.PURE_WHITE
local TEXT_COLOR     = COLOR.PURE_WHITE

local message    = {
    text = nil,

    get    = function(self)    return self.text        end,
    set    = function(self, t) self.text = t           end,
    exists = function(self)    return self.text ~= nil end,
}

local timer      = TOTAL_DURATION
local yOffset    = 0

function getTimeElapsed()     return timer                  end
function getTimeRemaining()   return TOTAL_DURATION - timer end

function drawReadout()
    if message:exists() then
        drawBox()
        drawMessage()
    end
end

function drawBox()
    love.graphics.setColor(BOX_COLOR)
    love.graphics.rectangle("fill", HORIZ_MARGINS, WINDOW_HEIGHT - yOffset, WINDOW_WIDTH - (HORIZ_MARGINS * 2), BOX_HEIGHT)

    love.graphics.setColor(BORDER_COLOR)
    love.graphics.rectangle("line", HORIZ_MARGINS, WINDOW_HEIGHT - yOffset, WINDOW_WIDTH - (HORIZ_MARGINS * 2), BOX_HEIGHT) 
end

function drawMessage()
    love.graphics.setColor(TEXT_COLOR)
    love.graphics.setFont(FONT)
    love.graphics.printf(message:get(), 0, WINDOW_HEIGHT - yOffset + 10, WINDOW_WIDTH, "center")
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
    message:set(msg)
    resetTimer()
end

function resetTimer()
    if not isActive() or isDecaying() then timer = 0
    else                                   timer = ATTACK
    end
end
