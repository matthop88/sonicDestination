return {
	VERSION = 0.1,

	COMMANDS = {
		chunkDataIn = {
			description = "chunk data file to read in and doctor",
			shortcut = "i",
			required = true,
		},

		chunkDataOut = {
			description = "chunk data file to write out. (Defaults to value of chunkDataIn)",
			shortcut = "o",
		},
	},
}
