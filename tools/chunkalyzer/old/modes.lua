-----------------------------------------------------------------------
--                            Assumptions                            --
--                                                                   --
--  * getReadout()     returns a reference to the Readout plugin     --
--  * printToReadout() prints a message to the Readout window        --
--                                                                   --
-----------------------------------------------------------------------

local chunkAttributes = {
	leftMost   = nil,
	topMost    = nil,
	rightMost  = nil,
	bottomMost = nil,
}

local modes

modes = {
	{	message = "Select the leftmost Chunk on the Map.",   fn = function(x, y) chunkAttributes.leftMost   = x end	},
	{	message = "Select the topMost Chunk on the Map.",    fn = function(x, y) chunkAttributes.topMost    = y end },
	{	message = "Select the rightmost Chunk on the Map.",  fn = function(x, y) chunkAttributes.rightMost  = x end	},
	{	message = "Select the bottomMost Chunk on the Map.", fn = function(x, y) chunkAttributes.bottomMost = y end },
	{   message = "Click anywhere to begin Chunkalyzing.",   
		fn      = function(x, y) 
			modes.readyToChunkalyze = true
			getReadout():setSustain(180)   
		end,
	},
	
	index = 1,

	readyToChunkalyze = false,

	isReadyToChunkalyze = function(self) return self.readyToChunkalyze      end,

	getData = function(self) return { chunkAttributes = chunkAttributes }   end,
	
	get     = function(self) return self[self.index]                        end,
	
    next  = function(self) 
        self.index = math.min(self.index + 1, #self) 
        self:refresh()
    end,

	prev  = function(self) 
        self.index = math.max(self.index - 1, 1)  
        self:refresh()   
    end,
	
    reset = function(self) 
        self.index = 1                               
        getReadout():setSustain(1800)
        self:refresh()
        self.readyToChunkalyze = false
    end,

    refresh = function(self)
        local currentMode = self:get()
        if currentMode.message then printToReadout(currentMode.message) end
    end,
}

return modes
