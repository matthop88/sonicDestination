return {
	create = function(self, params)
		local CHUNK_ARTIST = params.chunkArtist
		local CHUNK_ID     = params.chunkID
		local CHUNK_X      = params.chunkX
		local CHUNK_Y      = params.chunkY
		local FROM_TILE_ID = params.fromTileID
		local TO_TILE_ID   = params.toTileID

		return {
			execute = function(self)
				CHUNK_ARTIST:setTileID(TO_TILE_ID, CHUNK_ID, CHUNK_X, CHUNK_Y)			
    		end,
			
			undo    = function(self)
				CHUNK_ARTIST:setTileID(FROM_TILE_ID, CHUNK_ID, CHUNK_X, CHUNK_Y)
			end,
		}
	end,
}
