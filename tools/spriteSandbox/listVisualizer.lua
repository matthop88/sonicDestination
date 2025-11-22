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
					while not self.list:isEnd() do
						local sprite = self.list:getNext()
						self.graphics:setColor(1, 1, 1, 0.9)
						self.graphics:setLineWidth(3)
						self.graphics:rectangle("line", x, 725, 50, 50)
						self.graphics:setFontSize(24)
						self.graphics:printf("" .. sprite:getID(), x, 735, 50, "center")
						x = x + 100
					end
				end
			end,
		}
	end,
}
