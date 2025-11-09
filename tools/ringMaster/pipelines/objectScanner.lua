local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Scanner Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")

local PIXEL_UTIL = require("tools/lib/pixelUtil")

local TASK_SLICE_TIME_IN_MS = 3

local OBJECT_DATA
local OBJECT_WIDTH,   OBJECT_HEIGHT
local OBJECT_START_X, OBJECT_START_Y
local OBJECT_END_X,   OBJECT_END_Y

local MAP_DATA
local MAP_WIDTH,      MAP_HEIGHT
local MAP_START_X,    MAP_START_Y
local MAP_END_X,      MAP_END_Y

local MAP_VLINE

local COMPARISON_COLOR
local COLOR_POSITIONS
local MAX_STRIKES

local PREFILTER_PIPELINE   = require("tools/ringMaster/pipelines/prefilterPipeline")
local PREFILTER_2_PIPELINE = require("tools/ringMaster/pipelines/secondaryPrefilterPipeline")
	
local HOT_LIST_INDEX = 1

local OBJECTS_FOUND = {}

local doPrefiltering, doScanning, scanForObjectsAtLine, scanForObjectAt, pixelsMatch

doScanning = function(params, nextParams)
	if params.MAP_VLINES:isComplete() then
		print("Scanning complete in " .. PREFILTER_PIPELINE:getTotalElapsedTime() + PIPELINE:getTotalElapsedTime() .. " seconds.")
		printToReadout("Scanning Complete. " .. #OBJECTS_FOUND .. " rings found.")
    
		MAP_VLINE = MAP_WIDTH
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
	local hotElt = PREFILTER_PIPELINE:getHotList()[HOT_LIST_INDEX]
	if hotElt then
		if x < hotElt.offset or x >= hotElt.offset + hotElt.size then
			if x >= hotElt.offset + hotElt.size then
				HOT_LIST_INDEX = HOT_LIST_INDEX + 1
			end
			return false
		end
	end
	
	local coldListIndex = 1
	while y < MAP_END_Y do
		if hotElt then
			local coldElt = hotElt.coldList[coldListIndex]
			if coldElt then
				if y >= coldElt.offset and y < coldElt.offset + coldElt.size then
					y = coldElt.offset + coldElt.size
					coldListIndex = coldListIndex + 1
				end
			end
		end
		if scanForObjectAt(x, y) then
			table.insert(OBJECTS_FOUND, { x = x, y = y })
			y = y + 16
		else
			y = y + 1
		end
	end

	return true
end

scanForObjectAt = function(x, y)
	local strikeCount = 0
	for _, position in ipairs(COLOR_POSITIONS) do
		local objX, objY = position.x, position.y
		local mapX, mapY = objX + x, objY + y
		if not pixelsMatch(OBJECT_START_X + objX, OBJECT_START_Y + objY, mapX, mapY) then
			strikeCount = strikeCount + 1
			if strikeCount >= MAX_STRIKES then
				return false
			end
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
		PREFILTER_PIPELINE:setup(objectInfo, mapInfo)

		OBJECTS_FOUND = {}
		
		OBJECT_DATA                    = objectInfo.data
		OBJECT_WIDTH,   OBJECT_HEIGHT  = objectInfo.width,  objectInfo.height
  		OBJECT_START_X, OBJECT_START_Y = objectInfo.startX, objectInfo.startY
  		OBJECT_END_X                   = OBJECT_START_X + OBJECT_WIDTH  - 1
  		OBJECT_END_Y                   = OBJECT_START_Y + OBJECT_HEIGHT - 1

  		COMPARISON_COLOR               = objectInfo.keyColor.color
  		COLOR_POSITIONS                = objectInfo.keyColor.positions
  		MAX_STRIKES                    = objectInfo.maxStrikes

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
		if not PREFILTER_PIPELINE:isComplete() then PREFILTER_PIPELINE:execute()
		elseif not PREFILTER_2_PIPELINE:isComplete() then 
			if not PREFILTER_2_PIPELINE:isReady() then
				PREFILTER_2_PIPELINE:setup(COMPARISON_COLOR, MAP_DATA, OBJECT_HEIGHT, PREFILTER_PIPELINE:getHotList())
			end                                       
			PREFILTER_2_PIPELINE:execute()
		else
			PIPELINE:execute(TASK_SLICE_TIME_IN_MS) 
		end
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

	getProgress = function(self)
		return (PREFILTER_PIPELINE:getProgress() * 0.1) + (PREFILTER_2_PIPELINE:getProgress() * 0.1) + (self:getScanProgress() * 0.8)
	end,

	getScanProgress = function(self)
		if   MAP_VLINE == nil then return 0
		else                       return MAP_VLINE / MAP_WIDTH end
	end,

	getObjectsFound = function(self)
		return OBJECTS_FOUND
	end,

	getColdList = function(self)
		return PREFILTER_PIPELINE:getColdList()
	end,

	getHotList = function(self)
		return PREFILTER_2_PIPELINE:getHotList()
	end,

	getMapData = function(self)
		return MAP_DATA
	end,
}
