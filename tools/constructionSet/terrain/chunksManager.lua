local CHUNKS_REPO = require("tools/constructionSet/terrain/chunksRepo")

return {
	chunkBanks = require("tools/lib/dataStructures/navigableList"):create {},
	
	register = function(self, path)
		local chunkList  = require("tools/constructionSet/terrain/chunkList"):create(CHUNKS_REPO:get(path))

        self.chunkBanks:add(chunkList)
        
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

}
