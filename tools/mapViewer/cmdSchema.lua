return {
	VERSION = 0.1,

	COMMANDS = {
		mapIn = {
			description = "map data file to read in, which links to chunks image as well",
			shortcut = "i",
			--required = true,
		},

		chunkDataIn = {
			description = "chunk data file to read in, construct impromptu map from",
			shortcut = "c",
		},
		
		chunkImageIn = {
			description = "chunk image to read in, construct impromptu map from",
			shortcut = "C",
		},
		
		mapOut = {
			description = "raw map image to write out",
			shortcut = "o",
		},
	},
}
