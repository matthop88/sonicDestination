return {
	create = function(self, chunkRepo)
		return ({
			chunkRepo = chunkRepo,

			init = function(self)
				local width, height = self:calculateImageArea()

				print("Creating a Chunk Layout of dimensions " .. width .. "x" .. height .. "...")
				self.GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), width, height)
			end,

			calculateImageArea = function(self)
				local width = 256 * 9
				local height = (math.floor((#self.chunkRepo - 1) / 9) + 1) * 256

				return width, height
			end,
		}):init()
	end,
}
