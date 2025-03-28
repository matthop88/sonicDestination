local insertIfComplete = function(slice, sliceList)
	if slice:isComplete() then
		table.insert(sliceList, slice)
	end
end

local insertIfIncomplete = function(slice, sliceList)
	if not slice:isComplete() then
		table.insert(sliceList, slice)
	end
end

return {
	finishedSpriteRects = { 
		findEnclosingRect = function(self, imageX, imageY)
            for _, rect in ipairs(self) do
                if rect ~= nil and self:ptInRect(imageX, imageY, rect) then
                    return rect
                end
            end
        end,

        ptInRect = function(self, x, y, rect)
            return  x >= rect.x 
                and x <= rect.x + rect.w - 1
                and y >= rect.y
                and y <= rect.y + rect.h - 1
        end,
    },

	unfinishedSlices    = {
		innerTable = { },

		add = function(self, newSlice)
			local unfinishedSlice = self:getSliceAt(newSlice.x)
			if unfinishedSlice ~= nil then
				unfinishedSlice:append(newSlice)
			else
				self:innerAdd(newSlice)
			end
		end,

		getSliceAt = function(self, x)
			return self.innerTable[x]
		end,

		innerAdd = function(self, newSlice)
			self.innerTable[newSlice.x] = newSlice
		end,

		markCompletedSlicesAbove = function(self, y)
			for k, slice in pairs(self.innerTable) do
				if slice:getBottom() < y - 1 then
					slice:markAsComplete()
				end
			end
		end,

		getIncomplete = function(self)
			local incompleteSlices = {}
			for k, slice in pairs(self.innerTable) do
				insertIfIncomplete(slice, incompleteSlices)
			end
			return incompleteSlices
		end,

		getComplete = function(self)
			local completeSlices = {}
			for k, slice in pairs(self.innerTable) do
				insertIfComplete(slice, completeSlices)
			end
			return completeSlices
		end,

		purgeAllComplete = function(self)
			local incompleteSlices = self:getIncomplete()
			self.innerTable = {}
			for _, slice in ipairs(incompleteSlices) do
				self:innerAdd(slice)
			end
		end,
	},

	addHorizontalSlices = function(self, slices)
		for _, slice in ipairs(slices) do
			self.unfinishedSlices:add(slice)
		end
    end,

	markCompletedSlicesAbove = function(self, y)
        self.unfinishedSlices:markCompletedSlicesAbove(y)
    end,

    update = function(self)
    	local completeSlices = self.unfinishedSlices:getComplete()
    	if #completeSlices > 0 then
    		self:addFinishedSpriteRects(completeSlices)
    		self.unfinishedSlices:purgeAllComplete()
    	end
    end,

    addFinishedSpriteRects = function(self, completeSlices)
    	for _, slice in ipairs(completeSlices) do
    		if slice:hasValidLeftX() then
    			table.insert(self.finishedSpriteRects, slice)
    		end
    	end
    end,

    getFinishedSpriteRects = function(self)
    	return self.finishedSpriteRects
    end,
}
