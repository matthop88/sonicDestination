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

return {
    init = function(self)
        printToREADOUT = function(msg)
            self:printMessage(msg)
        end

        return self
    end,
    
    message    = {
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
    },

    timer      = TOTAL_DURATION,
    yOffset    = 0,

    getTimeElapsed = function(self)     
        return self.timer                  
    end,
    
    getTimeRemaining = function(self)  
        return TOTAL_DURATION - self.timer 
    end,

    draw = function(self)
        if self.message:exists() then
            self:drawBox()
            self.message:draw(WINDOW_HEIGHT - self.yOffset + 10)
        end
    end,
    
    drawBox = function(self)
        love.graphics.setColor(BOX_COLOR)
        love.graphics.rectangle("fill", HORIZ_MARGINS, WINDOW_HEIGHT - self.yOffset, WINDOW_WIDTH - (HORIZ_MARGINS * 2), BOX_HEIGHT)
    
        love.graphics.setLineWidth(1)
        love.graphics.setColor(BORDER_COLOR)
        love.graphics.rectangle("line", HORIZ_MARGINS, WINDOW_HEIGHT - self.yOffset, WINDOW_WIDTH - (HORIZ_MARGINS * 2), BOX_HEIGHT) 
    end,

    update = function(self, dt)
        if self:isActive() then
            self:updateTimer(dt)
        end
        self.yOffset = self:calculateYOffset()
        self.message:update(dt)
    end,

    isActive = function(self)     
        return self:getTimeElapsed() < TOTAL_DURATION 
    end,

    updateTimer = function(self, dt) 
        self.timer = self.timer + (60 * dt)                
    end,

    calculateYOffset = function(self)
        if     self:isAttacking() then return self:calculateAttackingYOffset()
        elseif self:isDecaying()  then return self:calculateDecayingYOffset()
        else                           return self:calculateSustainingYOffset()  
        end
    end,

    isAttacking = function(self)
        return self:getTimeElapsed() <= ATTACK   
    end,
    
    isDecaying = function(self)  
        return self:getTimeRemaining() <= DECAY    
    end,

    calculateAttackingYOffset = function(self)  
        return self:getTimeElapsed() / ATTACK * AMPLITUDE 
    end,
    
    calculateDecayingYOffset = function(self)
        return self:getTimeRemaining() / DECAY  * AMPLITUDE 
    end,
    
    calculateSustainingYOffset = function(self) 
        return AMPLITUDE
    end,
    
    printMessage = function(self, msg)
        self.message:set(msg)
        if self:isActive() then 
            self.message:maximizeLetterCount()
        end
    
        self:resetTimer()
    end,
    
    resetTimer = function(self)
        if not self:isActive() or self:isDecaying() then self.timer = 0
        else                                             self.timer = ATTACK
        end
    end,
}
