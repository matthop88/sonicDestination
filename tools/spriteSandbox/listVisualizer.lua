return {
	create = function(self, list)

		return {
			list     = list,
			graphics = require("tools/lib/graphics"):create(), 
    
			draw = function(self)
				if self.list:size() > 0 then
					self.graphics:setColor(0.5, 0.5, 0.5, 0.8)
					self.graphics:rectangle("fill", 0, 700, 1200, 100)

					self.list:head()
					local x = 50
					local n = 1
					while not self.list:isEnd() do
						local sprite = self.list:getNext()
						if sprite.selected then self.graphics:setColor(1, 0.5, 0.5, 0.9)
						else                    self.graphics:setColor(1, 1,   1,   0.9)  end
						self.graphics:setLineWidth(3)
						self.graphics:rectangle("line", x, 725, 50, 50)
						self.graphics:setFontSize(24)
						self.graphics:printf("" .. sprite:getID(), x, 735, 50, "center")

						self.graphics:setColor(1, 1, 1, 0.9)
						if n < self.list:size() then
							self.graphics:line(x + 50, 740, x + 100, 740)
							self.graphics:line(x + 90, 735, x + 100, 740)
							self.graphics:line(x + 90, 745, x + 100, 740)
							self.graphics:line(x + 50, 760, x + 100, 760)
							self.graphics:line(x + 60, 755, x +  50, 760)
							self.graphics:line(x + 60, 765, x +  50, 760)
							
						end
						x = x + 100
						n = n + 1
					end
				end
			end,
		}
	end,
}
