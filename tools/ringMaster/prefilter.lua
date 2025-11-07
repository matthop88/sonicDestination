local PIXEL_UTIL = require("tools/lib/pixelUtil")

local HOT_LIST   = require("tools/ringMaster/rectList"):create()
local COLD_LIST  = require("tools/ringMaster/rectList"):create()

return {
	prefilter = function(self, imageData, hotColor)
		print("Hot Color: r = " .. hotColor.r .. ", g = " .. hotColor.g .. ", b = " .. hotColor.b .. ", a = " .. hotColor.a)
		
		for x = 0, imageData:getWidth() - 1 do
			self:prefilterAtVScan(imageData, hotColor, x)
		end

		return self:getResults()
	end,

	prefilterAtVScan = function(self, imageData, hotColor, scanX)
		local myColor = { r = hotColor.r / 255, g = hotColor.r / 255, b = hotColor.b / 255, a = hotColor.a / 255 }
		local isHot = false
		for y = 0, imageData:getHeight() - 1 do
			if PIXEL_UTIL:pixelMatchesColor(imageData, scanX, y, myColor, 0.1, false) then
				HOT_LIST:add(scanX)
				isHot = true
				break
			end
		end
		if not isHot then COLD_LIST:add(scanX) end
	end,

	getResults = function(self)
		COLD_LIST = self:compressList(COLD_LIST)

		return self:getHotList(), self:getColdList()
	end,

	compressList = function(self, myList)
		local newList = {}
		for _, elt in ipairs(myList) do
			if elt.size > 15 then
				table.insert(newList, { offset = elt.offset - 3, size = elt.size - 12 })
			end
		end

		return newList
	end,

	getHotList  = function(self) return HOT_LIST  end,
	getColdList = function(self) return COLD_LIST end,

	printList = function(self, myList)
		for n, elt in ipairs(myList) do
			print("" .. n .. ": offset = " .. elt.offset .. ", size = " .. elt.size)
		end
	end,
}
