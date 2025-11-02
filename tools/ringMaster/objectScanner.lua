local PIXEL_UTIL = require("tools/lib/pixelUtil")

return {
	create = function(self, OBJECT_DATA, MAP_DATA)
		local OBJECT_WIDTH  = OBJECT_DATA:getWidth()
  		local OBJECT_HEIGHT = OBJECT_DATA:getHeight()
  
  		local MAP_WIDTH     = MAP_DATA:getWidth()
  		local MAP_HEIGHT    = MAP_DATA:getHeight()

		return {
			objectsFound = {},

			scanAll = function(self)
  				for y = 0, MAP_HEIGHT - OBJECT_HEIGHT do
  					self:scanForObjectsAtLine(y)
  				end
  				print("Done Scanning.")
  			end,

  			scanForObjectsAtLine = function(self, y)
  				print("Scanning for objects at line: " .. y)
  				local x = 0
  				while x < MAP_WIDTH - OBJECT_WIDTH do
  					if self:scanForObjectAt(x, y) then
  						table.insert(self.objectsFound, { x = x, y = y })
  						print("" .. #self.objectsFound .. ": Found ring at { " .. x .. ", " .. y .. " }")
  						x = x + 16
  					else
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
