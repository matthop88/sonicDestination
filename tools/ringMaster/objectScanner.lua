local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Scanner Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")

local PIXEL_UTIL = require("tools/lib/pixelUtil")

local TASK_SLICE_TIME_IN_MS = 12

local OBJECT_DATA
local OBJECT_WIDTH,   OBJECT_HEIGHT
local OBJECT_START_X, OBJECT_START_Y
local OBJECT_END_X,   OBJECT_END_Y

local MAP_DATA
local MAP_WIDTH,      MAP_HEIGHT
local MAP_START_X,    MAP_START_Y
local MAP_END_X,      MAP_END_Y

local OBJECTS_FOUND = {}

local scanAll, scanForObjectsAtLine, scanForObjectAt, scanForObjectScanlineAt, pixelsMatch

doScanning = function()
  	for y = MAP_START_Y, MAP_END_Y do
  		scanForObjectsAtLine(y)
  	end
end

scanForObjectsAtLine = function(y)
	local x = MAP_START_X
	while x < MAP_END_X do
		if scanForObjectAt(x, y) then
			table.insert(OBJECTS_FOUND, { x = x, y = y })
			print("" .. #OBJECTS_FOUND .. ": Found ring at { " .. x .. ", " .. y .. " }")
			x = x + 16
		else
			x = x + 1
		end
	end
end

scanForObjectAt = function(x, y)
	for objY = 0, OBJECT_HEIGHT - 1 do
		if not scanForObjectScanlineAt(objY, x, y) then
			return false
		end
	end

	return true
end

scanForObjectScanlineAt = function(objY, x, y)
	for objX = 0, OBJECT_WIDTH - 1 do
		local mapX, mapY = objX + x, objY + y
		if not pixelsMatch(OBJECT_START_X + objX, OBJECT_START_Y + objY, mapX, mapY) then
			return false
		end
	end

	return true
end

pixelsMatch = function(objX, objY, mapX, mapY)
    return PIXEL_UTIL:pixelsMatchWithWildcardTransparency(OBJECT_DATA, objX, objY, MAP_DATA, mapX, mapY) 	
end

return {
	setup = function(self, objectInfo, mapInfo)
		OBJECT_DATA                    = objectInfo.data
		OBJECT_WIDTH,   OBJECT_HEIGHT  = objectInfo.width,  objectInfo.height
  		OBJECT_START_X, OBJECT_START_Y = objectInfo.startX, objectInfo.startY
  		OBJECT_END_X                   = OBJECT_START_X + OBJECT_WIDTH  - 1
  		OBJECT_END_Y                   = OBJECT_START_Y + OBJECT_HEIGHT - 1

  		MAP_DATA                       = mapInfo.data
		MAP_WIDTH,      MAP_HEIGHT     = mapInfo.width,     mapInfo.height
  		MAP_START_X,    MAP_START_Y    = mapInfo.startX,    mapInfo.startY
  		MAP_END_X                      = MAP_START_X + MAP_WIDTH  - OBJECT_WIDTH
  		MAP_END_Y                      = MAP_START_Y + MAP_HEIGHT - OBJECT_HEIGHT
	end,

	execute = function(self)
		OBJECTS_FOUND = {}
		doScanning()
	end,

	isComplete = function(self)
		return true
	end,

	getObjectsFound = function(self)
		return OBJECTS_FOUND
	end,
}
