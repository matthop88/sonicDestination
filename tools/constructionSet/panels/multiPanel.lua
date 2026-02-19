return {
	create = function(self, panels)
		return {
			panels             = require("tools/lib/dataStructures/navigableList"):create(panels),
			
			getPanel           = function(self) return self.panels:get() end,
			next               = function(self) self.panels:next()       end,
			prev               = function(self) self.panels:prev()       end,

			draw               = function(self, graphics)   
				self:getPanel():draw(graphics)             
			end,
            
            update             = function(self, dt, mx, my) 
            	self:getPanel():update(dt, mx, my)         
            end,
            
            handleMousepressed = function(self, mx, my)     
            	self:getPanel():handleMousepressed(mx, my) 
            end,
			
			handleKeypressed   = function(self, key)
				if     key == "optiontab"      then self:next()
				elseif key == "optionshifttab" then self:prev()
				else
					return self:getPanel():handleKeypressed(key)
				end
			end,
		}
	end,
}
