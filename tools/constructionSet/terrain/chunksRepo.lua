return {
	chunks = {},

	get = function(self, name)
		local result = self.chunks[name]

		if result == nil then
			result = self:register(name)
		end

		return result
	end,

	register = function(self, name)
		local fullPath   = "game/resources/zones/chunks/" .. name .. ".lua"
		local chunksInfo = require("tools/constructionSet/terrain/chunkImageBuilder"):create(fullPath)
        local chunks     = require("tools/constructionSet/terrain/chunksBuilder"):create(chunksInfo.image, chunksInfo.size, name) 
        
        self.chunks[name] = chunks
        return chunks
	end,
}
