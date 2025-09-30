return {
	init = function(self, img)
		self.img = img
		self:initChunks()
		return self
	end,

	initChunks = function(self)
		self.chunks = {}

		for y = 0, self:getRowCount() - 1 do
			for x = 0, self:getColumnCount() - 1 do
				table.insert(self.chunks, { x = x * 256, y = y * 256 })
			end
		end
	end,

	getRowCount    = function(self) return math.floor(self.img:getHeight() / 256) end,
	getColumnCount = function(self) return math.floor(self.img:getWidth()  / 256) end,

	getChunks = function(self)
		return self.chunks
	end,
}
