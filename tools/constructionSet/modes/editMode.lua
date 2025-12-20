return {
	create = function(self, chunkMap)
		local CHUNK_MAP = chunkMap

		return {
			draw = function(self, GRAFX)
				-- do nothing 
			end,

			isModeKey = function(self, key)
				return key == "escape"
			end,

			handleKeypressed = function(self, key)
				-- do nothing
			end,

			handleMousepressed = function(self, GRAFX, mx, my)
				-- do nothing
			end,
		}
	end,
}
