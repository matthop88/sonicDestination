local draw = function(self, graphics, x, y)
	self.chunks:drawAt(graphics, self.id, x, y)
end

return {
	create = function(self, chunks, id)
		return {
			chunks = chunks,
			id     = id,
			draw   = draw,
		}
	end,
}
