return {
	create = function(self, objectData, GRAPHICS)
		local generalObj  = requireRelative("world/gameObjects/object"):create(objectData, GRAPHICS)
		local specificObj = requireRelative("world/gameObjects/objects/" .. objectData.obj):create()

		self:addGeneralFunctionality(generalObj, specificObj)
		return specificObj
	end,

	addGeneralFunctionality = function(self, generalObj, specificObj)
		for k, v in pairs(generalObj) do
			if not specificObj[k] then
				specificObj[k] = v
			end
		end
	end,
        
}
