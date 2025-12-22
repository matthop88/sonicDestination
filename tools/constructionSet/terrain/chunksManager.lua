return {
	chunkBanks = {},

	register = function(self, path)
		local fullPath = "game/resources/zones/chunks/" .. path .. ".lua"
		local chunksInfo = require("tools/constructionSet/terrain/chunkImageBuilder"):create(fullPath)
        local chunks     = require("tools/constructionSet/terrain/chunksBuilder"):create(chunksInfo.image) 
            
        table.insert(self.chunkBanks, chunks)

        return chunks 
	end,
}
