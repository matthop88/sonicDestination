local MOVE_TOWARDS_EDGE  = requireRelative("world/badniks/scripts/commands/moveTowardsEdge")
local WAIT               = requireRelative("world/badniks/scripts/commands/wait")
local FLIPX              = requireRelative("world/badniks/scripts/commands/flipX")

return {
	name    = "pacingBackAndForth",
	title   = "Pacing Back and Forth",
	program = {
		MOVE_TOWARDS_EDGE { xSpeed     = 50, },
		WAIT              { numSeconds =  1, },
		FLIPX(),
		WAIT              { numSeconds =  1, },
	},
}
