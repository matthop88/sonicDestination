--[[
	PIPELINE:add("Map Chunk Gobbler", processMapChunk)

	...

	PIPELINE:push(MAP_CHUNKS) -- Turns MAP_CHUNKS into a Feeder

	local timeElapsed = PIPELINE:execute(5) -- 5 milliseconds
--]]

local STAGE = require("tools/chunkalyzer/pipeline/stage")

-- When we call execute() on the pipeline, the pipeline iterates through the stages, and
-- executes the first stage with a successor that is complete.
-- When all stages are complete, capture the result of stage 1.

return {
	create = function(self, name)
		return {
			name = name,

			stages = {},

			execute = function(self, executionTimeInMs)
				local startTime = love.timer.getTime()

				local timeElapsed = 0

				while timeElapsed < executionTimeInMs / 1000 and not self:isComplete() do
					self:executeOneStep()

					timeElapsed = love.timer.getTime() - startTime
				end
				print("Time Elapsed: " .. timeElapsed)
			end,

			executeOneStep = function(self)
				local executeStageIndex = nil
				
				for n, stage in ipairs(self.stages) do
					if stage:isProcessing() then executeStageIndex = n end
				end

				if executeStageIndex == nil then
					-- ERROR!
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
				for _, s in ipairs(self.stages) do
					if s:isProcessing() then return false end
				end

				return true
			end,

			getResult = function(self)
				return self.stages[1].result
			end,
		}
	end,
}
