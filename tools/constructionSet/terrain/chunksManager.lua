return {
	chunkBanks = require("tools/lib/dataStructures/navigableList"):create {},
	chunksRepo = {},

	register = function(self, path)
		local fullPath   = "game/resources/zones/chunks/" .. path .. ".lua"
		local chunksInfo = require("tools/constructionSet/terrain/chunkImageBuilder"):create(fullPath)
        local chunks     = require("tools/constructionSet/terrain/chunksBuilder"):create(chunksInfo.image) 
        local chunkList  = require("tools/constructionSet/terrain/chunkList"):create(chunks)

        self.chunkBanks:add(chunkList)
        table.insert(self.chunksRepo, chunks)

        return self 
	end,

	nextBank   = function(self)        self.chunkBanks:next()        end,
	prevBank   = function(self)        self.chunkBanks:prev()        end,
	nextChunk  = function(self)        self.chunkBanks:get():next()  end,
	prevChunk  = function(self)        self.chunkBanks:get():prev()  end,
	chunkIndex = function(self) return self.chunkBanks:get():index() end,
	bankIndex  = function(self) return self.chunkBanks:index()       end,
	
	get       = function(self, n)
		if n then return self.chunkBanks:get():get(n)
		else      return self.chunkBanks:get():get()  end
	end,

	getChunksRepo = function(self) return self.chunksRepo end,

}
