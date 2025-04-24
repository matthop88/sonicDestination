return ({
    x,     y     = nil, nil,
    prevX, prevY = nil, nil,
        
    init = function(self)
        self.x,     self.y     = love.mouse.getPosition()
        self.prevX, self.prevY = self.x, self.y
        return self
    end,
        
    isChanged = function(self)
        return self.x ~= self.prevX or self.y ~= self.prevY
    end,

    update = function(self)
        self.prevX, self.prevY = self.x, self.y
        self.x,     self.y     = love.mouse.getPosition()
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
