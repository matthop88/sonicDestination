return ({
	library = {},

    init = function(self)
        return self:addChunks("ghzChunks")
                   :addChunks("scdPtpChunks")
    end,

	addChunks = function(self, chunksName)
		local CHUNKS_PATH = "game/resources/zones/chunks/" .. chunksName .. ".lua"
        local CHUNKS_IMG, CHUNKS_DATA = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
                
        local chunks = requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG, chunksName)
        local solids = requireRelative("world/terrain/solidsBuilder"):create(CHUNKS_DATA)

        self.library[chunksName] = { chunks = chunks, solids = solids }

        return self
    end,

    getChunks = function(self, chunksName)
    	local obj = self.library[chunksName]
    	if obj then return obj.chunks end
    end,

    getSolids = function(self, chunksName)
    	local obj = self.library[chunksName]
    	if obj then return obj.solids end
    end,
}):init()
