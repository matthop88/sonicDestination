require "tools/colorInspector/doubleTap"

local SCROLL_SPEED   = 400

SCROLLING = {
    xSpeed  = 0,   
    ySpeed  = 0,
    dashing = false,

    handleScrollKeypressed = function(self, key)
        self.dashing = isDoubleTap(key)
        
        if     key == "left"  then self:scrollLeft()
        elseif key == "right" then self:scrollRight()
        elseif key == "up"    then self:scrollUp()
        elseif key == "down"  then self:scrollDown()
        end
    
        setLastKeypressed(key)
    end,

    handleScrollKeyreleased = function(self, key)
        if     key == "left"  then self:stopScrollingLeft()
        elseif key == "right" then self:stopScrollingRight()
        elseif key == "up"    then self:stopScrollingUp()
        elseif key == "down"  then self:stopScrollingDown()
        end
    end,
    
    updateScrolling = function(self, dt)
        IMAGE_VIEWER:moveImage(self.xSpeed * dt, self.ySpeed * dt)
    end,
    
    scrollLeft         = function(self) self.xSpeed =   self:calculateScrollSpeed()  end,
    scrollRight        = function(self) self.xSpeed = -(self:calculateScrollSpeed()) end,
    scrollUp           = function(self) self.ySpeed =   self:calculateScrollSpeed()  end,
    scrollDown         = function(self) self.ySpeed = -(self:calculateScrollSpeed()) end,
      
    stopScrollingLeft  = function(self) self.xSpeed = math.min(0, self.xSpeed)       end,
    stopScrollingRight = function(self) self.xSpeed = math.max(0, self.xSpeed)       end,
    stopScrollingUp    = function(self) self.ySpeed = math.min(0, self.ySpeed)       end,
    stopScrollingDown  = function(self) self.ySpeed = math.max(0, self.ySpeed)       end,
    
    calculateScrollSpeed = function(self)
        if self:dashing then return SCROLL_SPEED * 2
        else                 return SCROLL_SPEED
        end
    end,
    
    isMotionless = function(self)
        return not isWithinDoubleTapThreshold() and self:xSpeed == 0 and self:ySpeed == 0
    end,
}

