return {
	create = function(self)
		return {
			execute = function(self)
				for _, command in ipairs(self) do command:execute() end
    		end,
			
			undo    = function(self)
				for i = #self, 1, -1 do self[i]:undo() end
			end,

			add     = function(self, command)
				table.insert(self, command)
			end,

			isEmpty = function(self)
				return #self == 0
			end,
		}
	end,
}
