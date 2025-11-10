local PIXEL_UTIL = require("tools/lib/pixelUtil")

return {
	prefilter = function(self, imageData, hotColor, hotList)
		for _, block in ipairs(hotList) do
			block.coldList = require("tools/ringMaster/rectList"):create()
			self:prefilterAtBlock(imageData, hotColor, block) 
		end

		return self:getResults(hotList)
	end,

	prefilterAtBlock = function(self, imageData, hotColor, block)
		for y = 0, imageData:getHeight() - 1 do
			self:prefilterAtScanLine(imageData, hotColor, block, y)
		end
	end,

	prefilterAtScanLine = function(self, imageData, hotColor, block, scanY)
		local myColor = { r = hotColor.r / 255, g = hotColor.r / 255, b = hotColor.b / 255, a = hotColor.a / 255 }
		local isHot = false
		for x = block.offset, block.offset + block.size - 1 do
			if PIXEL_UTIL:pixelMatchesColor(imageData, x, scanY, myColor, 0.1, false) then
				isHot = true
				break
			end
		end
		if not isHot then block.coldList:add(scanY) end
	end,

	getResults = function(self, hotList)
		hotList = self:compressList(hotList)

		return hotList
	end,

	compressList = function(self, myList)
		local newList = {}
		for _, elt in ipairs(myList) do
			if elt.size > 12 then
				if elt.coldList then
					table.insert(newList, { offset = elt.offset, size = elt.size, coldList = self:compressList(elt.coldList) })
				else
					table.insert(newList, { offset = elt.offset - 3, size = elt.size - 12, alpha = elt.alpha })
				end
			end
		end

		return newList
	end,

	printList = function(self, myList, indent)
		indent = indent or ""
		for n, elt in ipairs(myList) do
			print(indent .. n .. ": offset = " .. elt.offset .. ", size = " .. elt.size)
			if elt.coldList then
				self:printList(elt.coldList, "  ")
			end
		end
	end,
}
