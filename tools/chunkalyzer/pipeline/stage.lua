return {
	create = function(self, stageObj)
		return {
			
			isReady       = function(self) return self.feeder:isComplete()   end,
			isComplete    = function(self) return self.feeder:isComplete()   end,
			isProcessing  = function(self) return self.feeder:isProcessing() end,
			
			self.stageObj = stageObj,
			
			execute = function(self, downStreamStage)
				if self.feeder == nil then
					-- ERROR!
				else
					self.result = self.taskFn(downStreamStage, self.feeder, downStreamStage:popResult())
				end
			end,

			push = function(self, data)
				self.feeder = FEEDER:create(data)
			end,

			popResult = function(self)
				local myResult = self.result
				self.result = nil
				return myResult
			end,

		}
	end,
}

-- When we call execute() on the pipeline, the pipeline iterates through the stages, and
-- executes the first stage with a successor that is complete.
-- When all stages are complete, capture the result of stage 1.

-- FEEDER creates an indexable wrapper around a data set.
-- If it is a list (size of > 0), simple.
-- If it is not a list (table with size of 0 or a non-table), inserts into table prior to wrapping.

--[[
	Stage #1 implementation:

	{
		init = function(self, chunkFeeder)
			self.chunks = chunkFeeder
			
			return self
		end,

		nextChunk = function(self, chunks, addToChunkRepoStage, result)
			local myChunk = chunks:next()

			if myChunk ~= nil then
				addToChunkRepoStage:push(myChunk)
			end

			if result ~= nil then
				return result
			end
		end,
	}


-- The feeder (chunks) is managed by the stage object
-- Feeder keeps track of index as well as the stage status

-- A stage is complete when feeder is finished
-- We execute a stage when its next one is complete

-- Example:
-- 0: S1 - | S2 X | S3 X | S4 X  => Execute S1. Pushes to S2, which sets stage to PROCESSING
-- 1: S1 - | S2 - | S3 X | S4 X  => Execute S2. Pushes to S3, which sets stage to PROCESSING
-- 2: S1 - | S2 - | S3 - | S4 X  => Execute S3. Pushes to S4, which sets stage to PROCESSING
-- 3: S1 - | S2 - | S3 - | S4 -  => Execute S4 (it's the last one). Stage goes back to COMPLETE because feeder only has 1 element!
-- 4: S1 - | S2 - | S3 - | S4 X  => Execute S3 with response from S4. CHUNK_ROWS_NOT_EQUAL
-- 5: S1 - | S2 - | S3 X | S4 X  => Execute S2 with response from S3. CHUNKS_NOT_EQUAL. Pushes to S3, which sets stage to PROCESSING
-- 6: S1 - | S2 - | S3 - | S4 X  => etc.

--]]
