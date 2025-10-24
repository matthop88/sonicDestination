local WORLD

return {
	init = function(self, params)
		WORLD = params.WORLD
		
		return {
			owner = params.OWNER,
		}
	end,
}
