--[[
		Pipeline consists of 4 Stages:

		Stage 1
		-------
		Task:          Grab Chunk from Chunk List
		Iterates Thru: Chunk List
		For Each:      Try to add Chunk to Chunk Repo via Stage 2.
		Breaks:        Does not break. Every chunk in list is processed.
		Returns:       Chunk ID for each chunk successful or unsuccessful.
		
		Stage 2
		-------
		Task:          Tries to add Chunk to Chunk Repo
		Iterates Thru: Chunk Repo
		For Each:      Compares Chunk to Repo Chunk via Stage 3. 
		Breaks:        If Stage 3 returns CHUNKS_EQUAL, immediately return CHUNK_NOT_ADDED with Chunk ID (somehow?)
		Returns:       CHUNK_ADDED if can finish without breaking. Also Chunk ID somehow?
		
		Stage 3 
		-------
		Task:          Compares Two Chunks 
		Iterates Thru: Rows of two Chunks  
		For Each:      Compares chunk rows via Stage 4.
		Breaks:        If Stage 4 returns CHUNK_ROW_NOT_EQUAL, immediately return CHUNKS_NOT_EQUAL   
		Returns:       CHUNKS_EQUAL if can finish without breaking

		Stage 4
		------- 
		Task:          Compares Row of Two Chunks
		Iterates Thru: NO ITERATION
		Returns:       CHUNK_ROWS_EQUAL if equal, CHUNK_ROWS_NOT_EQUAL if not equal

		Each Stage is READY or PROCESSING.

		If a stage is READY, will execute its task and return control to the calling thread.
		If a stage is not completed after execution, is set to PROCESSING.
		If a stage is PROCESSING, we will try to execute the ensuing stage in the Pipeline.
		If a stage is done processing, is reset to READY.

		Stages have information passed to them via parameters using a push() method.

		Example:

		1. Stage1:execute() is called. It is ready, so it grabs chunk1 from the Chunk list, and calls Stage2:push(chunk1)
		   Stage1 returns control to main thread.
		2. Stage1:execute() is called. It is processing, so Stage2:execute() is called.
		   Stage 2 is ready, so it grabs otherChunk1 from Chunk repo, and calls Stage3:push(chunk1, otherChunk1)
		   Stage2 returns control to main thread.
		3. Stage1:execute() is called. It is processing, so Stage2:execute() is called.
		   Stage 2 is processing, so Stage3:execute() is called.
		   Stage 3 is ready, so it grabs the row1 from chunk1 and otherRow1 from otherChunk1,
		   and calls Stage4:push(row1, otherRow1)
		   Returns control to main thread.
		4. Stage1:execute() ... Stage4:execute()
		   Stage 4 is ready, so it compares the rows. 
		   If the rows are equal, Stage 4 returns CHUNK_ROWS_EQUAL. Stage 4 remains in READY state.
		   If rows are unequal, Stage 4 returns CHUNK_ROWS_NOT_EQUAL.
		   Stage 3 breaks its process and returns CHUNKS_NOT_EQUAL. Stage 3 changes to READY state.
		   Stage 2 receives the return value and sets its state to READY.

		   etc.
--]]
