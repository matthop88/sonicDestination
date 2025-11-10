local PIXEL_UTIL = require("tools/lib/pixelUtil")

local HOT_LIST   = require("tools/ringMaster/rectList"):create()

local IMAGE_DATA, HOT_COLOR

return {
	prefilter = function(self, imageData, hotColor)

		print("Hot Color: r = " .. hotColor.r .. ", g = " .. hotColor.g .. ", b = " .. hotColor.b .. ", a = " .. hotColor.a)
		
		for x = 0, imageData:getWidth() - 1 do
			self:prefilterAtVScan(imageData, hotColor, x)
		end

		return self:getResults()
	end,

	prefilterAtVScan = function(self, imageData, hotColor, scanX)
		IMAGE_DATA, HOT_COLOR = imageData, hotColor
		local myColor = { r = hotColor.r / 255, g = hotColor.r / 255, b = hotColor.b / 255, a = hotColor.a / 255 }
		for y = 0, imageData:getHeight() - 1 do
			if PIXEL_UTIL:pixelMatchesColor(imageData, scanX, y, myColor, 0.1, false) then
				HOT_LIST:add(scanX)
				self:normalizeHotListElement(#HOT_LIST - 1)
				break
			end
		end
	end,

	getResults = function(self)
		self:normalizeHotListElement(#HOT_LIST)
		
		self:printList(HOT_LIST)
		return self:getHotList()
	end,

	normalizeHotListElement = function(self, index)
		if index > 0 then
			local elt = HOT_LIST[index]
			if not elt.normalized then
				elt.offset = math.max(0, elt.offset - 3)
				elt.size = elt.size + 3
				elt.normalized = true
			end
		end
	end,

	getHotList  = function(self) return HOT_LIST  end,
	
	printList = function(self, myList)
		for n, elt in ipairs(myList) do
			print("" .. n .. ": offset = " .. elt.offset .. ", size = " .. elt.size)
		end
	end,
}
