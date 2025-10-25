local SHIFT_KEY_TRANSFORMER = require("plugins/libraries/shiftKeyTransformer")

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
    
        shiftKeyDown   = false,
        optionKeyDown  = false,
        commandKeyDown = false,

        shiftDown     = function(self)      self.shiftKeyDown   = true       end,
        shiftUp       = function(self)      self.shiftKeyDown   = false      end,
        optionDown    = function(self)      self.optionKeyDown  = true       end,
        optionUp      = function(self)      self.optionKeyDown  = false      end,
        commandDown   = function(self)      self.commandKeyDown = true       end,
        commandUp     = function(self)      self.commandKeyDown = false      end,
        
        isCommandDown = function(self)      return self.commandKeyDown       end,
        isShiftDown   = function(self)      return self.shiftKeyDown         end,
        isOptionDown  = function(self)      return self.optionKeyDown        end,
        isDown        = function(self, key) return self.pressed[key] ~= nil  end,
        getValue      = function(self, key) return self.pressed[key]         end,
        
        press = function(self, key)
            if self:isShiftDown()  then self.pressed[key] = self:applyShift(key)
            else                        self.pressed[key] = key             end

            if self:isOptionDown() then
                self.pressed[key] = self:applyOption(self.pressed[key])
            end

            if self:isCommandDown() then
                self.pressed[key] = self:applyCommand(self.pressed[key])
            end
            
            return self.pressed[key]
        end,

        applyShift = function(self, key)
            if string.len(key) == 1 then return SHIFT_KEY_TRANSFORMER:transformShiftedKey(key)
            else                         return "shift" .. key                             end
        end,

        applyOption = function(self, key)
            return "option" .. key
        end,

        applyCommand = function(self, key)
            return "command" .. key
        end,

        release = function(self, key)
            local keyValue = self:getValue(key)
            self.pressed[key] = false
            return keyValue
        end,

        reset = function(self)
            self.pressed = { }
            self.shiftKeyDown = false
        end,
    },
    
    --------------------------------------------------------------
    --                 LOVE2D Delegated Functions               --
    --------------------------------------------------------------

    handleKeypressed = function(self, key)
        if self:isShift(key) then
            self.keys:shiftDown()
            return true
        elseif self:isOption(key) then
            self.keys:optionDown()
            return true
        elseif self:isCommand(key) then
            self.keys:commandDown()
            return true
        end
    end,

    handleKeyreleased = function(self, key)
        if self:isShift(key) then
            self.keys:shiftUp()
            return true
        elseif self:isOption(key) then
            self.keys:optionUp()
            return true
        elseif self:isCommand(key) then
            self.keys:commandUp()
            return true
        end
    end,
    
    --------------------------------------------------------------
    --                  Called by Plugin Engine                 --
    --------------------------------------------------------------
    
    prehandleKeypressed  = function(self, key)
        if  self:isModifier(key) then return key
        else                          return self.keys:press(key) end
    end,
    
    prehandleKeyreleased = function(self, key)
        if  self:isModifier(key) then return key
        else                          return self.keys:release(key) end
    end,

    --------------------------------------------------------------
    --                   Specialized Functions                  --
    --------------------------------------------------------------

    reset      = function(self)      self.keys:reset()                              end,
    isModifier = function(self, key) return self:isShift(key) or self:isOption(key) end,
    isShift    = function(self, key) return key == "lshift"   or key == "rshift"    end,
    isOption   = function(self, key) return key == "lalt"     or key == "ralt"      end,
    isCommand  = function(self, key) return key == "lgui"     or key == "rgui"      end,
}
