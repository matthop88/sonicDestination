return {
	create = function(self, OBJECT_DATA, MAP_DATA)
		local OBJECT_WIDTH  = OBJECT_DATA:getWidth()
  		local OBJECT_HEIGHT = OBJECT_DATA:getHeight()
  
  		local MAP_WIDTH     = MAP_DATA:getWidth()
  		local MAP_HEIGHT    = MAP_DATA:getHeight()

		return {
			scanAll = function(self)
  				local x = 0
  				for y = 0, MAP_HEIGHT - OBJECT_HEIGHT do
  					while x < MAP_WIDTH - OBJECT_WIDTH do
  						-- Look for object at x, y in map
  						x = x + 1
  					end
  				end
			end,
		}
	end,
}
