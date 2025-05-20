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
    
    isDown = { },
    -- ...
    -- ...

    --------------------------------------------------------------
    --                 LOVE2D Delegated Functions               --
    --------------------------------------------------------------

    handleKeypressed = function(self, key)
        if self:isShift(key) then
            -- Consume the event
            self.isDown.shift = true
            return true
        end
    end,

    handleKeyreleased = function(self, key)
        if self:isShift(key) then
            -- Consume the event
            self.isDown.shift = false
            return true
        end
    end,
    
    --------------------------------------------------------------
    --                  Called by Plugin Engine                 --
    --------------------------------------------------------------
    
    prehandleKeypressed  = function(self, key)
        if     self:isShift(key) then return key
        elseif self.isDown.shift then self.isDown[key] = self:applyShift(key)
        else                          self.isDown[key] = key
        end
        
        return self.isDown[key]
    end,
    
    prehandleKeyreleased = function(self, key)
        if self:isShift(key) then 
            return key
        else
            key = self.isDown[key]
            self.isDown[key] = false
            return key
        end
    end,

    isShift = function(self, key)
        return key == "lshift" or key == "rshift"
    end,
        
    applyShift = function(self, key)
        if     key == "left"  then return "shiftleft"
        elseif key == "right" then return "shiftright"
        else                       return key
        end
    end,
}
