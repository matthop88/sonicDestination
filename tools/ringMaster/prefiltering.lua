local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Prefilter Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")

local TASK_SLICE_TIME_IN_MS = 12

local MAP_DATA
local MAP_WIDTH,      MAP_HEIGHT
local MAP_START_X,    MAP_START_Y
local MAP_END_X

local MAP_VLINE

local COLOR_CLASSIFIER      = require("tools/ringMaster/colorClassifier")
local MAP_COLOR_FREQUENCIES = {}

local doPrefiltering, prefilterMapAtVline

doPrefiltering = function(params, nextParams)
	if params.MAP_VLINES:isComplete() then
		print("Prefiltering complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		for k, v in pairs(MAP_COLOR_FREQUENCIES) do
	        print("Color: { r = " .. v.color.r .. ", g = " .. v.color.g .. ", b = " .. v.color.b .. ", a = " .. v.color.a .. " }, Frequency: " .. v.frequency)
	    end
	    MAP_VLINE = MAP_WIDTH
		return true
	end

	nextParams:init {
		x = params.MAP_VLINES:next()
	}
end

prefilterMapAtVline = function(params, nextParams)
	local y = MAP_START_Y
	local x = params.x
	MAP_VLINE = x
	COLOR_CLASSIFIER:buildColorFrequencyMap(MAP_DATA, x, 0, 1, MAP_HEIGHT, MAP_COLOR_FREQUENCIES)

	return true
end

createMapFeeder = function()
	local myList = {}
	for x = MAP_START_X, MAP_END_X - 1 do
		table.insert(myList, x)
	end

	return FEEDER:create("Map VLines", myList)
end

return {
	setup = function(self, mapInfo)
		MAP_DATA                       = mapInfo.data
		MAP_WIDTH,      MAP_HEIGHT     = mapInfo.width,     mapInfo.height
  		MAP_START_X,    MAP_START_Y    = mapInfo.startX,    mapInfo.startY
  		MAP_END_X                      = MAP_START_X + MAP_WIDTH

  		PIPELINE:add("Prefilter All",      doPrefiltering)
		PIPELINE:add("Prefilter at VLine", prefilterMapAtVline)
		PIPELINE:push { MAP_VLINES = createMapFeeder() }
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,

	isReady = function(self)
		return not PIPELINE:isComplete() and MAP_DATA ~= nil
	end,

	getVScanX = function(self)
		return MAP_VLINE
	end,

	getProgress = function(self)
		if   MAP_VLINE == nil then return 0
		else                       return MAP_VLINE / MAP_WIDTH end
	end,
}
