local MOVE  = requireRelative("world/badniks/scripts/commands/move")
local WAIT  = requireRelative("world/badniks/scripts/commands/wait")
local FLIPX = requireRelative("world/badniks/scripts/commands/flipX")

return {
	name    = "pacingBackAndForth",
	title   = "Pacing Back and Forth",
	program = {
		MOVE { numSeconds = 3, xSpeed = 50, },
		WAIT { numSeconds = 1,               },
		FLIPX(),
		WAIT { numSeconds = 1,               },
	},
}
