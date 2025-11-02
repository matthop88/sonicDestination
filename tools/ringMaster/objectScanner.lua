return {
	create = function(self, OBJECT_DATA, MAP_DATA)
		return {
			scanAll = function(self)
				local objectWidth  = OBJECT_DATA:getWidth()
  				local objectHeight = OBJECT_DATA:getHeight()
  
  				local mapWidth     = MAP_DATA:getWidth()
  				local mapHeight    = MAP_DATA:getHeight()

  				local x = 0
  				for y = 0, mapHeight - objectHeight do
  					while x < mapWidth - objectWidth do
  						-- Look for object at x, y in map
  						x = x + 1
  					end
  				end
			end,
		}
	end,
}
