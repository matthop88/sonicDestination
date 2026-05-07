return {
    keypressedFn    = nil,
    keyreleasedFn   = nil,
    mousepressedFn  = nil,
    mousereleasedFn = nil,
    active          = false,

    init     = function(self, parameters)
        self.keypressedFn    = parameters.keypressedFn
        self.keyreleasedFn   = parameters.keyreleasedFn
        self.mousepressedFn  = parameters.mousepressedFn
        self.mousereleasedFn = parameters.mousereleasedFn
        self.active          = parameters.active
        return self
    end,

    handleKeypressed = function(self, key)
        if self.keypressedFn and self.active then 
            return self.keypressedFn(key) 
        end
    end,

    handleKeyreleased = function(self, key)
        if self.keyreleasedFn and self.active then 
            return self.keyreleasedFn(key) 
        end
    end,

    handleMousepressed = function(self, mx, my, params)
        if self.mousepressedFn and self.active then 
            return self.mousepressedFn(mx, my, params) 
        end
    end,

    handleMousereleased = function(self, mx, my)
        if self.mousereleasedFn and self.active then 
            return self.mousereleasedFn(mx, my) 
        end
    end,

    activate   = function(self) self.active = true  end,
    deactivate = function(self) self.active = false end,
}
