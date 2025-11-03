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

local MAP_VLINE

local OBJECTS_FOUND = {}

local scanAll, scanForObjectsAtLine, scanForObjectAt, scanForObjectScanlineAt, pixelsMatch

doScanning = function(params, nextParams)
	if params.MAP_VLINES:isComplete() then
		print("Scanning complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		print("Number of objects found: " .. #OBJECTS_FOUND)
		MAP_VLINE = nil
		return true
	end

  	nextParams:init {
  		x = params.MAP_VLINES:next()
  	}
end

scanForObjectsAtVLine = function(params, nextParams)
	local y = MAP_START_Y
	local x = params.x
	MAP_VLINE = x
	print("Scanning for objects at vline: " .. x)
	while y < MAP_END_Y do
		if scanForObjectAt(x, y) then
			table.insert(OBJECTS_FOUND, { x = x, y = y })
			print("" .. #OBJECTS_FOUND .. ": Found ring at { " .. x .. ", " .. y .. " }")
			y = y + 16
		else
			y = y + 1
		end
	end

	return true
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

createMapFeeder = function()
	local myList = {}
	for x = MAP_START_X, MAP_END_X do
		table.insert(myList, x)
	end

	return FEEDER:create("Map VLines", myList)
end

return {
	setup = function(self, objectInfo, mapInfo)
		OBJECTS_FOUND = {}
		
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

  		PIPELINE:add("Scan All",           doScanning)
		PIPELINE:add("Scan at VLine",      scanForObjectsAtVLine)
		PIPELINE:push { MAP_VLINES = createMapFeeder() }
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,

	isReady = function(self)
		return OBJECT_DATA ~= nil and not PIPELINE:isComplete()
	end,

	getVScanX = function(self)
		return MAP_VLINE
	end,

	getObjectsFound = function(self)
		return OBJECTS_FOUND
	end,
}
