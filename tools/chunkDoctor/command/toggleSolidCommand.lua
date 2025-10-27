return {
	create = function(self, params)
		local CHUNK_ARTIST = params.chunkArtist
		local CHUNK_ID     = params.chunkID
		local CHUNK_X      = params.chunkX
		local CHUNK_Y      = params.chunkY
		
		return {
			execute = function(self)
				CHUNK_ARTIST:toggleSolidAt(CHUNK_ID, CHUNK_X, CHUNK_Y)	
    		end,
			
			undo    = function(self)
				CHUNK_ARTIST:toggleSolidAt(CHUNK_ID, CHUNK_X, CHUNK_Y)
			end,
		}
	end,
}
