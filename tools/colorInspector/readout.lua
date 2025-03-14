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
local SHADOW_COLOR   = COLOR.JET_BLACK

local MAX_LETTERS_PER_SECOND = 600000
    
local message    = {
    text             = nil,
    letterCount      = 0,
    lettersPerSecond = MAX_LETTERS_PER_SECOND,
    isDrawShadow     = false,
    
    get    = function(self)    
        if self.letterCount < 1 then return ""
        else                         return string.sub(self.text, 1, self.letterCount)
        end
    end,

    set    = function(self, t) 
        self.text      = t
        self.textWidth = FONT:getWidth(t)
        self.leftX     = (WINDOW_WIDTH - self.textWidth) / 2 
        self:resetLetterCount()   
    end,
    
    exists = function(self)    
        return self.text ~= nil 
    end,

    draw = function(self, y)
        if self.isDrawShadow then
            self:drawShadow(y)
        end
        self:drawText(y)
    end,

    drawShadow = function(self, y)
        love.graphics.setColor(SHADOW_COLOR)
        love.graphics.printf(self:get(), self.leftX - 5, y + 5, self.textWidth, "left")
        love.graphics.printf(self:get(), self.leftX - 3, y + 3, self.textWidth, "left")
        love.graphics.printf(self:get(), self.leftX - 1, y + 1, self.textWidth, "left")
    end,

    drawText = function(self, y)
        love.graphics.setFont(FONT)
        love.graphics.setColor(TEXT_COLOR)
        love.graphics.printf(self:get(), self.leftX, y, self.textWidth, "left")
    end,

    update = function(self, dt)
        self.letterCount = self.letterCount + (dt * self.lettersPerSecond)
    end,

    resetLetterCount = function(self)
        self.letterCount = -math.sqrt(self.lettersPerSecond)
    end,

    maximizeLetterCount = function(self)
        self.letterCount = string.len(self.text)
    end,
}

local timer      = TOTAL_DURATION
local yOffset    = 0

function getTimeElapsed()     return timer                  end
function getTimeRemaining()   return TOTAL_DURATION - timer end

function drawReadout()
    if message:exists() then
        drawBox()
        message:draw(WINDOW_HEIGHT - yOffset + 10)
    end
end

function drawBox()
    love.graphics.setColor(BOX_COLOR)
    love.graphics.rectangle("fill", HORIZ_MARGINS, WINDOW_HEIGHT - yOffset, WINDOW_WIDTH - (HORIZ_MARGINS * 2), BOX_HEIGHT)

    love.graphics.setColor(BORDER_COLOR)
    love.graphics.rectangle("line", HORIZ_MARGINS, WINDOW_HEIGHT - yOffset, WINDOW_WIDTH - (HORIZ_MARGINS * 2), BOX_HEIGHT) 
end

function updateReadout(dt)
    if isActive() then
        updateTimer(dt)
    end
    yOffset = calculateYOffset()
    message:update(dt)
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
    if isActive() then 
        message:maximizeLetterCount()
    end

    resetTimer()
end

function resetTimer()
    if not isActive() or isDecaying() then timer = 0
    else                                   timer = ATTACK
    end
end
