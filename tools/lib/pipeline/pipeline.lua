local STAGE = require("tools/lib/pipeline/stage")

-- When we call execute() on the pipeline, the pipeline iterates through the stages, and
-- executes the first stage with a successor that is complete.
-- Pipeline is complete when the first stage has a result.

return {
	create = function(self, name)
		local END_TIME = 0
		
		return {

			name = name,

			stages = {},
			startTime = nil,

			execute = function(self, executionTimeInMs)
				local startTime = love.timer.getTime()
				if self.startTime == nil then
					self.startTime = startTime
				end

				local timeElapsed = 0

				while timeElapsed < executionTimeInMs / 1000 and not self:isComplete() do
					self:executeOneStep()

					local endTime = love.timer.getTime()
					timeElapsed = endTime - startTime

					if not self:isComplete() then
						END_TIME = endTime
					end
				end
			end,

			executeOneStep = function(self)
				local lastProcessingStageIndex = nil
				
				for n, stage in ipairs(self.stages) do
					if     stage:isProcessing() then lastProcessingStageIndex = n end
				end

				if lastProcessingStageIndex == nil then
					print("ERROR: no stage to execute!")
				else
					local stageToExecute  = self.stages[lastProcessingStageIndex]
					local downStreamStage = self.stages[lastProcessingStageIndex + 1]
					
					stageToExecute:execute(downStreamStage)
				end
			end,

			add = function(self, taskName, taskFn)
				table.insert(self.stages, STAGE:create(taskName, taskFn))
			end,

			push = function(self, data)
				self.stages[1]:push(data)
			end,

			isComplete = function(self)
				return self:getResults() ~= nil
			end,

			getResults = function(self)
				if #self.stages == 0 then return nil
				else                      return self.stages[1].results end
			end,

			getTotalElapsedTime = function(self)
				return END_TIME - self.startTime
			end,

		}
	end,
}
