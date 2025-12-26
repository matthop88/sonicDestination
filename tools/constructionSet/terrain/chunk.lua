local CHUNKS_REPO = require("tools/constructionSet/terrain/chunksRepo")

local draw = function(self, graphics, x, y)
	self.chunks:drawAt(graphics, self.id, x, y)
end

return {
	create = function(self, chunks, id)
		return {
			chunks    = chunks,
			id        = id,
			draw      = draw,

			name      = chunks:path(),

			serialize = function(self)
				return "{ " .. CHUNKS_REPO:getVar(self.name) .. ", " .. self.id .. " }" 
	        end,
		}
	end,

	deserialize = function(self, packet)
		return self:create(CHUNKS_REPO:get(packet[1]), packet[2])
	end,
}
