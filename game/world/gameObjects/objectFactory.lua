return {
	create = function(self, objectData, GRAPHICS, WORLD, OBJECT_ID)
		local generalObj  = requireRelative("world/gameObjects/object"):create(objectData, GRAPHICS, WORLD, OBJECT_ID)
		local specificObj = requireRelative("world/gameObjects/objects/" .. objectData.obj):create()

		self:addGeneralFunctionality(generalObj, specificObj)

		specificObj:onCreation()
		return specificObj
	end,

	addGeneralFunctionality = function(self, generalObj, specificObj)
		for k, v in pairs(generalObj) do
			if not specificObj[k] then
				specificObj[k] = v
			end
		end
		specificObj.super = generalObj
	end,
        
}
