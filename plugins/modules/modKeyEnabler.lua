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
        if key == "lshift" or key == "rshift" then
            -- Consume the event
            self.isDown.shift = true
            return true
        end
    end,

    handleKeyreleased = function(self, key)
        if key == "lshift" or key == "rshift" then
            -- Consume the event
            self.isDown.shift = false
            return true
        end
    end,
    
    --------------------------------------------------------------
    --                  Called by Plugin Engine                 --
    --------------------------------------------------------------
    
    prehandleKeypressed  = function(self, key)
        -- code for preprocessing keypressed events goes here
        -- return keyToTransmit
        if self.isDown.shift and key == "left" then
            key = "shiftleft"
        end
        
        return key
    end,
    
    prehandleKeyreleased = function(self, key)
        -- code for preprocessing keyreleased events goes here
        -- return keyToTransmit
        
        return key
    end,
}
