return {
    --[[
    Mod Key Enabler is designed to generate more specific key events
    based upon a key being pressed while a modifier key is down.
    
    For example, an uppercase A is written with a shift keypress and
    an 'a' keypress. Both of these are ordinarily separate events.
    However, if the shift is held down, this manager should
    transmit an 'A' keypressed key.
    
    A shift keypress can be either an 'lshift' or an 'rshift'.

    Examples:
    SHIFT LEFT
    ----------
    'lshift' is pressed  -> no event is transmitted.
    'left'   is pressed  -> if shift is held, 'shiftleft' keypress is transmitted.
    'left'   is released -> 'shiftleft' keyrelease is transmitted,
                            regardless of status of shift
    --]]

    --------------------------------------------------------------
    --                     Member Variables                     --
    --------------------------------------------------------------
    
    keys = { 
        pressed = { },
    
        shiftKeyDown = false,

        shiftDown   = function(self)      self.shiftKeyDown = true        end,
        shiftUp     = function(self)      self.shiftKeyDown = false       end,
        isShiftDown = function(self)      return self.shiftKeyDown        end,
        isDown      = function(self, key) return self.pressed[key] ~= nil end,
        
        press = function(self, key)
            local keyValue = key
            if self:isShiftDown() then 
                keyValue = self:applyShift(key)
            end
            self.pressed[key] = keyValue
            return keyValue
        end,

        applyShift = function(self, key)
            if     key == "left"  then return "shiftleft"
            elseif key == "right" then return "shiftright"
            else                       return key      end
        end,

        release = function(self, key)
            local keyValue = self:getValue(key)
            self.pressed[key] = false
            return keyValue
        end,

        getValue = function(self, key)
            return self.pressed[key]
        end,
    },
    
    -- ...
    -- ...

    --------------------------------------------------------------
    --                 LOVE2D Delegated Functions               --
    --------------------------------------------------------------

    handleKeypressed = function(self, key)
        if self:isShift(key) then
            self.keys:shiftDown()
            return true
        end
    end,

    handleKeyreleased = function(self, key)
        if self:isShift(key) then
            self.keys:shiftUp()
            return true
        end
    end,
    
    --------------------------------------------------------------
    --                  Called by Plugin Engine                 --
    --------------------------------------------------------------
    
    prehandleKeypressed  = function(self, key)
        if  self:isShift(key) then return key
        else                       return self.keys:press(key) end
    end,
    
    prehandleKeyreleased = function(self, key)
        if  self:isShift(key) then return key
        else                       return self.keys:release(key) end
    end,

    isShift = function(self, key)
        return key == "lshift" or key == "rshift"
    end,
}
