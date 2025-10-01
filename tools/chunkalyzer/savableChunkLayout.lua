return {
	create = function(self, chunkRepo, image)
		return ({
			chunkRepo = chunkRepo,
			image     = image,

			init = function(self)
				local width, height = self:calculateImageArea()

				print("Creating a Chunk Layout of dimensions " .. width .. "x" .. height .. "...")
				self.GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), width, height)
				return self
			end,

			calculateImageArea = function(self)
				local width = 256 * 9
				local height = (math.floor((#self.chunkRepo - 1) / 9) + 1) * 256

				return width, height
			end,

			save = function(self)
				self:draw()
				love.filesystem.createDirectory("resources/zones/chunks")
				return self.GRAFX:saveImage("resources/zones/chunks/sampleChunkLayout")
			end,

			draw = function(self)
				for _, c in ipairs(self.chunkRepo) do
					self.GRAFX:setColor(1, 1, 1)
					local x, y = ((c.X - 16) / 272) * 256, ((c.Y - 16) / 272) * 256
					self.GRAFX:draw(self.image, c.quad, x, y, 0, 1, 1)
				end
			end,

		}):init()
	end,
}
