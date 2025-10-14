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

    Also, an onKeyRepeat function can be customized; this will be called when the repeat sequence begins.
    --]]

    pressedKey = {
        value    = nil,
        duration = 0,

        pulse    = {
            interval            = nil,
            nextEvent           = "keypressed",
            timeOfNextEvent     = 0,

            setInterval  = function(self, interval)
                self.interval = interval - 0.01
            end,

            setDelay     = function(self, delay)
                self.delay = delay
                self.timeOfNextEvent = self.delay
            end,

            getNextEvent = function(self, timeHeld)
                if timeHeld > self.timeOfNextEvent then
                    local result = self.nextEvent

                    self:alternateEventType()
                    return result
                end
            end,  

            isJustStarting = function(self, timeHeld)
                return timeHeld > self.delay and self.timeOfNextEvent == self.delay
            end,

            alternateEventType = function(self)
                if     self.nextEvent == "keypressed"  then self:setToKeyreleasedEvent()
                elseif self.nextEvent == "keyreleased" then self:setToKeypressedEvent()  end
            end,

            setToKeypressedEvent  = function(self)
                self.nextEvent = "keypressed"
                self.timeOfNextEvent = self.timeOfNextEvent + self.interval
            end,

            setToKeyreleasedEvent = function(self)
                self.nextEvent = "keyreleased"
                self.timeOfNextEvent = self.timeOfNextEvent + 0.01
            end,

            reset = function(self)
                self.nextEvent = "keypressed"
                self.timeOfNextEvent = self.delay  
            end,  
        },

        get    = function(self)      return self.value        end,
        set    = function(self, key) self.value = key         end,
        equals = function(self, key) return self.value == key end,

        reset = function(self)
            self.value    = nil
            self.duration = 0
            self.pulse:reset()
        end,

        update = function(self, dt)
            if self.value ~= nil then 
                self.duration = self.duration + dt   
                if self.pulse:isJustStarting(self.duration) then
                    self.onKeyRepeat()
                end
                self.nextEvent = self.pulse:getNextEvent(self.duration)
            end
        end,

        getHoldTime = function(self)           return self.duration                   end,
        setDelay    = function(self, delay)    self.pulse:setDelay(delay)             end,
        setInterval = function(self, interval) self.pulse:setInterval(interval)       end,

        isSendingKeypressed  = function(self)  return self.nextEvent == "keypressed"  end,
        isSendingKeyreleased = function(self)  return self.nextEvent == "keyreleased" end,

        isStartingRepeat = function(self)  
            return self.pulse:isJustStarting(self.duration) 
        end,
        
    },
    
    init   = function(self, params)
        self.pressedKey:setDelay(params.delay or DEFAULT_DELAY)
        self.pressedKey:setInterval(params.interval or DEFAULT_INTERVAL)
        self.pressedKey.onKeyRepeat = params.onKeyRepeat or function() end
        
        return self
    end,

    --------------------------------------------------------------
    --                 LOVE2D Delegated Functions               --
    --------------------------------------------------------------

    update = function(self, dt)
        self.pressedKey:update(dt)
        if     self.pressedKey:isSendingKeypressed() then
            self:sendKeypressed(self.pressedKey:get())
        elseif self.pressedKey:isSendingKeyreleased() then
            self:sendKeyreleased(self.pressedKey:get())
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

    sendKeypressed = function(self, key)
        local isPluginDownstream = false
        for _, plugin in ipairs(self.__ENGINE) do
            if isPluginDownstream then
                if plugin.handleKeypressed ~= nil and plugin:handleKeypressed(key) then 
                    return true
                end
            end
            if plugin == self then
                isPluginDownstream = true
            end
        end
        self.__ENGINE.oldKeypressed(key)
    end,

    sendKeyreleased = function(self, key)
        local isPluginDownstream = false
        for _, plugin in ipairs(self.__ENGINE) do
            if isPluginDownstream then
                if plugin.handleKeyreleased ~= nil and plugin:handleKeyreleased(key) then 
                    return true
                end
            end
            if plugin == self then
                isPluginDownstream = true
            end
        end
        self.__ENGINE.oldKeyreleased(key)
    end,

}
