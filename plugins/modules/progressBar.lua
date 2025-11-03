local CALLBACK

local FONT_SIZE      = 40
local FONT           = love.graphics.newFont(FONT_SIZE)
local MESSAGE        = "Executing Task..."
local Y_COORD        = nil

return {
    time = 0,
    progress = 0.0,
    alpha = 0.0,
            
    init = function(self, params)
        params = params or {}
        CALLBACK = params.callback
        MESSAGE  = params.message or MESSAGE
        Y_COORD  = params.y

        return self
    end,

    draw = function(self)
        local width  = love.graphics.getWidth()
        local height = love.graphics.getHeight()
        local y = Y_COORD or height / 2
        if self.progress ~= 0 and self.alpha > 0.0 then
            love.graphics.setColor(0, 0, 0, self.alpha * 0.5)
            love.graphics.rectangle("fill", 90, y - 80, width - 180, 120)
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line", 100, y - 20, width - 200, 40)
            for x = 103, 103 + ((width - 206) * self.progress) do
                local gValue = 0.5 + math.sin((self.time * 5) + ((x - 103) / (width - 206) * 15)) * 0.5
                love.graphics.setColor(1, 1 - gValue, 0, self.alpha)
                love.graphics.rectangle("fill", x, y - 18, 1, 36)
            end
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.setFont(FONT)
            love.graphics.printf(MESSAGE, 0, y - 70, width, "center")
        end
    end,

    update = function(self, dt)
        if CALLBACK then
            self.progress = math.max(self.progress, CALLBACK())
        end
        self.time = self.time + (1 * dt)
        self:updateFade(dt)
    end,

    updateFade = function(self, dt)
        if self.progress == 1 then
            self.alpha = math.max(0, self.alpha - (1 * dt))
        elseif self.progress > 0 then
            self.alpha = math.min(1, self.alpha + (2 * dt))
        end
    end,
    
}
