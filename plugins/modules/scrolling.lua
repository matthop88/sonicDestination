require "plugins/libraries/doubleTap"

local SCROLL_SPEED   = 400

return {
    xSpeed   = 0,   
    ySpeed   = 0,
    dashing  = false,
    leftKey  = "left",
    rightKey = "right",
    upKey    = "up",
    downKey  = "down",

    init = function(self, params)
        self.imageViewer = params.imageViewer
        self.leftKey     = params.leftKey  or self.leftKey
        self.rightKey    = params.rightKey or self.rightKey
        self.upKey       = params.upKey    or self.upKey
        self.downKey     = params.downKey  or self.downKey
        return self
    end,
    
    handleKeypressed = function(self, key)
        self.dashing = isDoubleTap(key)
        
        if     key == self.leftKey  then self:startLeft()  return true
        elseif key == self.rightKey then self:startRight() return true
        elseif key == self.upKey    then self:startUp()    return true
        elseif key == self.downKey  then self:startDown()  return true
        end
    
        setLastKeypressed(key)
    end,

    handleKeyreleased = function(self, key)
        if     key == self.leftKey  then self:stopLeft()   return true
        elseif key == self.rightKey then self:stopRight()  return true
        elseif key == self.upKey    then self:stopUp()     return true
        elseif key == self.downKey  then self:stopDown()   return true
        end
    end,
    
    update = function(self, dt)
        self.imageViewer:moveImage(self.xSpeed * dt, self.ySpeed * dt)
        if self:isMotionless() and self.imageViewer.keepImageInBounds then
            self.imageViewer:keepImageInBounds()
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
