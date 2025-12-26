local KEYS = { "A", "B", "C", "D", "E", "F", "G", "H" }

return {
	chunks    = {},
	count     = 0,
	chunkVars = {},

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
        self.count = self.count + 1
        self.chunkVars[name] = KEYS[self.count]
        return chunks
	end,

	getVar = function(self, chunkName)
		return self.chunkVars[chunkName]
	end,

	getVarMap = function(self)
		return self.chunkVars
	end,
}
