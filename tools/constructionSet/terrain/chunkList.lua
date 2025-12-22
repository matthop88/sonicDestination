return {
	create = function(self, chunks)
		return ({
			init = function(self, chunks)
				self.chunks    = chunks
				self.chunkList = require("tools/lib/dataStructures/navigableList"):create {}
				
				for chunkID, _ in ipairs(self.chunks.data) do
					self.chunkList:add(require("tools/constructionSet/terrain/chunk"):create(chunks, chunkID))
				end

				return self
			end,

			next  = function(self)         self.chunkList:next()  end,
			prev  = function(self)         self.chunkList:prev()  end,
			get   = function(self)  return self.chunkList:get()   end,
			index = function(self)  return self.chunkList:index() end,
			size  = function(self)  return self.chunkList:size()  end,

		}):init(chunks)
	end,
}
