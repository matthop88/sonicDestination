return ({
	library = {},

    init = function(self)
        return self:addChunks("ghzChunks")
                   :addChunks("scdPtpChunks")
				   :addChunks("scdPtpChunksOrig")
                   :addChunks("scdCCPastChunksOrig")
    end,

	addChunks = function(self, chunksName)
		self.library[chunksName] = { chunks = nil, solids = nil, data = nil,
            init = function(self)
                local CHUNKS_PATH = relativePath("resources/zones/chunks/" .. chunksName .. ".lua")
                local CHUNKS_IMG, CHUNKS_DATA = requireRelative("world/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
            
                self.chunks = requireRelative("world/terrain/chunksBuilder"):create(CHUNKS_IMG, chunksName)
                self.solids = requireRelative("world/terrain/solidsBuilder"):create(CHUNKS_DATA)
                self.data   = CHUNKS_DATA
                self.init   = nil
            end, }

        return self
    end,

    getChunkInfo = function(self, chunksName)
        local chunkInfo = self.library[chunksName]
        if chunkInfo and chunkInfo.init then
            chunkInfo:init()
        end
        return chunkInfo
    end,

    getChunks = function(self, chunksName)
    	local chunkInfo = self:getChunkInfo(chunksName)
    	if chunkInfo then return chunkInfo.chunks end
    end,

    getSolids = function(self, chunksName)
    	local chunkInfo = self:getChunkInfo(chunksName)
        if chunkInfo then return chunkInfo.solids end
    end,

    getData = function(self, chunksName)
        local chunkInfo = self:getChunkInfo(chunksName)
        if chunkInfo then return chunkInfo.data end
    end,
}):init()
