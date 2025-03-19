require "tools/colorInspector/doubleTap"

local SCROLL_SPEED   = 400

return {
    xSpeed  = 0,   
    ySpeed  = 0,
    dashing = false,

    handleKeypressed = function(self, key)
        self.dashing = isDoubleTap(key)
        
        if     key == "left"  then self:startLeft()
        elseif key == "right" then self:startRight()
        elseif key == "up"    then self:startUp()
        elseif key == "down"  then self:startDown()
        end
    
        setLastKeypressed(key)
    end,

    handleKeyreleased = function(self, key)
        if     key == "left"  then self:stopLeft()
        elseif key == "right" then self:stopRight()
        elseif key == "up"    then self:stopUp()
        elseif key == "down"  then self:stopDown()
        end
    end,
    
    update = function(self, dt)
        getIMAGE_VIEWER():moveImage(self.xSpeed * dt, self.ySpeed * dt)
        if self:isMotionless() then
            getIMAGE_VIEWER():keepImageInBounds()
        end
    end,
    
    startLeft  = function(self) self.xSpeed =   self:calculateSpeed()  end,
    startRight = function(self) self.xSpeed = -(self:calculateSpeed()) end,
    startUp    = function(self) self.ySpeed =   self:calculateSpeed()  end,
    startDown  = function(self) self.ySpeed = -(self:calculateSpeed()) end,
      
    stopLeft   = function(self) self.xSpeed = math.min(0, self.xSpeed) end,
    stopRight  = function(self) self.xSpeed = math.max(0, self.xSpeed) end,
    stopUp     = function(self) self.ySpeed = math.min(0, self.ySpeed) end,
    stopDown   = function(self) self.ySpeed = math.max(0, self.ySpeed) end,
    
    calculateSpeed = function(self)
        if self.dashing then return SCROLL_SPEED * 2
        else                 return SCROLL_SPEED
        end
    end,
    
    isMotionless = function(self)
        return not isWithinDoubleTapThreshold() and self.xSpeed == 0 and self.ySpeed == 0
    end,
}

