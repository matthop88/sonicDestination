local PIXEL_UTIL = require("tools/lib/pixelUtil")

return {
	create = function(self, objectInfo, mapInfo)
		local OBJECT_DATA                    = objectInfo.data
		local OBJECT_WIDTH,   OBJECT_HEIGHT  = objectInfo.width,  objectInfo.height
  		local OBJECT_START_X, OBJECT_START_Y = objectInfo.startX, objectInfo.startY
  		local OBJECT_END_X                   = OBJECT_START_X + OBJECT_WIDTH  - 1
  		local OBJECT_END_Y                   = OBJECT_START_Y + OBJECT_HEIGHT - 1

  		local MAP_DATA                       = mapInfo.data
		local MAP_WIDTH,      MAP_HEIGHT     = mapInfo.width,     mapInfo.height
  		local MAP_START_X,    MAP_START_Y    = mapInfo.startX,    mapInfo.startY
  		local MAP_END_X                      = MAP_START_X + MAP_WIDTH  - OBJECT_WIDTH
  		local MAP_END_Y                      = MAP_START_Y + MAP_HEIGHT - OBJECT_HEIGHT

  		return {
			objectsFound = {},

			scanAll = function(self)
  				for y = MAP_START_Y, MAP_END_Y do
  					self:scanForObjectsAtLine(y)
  				end
  			end,

  			scanForObjectsAtLine = function(self, y)
  				local x = MAP_START_X
  				while x < MAP_END_X do
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
    				if not self:pixelsMatch(OBJECT_START_X + objX, OBJECT_START_Y + objY, mapX, mapY) then
    					return false
    				end
    			end

    			return true
    		end,

    		pixelsMatch = function(self, objX, objY, mapX, mapY)
    			return PIXEL_UTIL:pixelsMatchWithWildcardTransparency(OBJECT_DATA, objX, objY, MAP_DATA, mapX, mapY) 	
 			end,

			getObjectsFound = function(self)
 				return self.objectsFound
 			end,
 		}
 	end,
 }
