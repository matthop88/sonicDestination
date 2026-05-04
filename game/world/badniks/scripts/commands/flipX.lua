return function(params)
	params = params or {}
	return {
		animation =  params.animation,
        
        execute = function(self, dt, actor)
			if self.animation then actor:setAnimationByLabel(self.animation) end
            actor:flipX()
			return true
		end,
	}
end
