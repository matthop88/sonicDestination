DEFAULT_DELAY    = 1
DEFAULT_INTERVAL = 1

return {
    --[[
    Key Repeat is designed to generate frequent key events when
    a non-modifier key is held down.
    
    Two factors that can be customized are:
    Delay    - the amount of time a key must be held down before repeat is repeatedly called.
    Interval - how much time occurs between key presses generated.
    
    Note: a LOVE2D keypressed and keyreleased event are both generated sequentially as a result of this.
    --]]

    delay      = nil,
    interval   = nil,

    pressedKey = {
        value    = nil,
        duration = 0,

        get    = function(self)      return self.value        end,
        set    = function(self, key) self.value = key         end,
        equals = function(self, key) return self.value == key end,

        reset = function(self)
            self.value    = nil
            self.duration = 0
        end,

        update = function(self, dt)
            if self.value ~= nil then
                self.duration = self.duration + dt
            end
        end,

        getHoldTime = function(self)
            return self.duration
        end,

    },
    
    init   = function(self, params)
        self.delay    = params.delay    or DEFAULT_DELAY
        self.interval = params.interval or DEFAULT_INTERVAL
        
        return self
    end,

    --------------------------------------------------------------
    --                 LOVE2D Delegated Functions               --
    --------------------------------------------------------------

    update = function(self, dt)
        self.pressedKey:update(dt)
        if self.pressedKey:getHoldTime() > self.delay then
            print("Holding key '" .. self.pressedKey:get() .. "' for " .. self.pressedKey:getHoldTime() .. " seconds")
        end
    end,

    handleKeypressed = function(self, key)
        if not self:isModifier(key) then self.pressedKey:set(key) end 
    end,

    handleKeyreleased = function(self, key)
        if self.pressedKey.value == key then self.pressedKey:reset() end
    end,

    --------------------------------------------------------------
    --                   Specialized Functions                  --
    --------------------------------------------------------------

    isModifier = function(self, key) 
        return self:isShift(key) or self:isOption(key) or self:isCommand(key) 
    end,

    isCommand  = function(self, key) return key == "lgui"     or key == "rgui"      end,
    isShift    = function(self, key) return key == "lshift"   or key == "rshift"    end,
    isOption   = function(self, key) return key == "lalt"     or key == "ralt"      end,
}
