return function(params)
	return {
		execute = function(self, dt, actor)
			actor:flipX()
			return true
		end,
	}
end
