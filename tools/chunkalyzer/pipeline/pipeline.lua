local STAGE = require("tools/chunkalyzer/pipeline/stage")

-- When we call execute() on the pipeline, the pipeline iterates through the stages, and
-- executes the first stage with a successor that is complete.
-- Pipeline is complete when the first stage has a result.

return {
	create = function(self, name)
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

					timeElapsed = love.timer.getTime() - startTime
				end
			end,

			executeOneStep = function(self)
				local executeStageIndex = nil
				
				for n, stage in ipairs(self.stages) do
					if     stage:isProcessing() then executeStageIndex = n 
					elseif executeStageIndex    then break             end
				end

				if executeStageIndex == nil then
					print("ERROR: no stage to execute!")
				else
					local stageToExecute  = self.stages[executeStageIndex]
					local downStreamStage = self.stages[executeStageIndex + 1]
					
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
				return self.stages[1].results
			end,

			getTotalElapsedTime = function(self)
				return love.timer.getTime() - self.startTime
			end,
		}
	end,
}
