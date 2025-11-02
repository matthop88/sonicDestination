local PIXEL_UTIL = require("tools/lib/pixelUtil")

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
  						self:scanForObjectAt(x, y)
  						x = x + 1
  					end
  				end
			end,

			scanForObjectAt = function(self, x, y)
				for objY = 0, OBJECT_HEIGHT - 1 do
					if not self:scanlineMatches(objY, x, y) then
						return false
					end
				end

				return true
			end,

			scanlineMatches = function(self, objY, x, y)
				for objX = 0, OBJECT_WIDTH - 1 do
    				local mapX, mapY = objX + x, objY + y
    				if not self:pixelsMatch(objX, objY, mapX, mapY) then
    					return false
    				end
    			end

    			return true
    		end,

    		pixelsMatch = function(self, objX, objY, mapX, mapY)
    			return PIXEL_UTIL:pixelsMatchWithWildcardTransparency(OBJECT_DATA, objX, objY, MAP_DATA, mapX, mapY) 
 			end,
 		}
 	end,
 }
