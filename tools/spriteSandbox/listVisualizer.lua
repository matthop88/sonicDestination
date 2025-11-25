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
						local sprite = self.list:get()
						local cellID = self.list:getCellID()

						self.graphics:setColor(0.5, 0.5, 0.5)
						self.graphics:rectangle("fill", x + 5, 775, 40, 18)
						self.graphics:setColor(1, 1, 1)
						self.graphics:setLineWidth(2)
						self.graphics:rectangle("line", x + 5, 775, 40, 18)
						self.graphics:setFontSize(12)
						self.graphics:printf("" .. cellID, x + 5, 777, 40, "center")

						if sprite.selected then 
							self.graphics:setColor(1, 0.5, 0.5, 0.9)
							self.graphics:rectangle("fill", x, 725, 50, 50)
							self.graphics:setColor(1,   1,   0.3, 0.9)
						else                    
							if sprite.mousedOver then self.graphics:setColor(0, 1, 1, 0.7)
							else                      self.graphics:setColor(1, 1, 1, 0.9) end
						end
						
						self.graphics:setLineWidth(3)
						self.graphics:rectangle("line", x, 725, 50, 50)
						self.graphics:setFontSize(24)
						self.graphics:printf("" .. sprite:getID(), x, 735, 50, "center")

						self.graphics:setColor(1, 1, 1, 0.9)
						if n < self.list:size() then
							self.graphics:setLineWidth(1)
							self.graphics:line(x + 50, 744, x + 100, 744)
							self.graphics:line(x + 50, 756, x + 100, 756)
							self.graphics:setLineWidth(2)
							self.graphics:line(x + 90, 739, x + 100, 744)
							self.graphics:line(x + 90, 749, x + 100, 744)
							self.graphics:line(x + 60, 751, x +  50, 756)
							self.graphics:line(x + 60, 761, x +  50, 756)
						end

						
						self.list:next()
						x = x + 100
						n = n + 1
					end
				end
			end,
		}
	end,
}
