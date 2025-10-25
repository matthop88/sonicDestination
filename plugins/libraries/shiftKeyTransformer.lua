local UNSHIFTED_KEYS      = "`1234567890-=[]\\;',./"
local SHIFTED_KEYS        = "~!@#$%^&*()_+{}|:\"<>?"

return {
	transformIfShifted = function(self, key)
		if     key == "lshift" or key == "rshift"       then return ""
		elseif love.keyboard.isDown("lshift", "rshift") then return self:transformShiftedKey(key)
		else                                                 return key                       end
	end,

	transformShiftedKey = function(self, key)
		for i = 1, #UNSHIFTED_KEYS do
			if key == UNSHIFTED_KEYS:sub(i, i) then 
				return SHIFTED_KEYS:sub(i, i)
			end
		end
		return key:upper()
	end,
}
