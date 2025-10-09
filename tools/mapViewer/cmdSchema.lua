return {
	VERSION = 0.1,

	COMMANDS = {
		mapIn = {
			description = "map data file to read in, which links to chunks image as well",
			shortcut = "i",
			--required = true,
		},

		chunkImageIn = {
			description = "chunk image to read in, construct impromptu map from",
			shortcut = "c",
		},
		
		mapOut = {
			description = "raw map image to write out",
			shortcut = "o",
		},
	},
}
