return {
	create = function(self)
		return ({
			selected = nil,
			hidden   = { x = nil, y = nil },
			held     = nil,

			init = function(self)
				for i = 1, 256 do table.insert(self, {}) end
				return self
			end,

			add = function(self, obj, x, y)
				local row = self[y + 1]
				if #row <= x then
					for j = #row, x + 1 do table.insert(row, {}) end
				end
				row[x + 1] = { obj = obj, x = x, y = y }
			end,

			place = function(self, obj, x, y)
				if x < 0 or y < 0 or x > 255 or y > 255 then return end
				for r, row in ipairs(self) do
					for c, chunk in ipairs(row) do
						if chunk and chunk.obj == obj then
							self[r][c] = {}
						end
					end
				end
				obj:release()
				self:add(obj, x, y)
				if self.held then
					self:releaseSelected()
					return true
				end
			end,

			draw = function(self, graphics)
				for _, row in ipairs(self) do
					for _, chunk in ipairs(row) do
						if self:isChunkHidden(chunk) then graphics:setColor(0.3, 0.3, 0.3) 
						else                              graphics:setColor(1, 1, 1)   end

						if chunk.obj ~= nil and not self:isChunkHeld(chunk) then
							chunk.obj:draw(graphics, (chunk.x * 256), (chunk.y * 256))
						end
					end
				end

				if self.selected and self.selected.obj ~= nil then
					graphics:setColor(1, 1, 1, 0.3)
					graphics:rectangle("fill", self.selected.x * 256, self.selected.y * 256, 256, 256)
					graphics:setColor(1, 1, 0)
					graphics:setLineWidth(5)
					graphics:rectangle("line", (self.selected.x * 256) - 2, (self.selected.y * 256) - 2, 260, 260)
				end
			end,

			selectAt = function(self, x, y)
				if x < 0 or y < 0 or x > 255 or y > 255 then return end
				self:deselect()
				local chunk = self[y + 1][x + 1]
				if chunk and chunk.x == x and chunk.y == y and chunk.obj ~= nil then
					self.selected = chunk
				end
			end,

			deleteSelected = function(self)
				if self.selected then self.selected.obj = nil end
				self:deselect()
			end,

			xFlipSelected = function(self)
				if self.selected and self.selected.obj ~= nil then self.selected.obj:flipX() end
			end,

			holdSelected = function(self)
				if self.selected and self.selected.obj ~= nil then
					self.held = self.selected
					return self.held.obj
				end
			end,

			releaseSelected = function(self)
				if self.held then self.held.obj:release() end
				self.held = nil
			end,

			hideAt = function(self, x, y)
				self.hidden.x, self.hidden.y = x, y
			end,

			isChunkHidden = function(self, chunk)
				return chunk.x == self.hidden.x and chunk.y == self.hidden.y
			end,

			isChunkHeld = function(self, chunk)
				return self.held == chunk
			end,

			deselect = function(self)
				self.selected = nil
				self.hidden   = { x = nil, y = nil }
			end,

			clear = function(self)
				for i = 1, #self do
					self[i] = {}
				end
				self.selected = nil
				self.hidden = { x = nil, y = nil }
				self.held = nil
			end,
		}):init()
	end,
}
