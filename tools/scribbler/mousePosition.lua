local IDLE_TIMER_MAX = 120

return ({
    idleTimer = IDLE_TIMER_MAX,
        
    init = function(self)
        self.x,     self.y     = love.mouse.getPosition()
        self.prevX, self.prevY = self.x, self.y
        return self
    end,

    isIdle = function(self)
        return self.idleTimer <= 0
    end,
        
    isChanged = function(self)
        local x, y = self:get()
        return x ~= self.prevX or y ~= self.prevY
    end,

    update = function(self, dt)
        self.prevX, self.prevY = self:get()
        self.x,     self.y     = love.mouse.getPosition()
            
        if self:isChanged() then self:resetIdle()
        else                     self.idleTimer = self.idleTimer - (60 * dt)  end
    end,

    resetIdle = function(self)
        self.idleTimer = IDLE_TIMER_MAX
    end,

    get = function(self)
        if love.keyboard.isDown("lshift", "rshift") then
            return math.floor(self.x / 32) * 32,
                   math.floor(self.y / 32) * 32
        else
            return self.x, self.y
        end
    end,
        
}):init()
