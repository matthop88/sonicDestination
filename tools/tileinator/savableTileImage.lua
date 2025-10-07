return {
	create = function(self, tileRepo, image)
		return ({
			tileRepo = tileRepo,
			image     = image,

			init = function(self)
				local width, height = self:calculateImageArea()

				print("Creating a Tile Image of dimensions " .. width .. "x" .. height .. "...")
				self.GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), width, height)
				return self
			end,

			calculateImageArea = function(self)
				local height = 256
				local width  = (math.floor((#self.tileRepo - 1) / 256) + 1) * 256

				return width, height
			end,

			save = function(self, tileImageName)
				self:draw()
				love.filesystem.createDirectory("resources/zones/tiles")
				return self.GRAFX:saveImage("resources/zones/tiles/" .. tileImageName)
			end,

			draw = function(self)
				for n, tile in ipairs(self.tileRepo) do
					local chunkID = math.floor((n - 1) / 256)
	                local x = (n - 1) % 16
	                local y = math.floor(((n - 1) % 256) / 16)

	                self.GRAFX:setColor(1, 1, 1)
					local x, y = chunkID * 256 + (x * 16), y * 16
					self.GRAFX:draw(self.image, tile.quad, x, y, 0, 1, 1)
				end
			end,

		}):init()
	end,
}
