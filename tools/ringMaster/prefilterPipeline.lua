local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Prefilter Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")

local PIXEL_UTIL = require("tools/lib/pixelUtil")

local TASK_SLICE_TIME_IN_MS = 12

local COMPARISON_COLOR

local PREFILTER_ENGINE = require("tools/ringMaster/prefilter")
local MAP_VLINE

local HOT_LIST, COLD_LIST

local doPrefiltering, prefilterAtVLine, createMapFeeder

doPrefiltering = function(params, nextParams)
	if params.MAP_VLINES:isComplete() then
		HOT_LIST = PREFILTER_ENGINE:getResults()
		
		MAP_VLINE = MAP_WIDTH
		return true
	end

	COLD_LIST = PREFILTER_ENGINE:getColdList()
		
	nextParams:init {
		x = params.MAP_VLINES:next()
	}

end

prefilterAtVLine = function(params, nextParams)
	MAP_VLINE = params.x
	PREFILTER_ENGINE:prefilterAtVScan(MAP_DATA, COMPARISON_COLOR, params.x)

	return true
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
		OBJECT_WIDTH      = objectInfo.width
  		COMPARISON_COLOR  = objectInfo.keyColor.color
  		MAP_DATA          = mapInfo.data
		MAP_WIDTH         = mapInfo.width
  		MAP_START_X       = mapInfo.startX
  		MAP_END_X         = MAP_START_X + MAP_WIDTH - OBJECT_WIDTH
  		
  		PIPELINE:add("Prefilter All",  doPrefiltering)
		PIPELINE:add("Scan at VLine",  prefilterAtVLine)
		PIPELINE:push { MAP_VLINES = createMapFeeder() }
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,

	isReady = function(self)
		return COMPARISON_COLOR ~= nil and not PIPELINE:isComplete()
	end,

	getVScanX = function(self)
		return MAP_VLINE
	end,

	getProgress = function(self)
		if   MAP_VLINE == nil then return 0
		else                       return MAP_VLINE / MAP_WIDTH end
	end,

	getColdList = function(self)
		return COLD_LIST
	end,

	getHotList = function(self)
		return HOT_LIST
	end,

	getTotalElapsedTime = function(self)
		return PIPELINE:getTotalElapsedTime()
	end,

}
