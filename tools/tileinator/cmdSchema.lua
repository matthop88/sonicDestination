return {
	VERSION = 0.1,

	COMMANDS = {
		chunkImageIn = {
			description = "image file with chunks derived from a world map",
			shortcut = "i",
			required = true,
		},

		chunkFileOut = {
			description = "chunk data file to write out",
			shortcut = "c",
		},

		mapFileIn = {
			description = "map data file which contains reference to chunks; will be modified",
			shortcut = "m",
		},

		tileImageOut = {
			description = "tiles image to write based upon chunk compression",
			shortcut = "t",
		},
	},
}
