local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Secondary Prefilter Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")

local PIXEL_UTIL = require("tools/lib/pixelUtil")

local TASK_SLICE_TIME_IN_MS = 12

local COMPARISON_COLOR

local SECONDARY_PREFILTER_ENGINE = require("tools/ringMaster/secondaryPrefilter")
local MAP_VLINE
local Y_FEEDER

local HOT_LIST

local doSecondaryPrefiltering, prefilterAtBlock, prefilterAtScanline, createYFeeder

doSecondaryPrefiltering = function(params, nextParams)
	if params.hotList:isComplete() then
		HOT_LIST = SECONDARY_PREFILTER_ENGINE:getResults(HOT_LIST)
		
		MAP_VLINE = MAP_WIDTH
		return true
	end
		
	nextParams:init {
		block = params.hotList:next()
	}

end

prefilterAtBlock = function(params, nextParams)
	MAP_VLINE = params.block.offset

	if Y_FEEDER:isComplete() then 
		Y_FEEDER:reset() 
		return true
	end

	nextParams:init {
		block = params.block,
		y     = Y_FEEDER:next()
	}
end

prefilterAtScanline = function(params, nextParams)
	SECONDARY_PREFILTER_ENGINE:prefilterAtScanLine(MAP_DATA, COMPARISON_COLOR, params.block, params.y)

	return true
end

createYFeeder = function(startY, endY)
	local yList = {}
	for y = startY, endY do
		table.insert(yList, y)
	end

	return FEEDER:create("Y Feeder", yList)
end

return {
	setup = function(self, comparisonColor, mapData, objHeight, hotList)
		print("Setting up secondary pipeline...")
		COMPARISON_COLOR  = comparisonColor
  		MAP_DATA          = mapData
		MAP_WIDTH         = mapData:getWidth()
		HOT_LIST          = hotList
  		
  		Y_FEEDER          = createYFeeder(0, MAP_DATA:getHeight() - objHeight)

  		PIPELINE:add("Prefilter All #2",           doSecondaryPrefiltering)
  		PIPELINE:add("Prefilter #2 at Block",      prefilterAtBlock)
		PIPELINE:add("Secondary Scan at Scanline", prefilterAtScanline)
		PIPELINE:push { hotList = FEEDER:create("List of Hot Zones", hotList) }

		for _, block in ipairs(hotList) do
			block.coldList = require("tools/ringMaster/rectList"):create()
		end
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,

	isReady = function(self)
		return HOT_LIST ~= nil and not PIPELINE:isComplete()
	end,

	getVScanX = function(self)
		return MAP_VLINE
	end,

	getProgress = function(self)
		if   MAP_VLINE == nil then return 0
		else                       return MAP_VLINE / MAP_WIDTH end
	end,

	getHotList = function(self)
		return HOT_LIST
	end,

	getTotalElapsedTime = function(self)
		return PIPELINE:getTotalElapsedTime()
	end,

}
