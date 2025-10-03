return {
	create = function(self, name, taskFn)
		return {
			name    = name,
			results = nil,
			dataIn  = nil,
			taskFn  = taskFn,

			getName       = function(self) return self.name                                 end,

			isReady       = function(self) return self.results ~= nil or self.dataIn == nil end,
			isComplete    = function(self) return self:isReady()                            end,
			isProcessing  = function(self) return not self:isReady()                        end,
			
			execute = function(self, downStreamStage)
				if self.dataIn == nil then
					-- ERROR!
				else
					local downStreamResult = nil
					if downStreamStage then downStreamResults = downStreamStage:popResults() end

					local dataOut = {}
					self.results = self.taskFn(downStreamResults, self.dataIn, dataOut)
					
					local numKeys = 0
					for _, _ in pairs(dataOut) do numKeys = numKeys + 1 end

					if numKeys > 0 and downStreamStage then
						downStreamStage:push(dataOut)
					end

				end
			end,

			push = function(self, dataIn)
				self.dataIn = dataIn
			end,

			popResults = function(self)
				local myResults = self.results
				self.results = nil
				self.dataIn = nil
				return myResults
			end,

		}
	end,
}
