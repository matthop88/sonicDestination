local NEXT_PARAMS = {
	nextParams = {},

	init = function(self, params)
		for k, v in pairs(params) do
			if self.nextParams[k] == nil then
				self.nextParams[k] = v
			end
		end
	end,

	get = function(self)
		return self.nextParams
	end,

	clear = function(self)
		self.nextParams = {}
	end,

	count = function(self)
		local numKeys = 0
		for _, _ in pairs(self.nextParams) do numKeys = numKeys + 1 end
		return numKeys
	end,

}

return {
	create = function(self, name, taskFn)
		return {
			name    = name,
			results = nil,
			params  = nil,
			taskFn  = taskFn,

			getName       = function(self) return self.name                                 end,

			isReady       = function(self) return self.results ~= nil or self.params == nil end,
			isComplete    = function(self) return self:isReady()                            end,
			isProcessing  = function(self) return not self:isReady()                        end,
			
			execute = function(self, downStreamStage)
				if self.params == nil then
					-- ERROR!
				else
					if downStreamStage then 
						downStreamStage.results = nil 
						downStreamStage.params  = nil
					end

					NEXT_PARAMS:clear()
					self.results = self.taskFn(self.params, NEXT_PARAMS)
					
					local numKeys = NEXT_PARAMS:count()

					for k, v in pairs(NEXT_PARAMS:get()) do
						self.params[k] = v
					end

					if numKeys > 0 and downStreamStage then
						NEXT_PARAMS:init(self.params)
						downStreamStage:push(NEXT_PARAMS:get())
					end

				end
			end,

			push = function(self, params)
				self.params = params
			end,
		}
	end,
}
