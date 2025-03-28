local slice = {
	new = function(self, params)
		return {
			x = params.x, y = params.y,
			w = nil,      h = 1,
	
			leftX    = params.leftX,
			complete = false,

			markAsComplete = function(self)    self.complete = true       end,
			isComplete     = function(self)    return self.complete       end,
			hasValidLeftX  = function(self)    return self.leftX ~= nil   end,
			getBottom      = function(self)    return self.y + self.h - 1 end,
			updateWidth    = function(self, x) self.w = x - self.x        end,
			
			append = function(self, newSlice)
				self.complete = self:isComplete()    or newSlice:isComplete()
				if newSlice:hasValidLeftX() then
					self.leftX = newSlice.leftX
					self.x     = newSlice.leftX
				end
				self.h = self.h + 1
			end,
		}
	end,
}

return {
	produceSliceUsing = function(self, pixelTransitionData, x, y)
		if     pixelTransitionData:isDefinitelyEnteringSprite() then
			return self:createSlice({ x = x, y = y, leftX = x })
		elseif pixelTransitionData:isPossiblyEnteringSprite()   then
			return self:createSlice({ x = x, y = y })
		elseif pixelTransitionData:isProbablyLeavingSprite()    then
			return self:updateCachedSlice(x, y)
		end
	end,

	createSlice = function(self, params)
		self.cachedSlice = slice:new(params)
		return self.cachedSlice
	end,

	updateCachedSlice = function(self, x, y)
		if self.cachedSlice ~= nil then
			self.cachedSlice:updateWidth(x)
			self.cachedSlice = nil
		end
	end,
}
