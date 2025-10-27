return {
	debugCmds      = {},
	debugToggleKey = "!",
	debugMode      = false,
	onDebugOn      = function() print("Debug Mode On")  end,
	onDebugOff     = function() print("Debug Mode Off") end,

	init   = function(self, params)
        self.debugCmds      = params.cmds
        self.debugToggleKey = params.debugToggleKey or self.debugToggleKey
        self.onDebugOn      = params.onDebugOn      or self.onDebugOn
        self.onDebugOff     = params.onDebugOff     or self.onDebugOff
        return self
    end,

    handleKeypressed = function(self, key)
    	if key == self.debugToggleKey then
    		self.debugMode = not self.debugMode
    		if self.debugMode == true then self.onDebugOn()
    		else                           self.onDebugOff() end
    	elseif self.debugMode == true then
    		for _, cmd in pairs(self.debugCmds) do
    			if cmd.key == key then 
    				cmd.fn() 
    				return true
    			end
    		end
    	end
    end,
    
}
