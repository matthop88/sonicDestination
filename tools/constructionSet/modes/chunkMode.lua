return {
	create = function(self, chunksManager, chunkMap)
		local CHUNKS_MANAGER = chunksManager
		local CHUNK_MAP      = chunkMap

		return {
			draw = function(self, GRAFX)
				CHUNK_MAP:drawMouseChunk(GRAFX) 
			end,

			isModeKey = function(self, key)
				return key == "c"
			end,

			handleKeypressed = function(self, key)
				if     key == "tab"            then CHUNKS_MANAGER:nextChunk()
				elseif key == "shifttab"       then CHUNKS_MANAGER:prevChunk()
				elseif key == "space"          then print(CHUNKS_MANAGER:chunkIndex())
				elseif key == "optiontab"      then CHUNKS_MANAGER:nextBank()
				elseif key == "shiftoptiontab" then CHUNKS_MANAGER:prevBank()
				end
			end,

			handleMousepressed = function(self, GRAFX, mx, my)
				CHUNK_MAP:placeChunk(GRAFX, mx, my)
    		end,
		}
	end,
}
