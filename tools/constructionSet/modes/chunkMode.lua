return {
	create = function(self, chunkMap)
		local CHUNK_MAP = chunkMap

		return {
			draw = function(self, GRAFX)
				CHUNK_MAP:drawMouseChunk(GRAFX) 
			end,

			isModeKey = function(self, key)
				return key == "c"
			end,

			handleKeypressed = function(self, key)
				if     key == "tab"      then CHUNK_MAP:incrementChunk()
				elseif key == "shifttab" then CHUNK_MAP:decrementChunk()
				elseif key == "space"    then CHUNK_MAP:printChunkIndex()
				end
			end,

			handleMousepressed = function(self, GRAFX, mx, my)
				CHUNK_MAP:placeChunk(GRAFX, mx, my)
    		end,
		}
	end,
}
